//
//  AccountStore.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/20/24.
//

import Foundation

protocol AccountDataStoring {
    func create(account: AccountModel, identifier: String) async throws
    func getAccount(appleUserIdentifier: String) async throws -> AccountModel?
}

protocol EventDataStoring {
    func create(event: EventModel) async throws -> EventModel
    func joinEvent(guest account: AccountModel, event: EventModel) async throws
    func leaveEvent(guest account: AccountModel, event: EventModel) async throws
    func deleteEvent(creator account: AccountModel, event: EventModel) async throws

    func getEventFeed(viewing account: AccountModel) async throws -> [EventModel]
    func getEvents(creator account: AccountModel) async throws -> [EventModel]
    func getEvent(uuid: UUID) async throws -> EventModel?
}

protocol FollowerDataStoring {
    func isFollowing(follower: AccountModel, following: AccountModel) async throws -> Bool
    func getSubscriptionFeed(viewer: AccountModel, localPhoneNumbers: [String]) async throws -> [AccountModel]
    func follow(follower: AccountModel, following: AccountModel) async throws
    func unfollow(follower: AccountModel, following: AccountModel) async throws
}

protocol DataStoring: AccountDataStoring, EventDataStoring, FollowerDataStoring { }

class DataStoreProvider: ObservableObject {
    @Published var dataStore: DataStoring

    init(dataStore: DataStoring) {
        self.dataStore = dataStore
    }
}
