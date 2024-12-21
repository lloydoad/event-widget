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
    func getFollowingAccounts(userAccount: AccountModel) async throws -> [UUID]
}

/**
 protocol FollowingGraphStoring {
     func createFollowing(account: AccountModel, following: AccountModel) async throws
     func getFollowing(account: AccountModel) async throws -> [AccountModel]
     func removeFollowing(account: AccountModel, following: AccountModel) async throws
 }
 */

class MockDataStore: DataStoring {
    enum StoreError: Error {
        case duplicateAccount
        case duplicatePhoneNumber
    }

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
        var dedupedEvents = [UUID: EventModel]()
        let eventsFromFollowing = events.filter { event in
            following.contains(event.creator.uuid)
        }
        let eventsFromAttending = events.filter { event in
            event.guests.map(\.uuid).contains(account.uuid)
        }
        let myEvents = events.filter { event in
            event.creator.uuid == account.uuid
        }
        (eventsFromFollowing + eventsFromAttending + myEvents).forEach {
            dedupedEvents[$0.uuid] = $0
        }
        return dedupedEvents.map(\.value).sorted { lhs, rhs in
            lhs.endDate > rhs.endDate
        }
    }
    
    func getFollowingAccounts(userAccount: AccountModel) async throws -> [UUID] {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
        return followings[userAccount.uuid] ?? []
    }
    
    func save(account: AccountModel) async throws {
        try await Task.sleep(nanoseconds: 2_500_000_000) // 2.5 second delay
        if accounts.contains(where: {
            $0.uuid == account.uuid
        }) {
            throw StoreError.duplicateAccount
        }
        if accounts.contains(where: {
            isEqualPhoneNumber(lhs: $0.phoneNumber, rhs: account.phoneNumber)
        }) {
            throw StoreError.duplicatePhoneNumber
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
