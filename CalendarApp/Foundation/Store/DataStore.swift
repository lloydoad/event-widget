//
//  AccountStore.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/20/24.
//

import SwiftUI

protocol DataStoring {
    func save(account: AccountModel) async throws
    func getAccounts(with phoneNumbers: [String], and uuids: [UUID]) async throws -> [AccountModel]

    func getEvents(viewing account: AccountModel, following: [UUID]) async throws -> [EventModel]
    func getEvents(creator account: AccountModel) async throws -> [EventModel]
    func getEvent(uuid: UUID) async throws -> EventModel?
    func joinEvent(guest account: AccountModel, event: EventModel) async throws
    func leaveEvent(guest account: AccountModel, event: EventModel) async throws
    func deleteEvent(creator account: AccountModel, event: EventModel) async throws
    func addEvent(event: EventModel) async throws

    func getFollowingAccounts(userAccount: AccountModel) async throws -> [UUID]
    func addFollowing(account: AccountModel, following: AccountModel) async throws
    func removeFollowing(account: AccountModel, following: AccountModel) async throws
}

class DataStoreProvider: ObservableObject {
    @Published var dataStore: DataStoring

    init(dataStore: DataStoring) {
        self.dataStore = dataStore
    }
}

// MARK: - Mocks

struct EventModelMocks {
    static func event(
        creator: AccountModel,
        description: String = "building lego till 8 or later. I'm not sure",
        location: LocationModel = LocationModel(
            address: "235 Valencia St",
            city: "San Francisco",
            state: "California"
        ),
        startDate: Date = .now,
        endDate: Date = .now,
        guests: [AccountModel] = [
            AccountModelMocks.nickAccount,
            AccountModelMocks.alanAccount,
            AccountModelMocks.serenaAccount,
            AccountModelMocks.catAccount
        ]
    ) -> EventModel {
        EventModel(
            uuid: .init(),
            creator: creator,
            description: description,
            startDate: startDate,
            endDate: endDate,
            location: location,
            guests: guests
        )
    }
}

struct AccountModelMocks {
    static let alanUUID = UUID()
    static let serenaUUID = UUID()
    static let nickUUID = UUID()
    static let catUUID = UUID()
    static let lloydUUID = UUID()
    static let ivoUUID = UUID()

    static let nickAccount = AccountModel(
        uuid: nickUUID,
        username: "nick",
        phoneNumber: "(555) 564-8583"
    )
    static let alanAccount = AccountModel(
        uuid: alanUUID,
        username: "alan",
        phoneNumber: "555-478-7672"
    )
    static let serenaAccount = AccountModel(
        uuid: serenaUUID,
        username: "serena",
        phoneNumber: "301-367-6763"
    )
    static let catAccount = AccountModel(
        uuid: catUUID,
        username: "cat",
        phoneNumber: "(555) 766-4823"
    )
    static let lloydAccount = AccountModel(
        uuid: lloydUUID,
        username: "lloyd",
        phoneNumber: "301-367-6765"
    )
    static let ivoAccount = AccountModel(
        uuid: ivoUUID,
        username: "ivo",
        phoneNumber: "301-367-6766"
    )
}

class MockDataStore: DataStoring {
    var accounts: [AccountModel]
    var followings: [UUID: [UUID]]
    var events: [EventModel]

    init(
        accounts: [AccountModel] = [
            AccountModelMocks.alanAccount,
            AccountModelMocks.serenaAccount,
            AccountModelMocks.nickAccount,
            AccountModelMocks.catAccount,
            AccountModelMocks.lloydAccount,
            AccountModelMocks.ivoAccount,
        ],
        followings: [UUID : [UUID]] = [
            AccountModelMocks.lloydUUID: [AccountModelMocks.nickUUID, AccountModelMocks.ivoUUID]
        ],
        events: [EventModel] = [
            EventModelMocks.event(
                creator: AccountModelMocks.serenaAccount,
                description: "meditation at the SF Dharma collective. will be focused on emotions",
                startDate: DateFormatter().createDate(hour: 19, minute: 30)!,
                endDate: DateFormatter().createDate(hour: 21, minute: 30)!,
                guests: [
                    AccountModelMocks.alanAccount,
                    AccountModelMocks.lloydAccount,
                    AccountModelMocks.ivoAccount
                ]
            ),
            EventModelMocks.event(
                creator: AccountModelMocks.nickAccount,
                description: "building lego till 8pm or later. idk",
                location: LocationModel(
                    address: "1 haight st",
                    city: "san francisco",
                    state: "california"
                ),
                startDate: DateFormatter().createDate(hour: 17, minute: 00)!,
                endDate: DateFormatter().createDate(hour: 21, minute: 00)!,
                guests: []
            ),
            EventModelMocks.event(
                creator: AccountModelMocks.lloydAccount,
                description: "thinking about going to a comedy after work. open to ideas",
                location: LocationModel(
                    address: "250 fell st",
                    city: "san francisco",
                    state: "california"
                ),
                startDate: DateFormatter().createDate(hour: 12, minute: 00)!,
                endDate: DateFormatter().createDate(hour: 15, minute: 00)!,
                guests: []
            ),
            EventModelMocks.event(
                creator: AccountModelMocks.nickAccount,
                description: "anyone down to smash 👀 (as-in nintendo smash)",
                location: LocationModel(
                    address: "250 king st",
                    city: "san francisco",
                    state: "california"
                ),
                startDate: DateFormatter().createDate(hour: 4, minute: 00)!,
                endDate: DateFormatter().createDate(hour: 7, minute: 00)!,
                guests: []
            ),
            EventModelMocks.event(
                creator: AccountModelMocks.lloydAccount,
                description: "lets go around town and be spooky",
                location: LocationModel(
                    address: "1 california st",
                    city: "san francisco",
                    state: "california"
                ),
                startDate: DateFormatter().createDate(hour: 1, minute: 30)!,
                endDate: DateFormatter().createDate(hour: 4, minute: 15)!,
                guests: [AccountModelMocks.serenaAccount]
            ),
            EventModelMocks.event(
                creator: AccountModelMocks.catAccount,
                description: "ipsum lorem",
                guests: [
                    AccountModelMocks.catAccount,
                    AccountModelMocks.alanAccount
                ]),
            EventModelMocks.event(
                creator: AccountModelMocks.alanAccount,
                description: "ipsum lorem delores",
                guests: [
                    AccountModelMocks.catAccount,
                    AccountModelMocks.serenaAccount
                ]),
            EventModelMocks.event(
                creator: AccountModelMocks.nickAccount,
                description: "ipsum lorem delores cat",
                guests: [
                    AccountModelMocks.ivoAccount
                ])
        ]
    ) {
        self.accounts = accounts
        self.followings = followings
        self.events = events
    }

