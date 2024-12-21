//
//  EventWorker.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/20/24.
//

import SwiftUI

typealias FetchEventResult = ([EventModel])

@MainActor
protocol EventWorking {
    func fetchEventList(viewingAccount: AccountModel) async throws -> FetchEventResult
}

struct MockEventWorker: EventWorking {
    var events: [EventModel]
    
    func fetchEventList(viewingAccount: AccountModel) async throws -> FetchEventResult {
        (events)
    }
}

@MainActor
class EventWorker: EventWorking {
    let dataStore: DataStoring
    private var currentTask: Task<FetchEventResult, Error>?

    init(dataStore: DataStoring) {
        self.dataStore = dataStore
    }

    func fetchEventList(viewingAccount: AccountModel) async throws -> FetchEventResult {
        currentTask?.cancel()
        let task: Task<FetchEventResult, Error> = Task { @MainActor in
            let followingAccounts = try await dataStore.getFollowingAccounts(userAccount: viewingAccount)
            let events = try await dataStore.getEvents(viewing: viewingAccount, following: followingAccounts)
            return (events)
        }
        currentTask = task
        return try await task.value
    }
}
