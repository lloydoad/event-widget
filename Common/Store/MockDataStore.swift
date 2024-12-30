//
//  MockDataStore.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/26/24.
//

import Foundation

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
    static let lloydUUID = UUID(uuidString: "1344f260-5856-41ab-ba43-899d2f722dab")!
    static let ivoUUID = UUID()

    static let nickAccount = AccountModel(
        uuid: nickUUID,
        username: "nick",
        phoneNumber: "(555) 564-8583"
    )
    static let alanAccount = AccountModel(
        uuid: alanUUID,
        username: "alan",
        phoneNumber: "(555) 478-7672"
    )
    static let serenaAccount = AccountModel(
        uuid: serenaUUID,
        username: "serena",
        phoneNumber: "(301) 367-6763"
    )
    static let catAccount = AccountModel(
        uuid: catUUID,
        username: "cat",
        phoneNumber: "(555) 766-4823"
    )
    static let lloydAccount = AccountModel(
        uuid: lloydUUID,
        username: "Lloydoad",
        phoneNumber: "(301) 367-6761"
    )
    static let ivoAccount = AccountModel(
        uuid: ivoUUID,
        username: "ivo",
        phoneNumber: "(301) 367-6766"
    )
}

class MockDataStore: DataStoring {
    var accounts: [AccountModel]
    var followers: [UUID: [UUID]]
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
        self.followers = followings
        self.events = events
    }

    func getEventFeed(viewing account: AccountModel, limit: Int?) async throws -> [EventModel] {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
        let following = accounts.filter {
            (self.followers[$0.uuid] ?? []).contains(account.uuid)
        }.map(\.uuid)

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

    func create(event: EventModel) async throws -> EventModel {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
        events.append(event)
        return event
    }

    func isFollowing(follower: AccountModel, following: AccountModel) async throws -> Bool {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
        return (followers[follower.uuid] ?? []).contains(following.uuid)
    }

    func getSubscriptionFeed(viewer: AccountModel, localPhoneNumbers: [String]) async throws -> [AccountModel] {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
        let uuids = accounts.filter { account in
            (self.followers[account.uuid] ?? []).contains(viewer.uuid)
        }.map(\.uuid)

        var phoneNumberAccounts = Set(
            accounts.filter { account in
                localPhoneNumbers.contains(account.phoneNumber)
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

    func getAccountsFollowedBy(follower: AccountModel) async throws -> [UUID] {
        return accounts.filter { account in
            (self.followers[account.uuid] ?? []).contains(follower.uuid)
        }.map(\.uuid)
    }

    func follow(follower: AccountModel, following: AccountModel) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
        var newList = followers[follower.uuid, default: []]
        newList.append(following.uuid)
        followers[follower.uuid] = newList
    }

    func unfollow(follower: AccountModel, following: AccountModel) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
        var newList = followers[follower.uuid, default: []]
        newList.removeAll { $0 == following.uuid }
        followers[follower.uuid] = newList
    }

    func create(account: AccountModel, identifier: String) async throws {
        try await Task.sleep(nanoseconds: 2_500_000_000) // 2.5 second delay
        if accounts.contains(where: {
            $0.uuid == account.uuid
        }) {
            throw ErrorManager.with(loggedMessage: "This account already exists")
        }
        if accounts.contains(where: {
            isEqualPhoneNumber(lhs: $0.phoneNumber, rhs: account.phoneNumber)
        }) {
            throw ErrorManager.with(loggedMessage: "This phone number already exists")
        }
        accounts.append(account)
    }

    func getAccount(appleUserIdentifier: String) async throws -> AccountModel? {
        try await Task.sleep(nanoseconds: 290_000_000)
        return AccountModelMocks.lloydAccount
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

    func getAccounts(with phoneNumbers: [String], or uuids: [UUID]) async throws -> [AccountModel] {
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