    func getEvents(viewing account: AccountModel, following: [UUID]) async throws -> [EventModel] {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
        let eventsFromFollowing = events.filter { event in
            following.contains(event.creator.uuid)
        }
        let eventsFromAttending = events.filter { event in
            event.guests.map(\.uuid).contains(account.uuid)
        }
        let myEvents = events.filter { event in
            event.creator.uuid == account.uuid
        }
        let dedupedEvents = Array(Set(eventsFromFollowing + eventsFromAttending + myEvents))
        return dedupedEvents.sorted { lhs, rhs in
            lhs.endDate > rhs.endDate
        }
    }

    func getEvents(creator account: AccountModel) async throws -> [EventModel] {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
        let eventsFromCreator = events.filter { $0.creator.uuid == account.uuid }
        return eventsFromCreator.sorted { lhs, rhs in
            lhs.endDate > rhs.endDate
        }
    }

    func getEvent(uuid: UUID) async throws -> EventModel? {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
        let event = events.first(where: { $0.uuid == uuid })
        return event
    }

    func joinEvent(guest account: AccountModel, event: EventModel) async throws {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
        let index = events.firstIndex(where: { $0.uuid == event.uuid })
        guard let index else { return }
        var newEvent = events[index]
        if !newEvent.guests.contains(account) {
            newEvent.guests.append(account)
        }
        events[index] = newEvent
    }

    func leaveEvent(guest account: AccountModel, event: EventModel) async throws {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
        let index = events.firstIndex(where: { $0.uuid == event.uuid })
        guard let index else { return }
        var newEvent = events[index]
        if newEvent.guests.contains(account) {
            newEvent.guests.removeAll(where: { $0 == account })
        }
        events[index] = newEvent
    }

    func deleteEvent(creator account: AccountModel, event: EventModel) async throws {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
        events.removeAll(where: { $0 == event && $0.creator == account })
    }

    func addEvent(event: EventModel) async throws {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
        events.append(event)
    }

    func getFollowingAccounts(userAccount: AccountModel) async throws -> [UUID] {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
        return followings[userAccount.uuid] ?? []
    }

    func addFollowing(account: AccountModel, following: AccountModel) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
        var newList = followings[account.uuid, default: []]
        newList.append(following.uuid)
        followings[account.uuid] = newList
    }

    func removeFollowing(account: AccountModel, following: AccountModel) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
        var newList = followings[account.uuid, default: []]
        newList.removeAll { $0 == following.uuid }
        followings[account.uuid] = newList
    }

    func save(account: AccountModel) async throws {
        try await Task.sleep(nanoseconds: 2_500_000_000) // 2.5 second delay
        if accounts.contains(where: {
            $0.uuid == account.uuid
        }) {
            throw ErrorManager.with(message: "This account already exists")
        }
        if accounts.contains(where: {
            isEqualPhoneNumber(lhs: $0.phoneNumber, rhs: account.phoneNumber)
        }) {
            throw ErrorManager.with(message: "This phone number already exists")
        }
        accounts.append(account)
    }

    private func isEqualPhoneNumber(lhs: String, rhs: String) -> Bool {
        lhs.filter(\.isNumber) == rhs.filter(\.isNumber)
    }

    func getAccounts(with uuids: [UUID]) async throws -> [AccountModel] {
        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 second delay
        return accounts.compactMap { account in
            uuids.contains(account.uuid) ? account : nil
        }
    }

    func getAccounts(with phoneNumbers: [String], and uuids: [UUID]) async throws -> [AccountModel] {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
        var phoneNumberAccounts = Set(
            accounts.filter { account in
                phoneNumbers.contains(account.phoneNumber)
            }
        )
        let uuidAccounts = Set(
            accounts.compactMap { account in
               uuids.contains(account.uuid) ? account : nil
           }
        )
        for uuidAccount in uuidAccounts {
            phoneNumberAccounts.insert(uuidAccount)
        }
        return Array(phoneNumberAccounts)
    }
}
