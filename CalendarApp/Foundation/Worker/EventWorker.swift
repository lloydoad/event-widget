//
//  EventWorker.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/20/24.
//

import SwiftUI

@MainActor
protocol EventWorking {
    func fetchEventList(
        viewingAccount: AccountModel,
        onSuccess: @escaping (_ events: [EventModel], _ following: [AccountModel]) -> Void,
        onError: @escaping (Error) -> Void
    )
}

struct MockEventWorker: EventWorking {
    var events: [EventModel]
    var following: [AccountModel]
    
    func fetchEventList(
        viewingAccount: AccountModel,
        onSuccess: @escaping (_ events: [EventModel], _ following: [AccountModel]) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        onSuccess(events, following)
    }
}

@MainActor
class EventWorker: EventWorking {
    let dataStore: DataStoring

    init(dataStore: DataStoring) {
        self.dataStore = dataStore
    }

    private var eventListTask: Task<Void, Never>?
    func fetchEventList(
        viewingAccount: AccountModel,
        onSuccess: @escaping (_ events: [EventModel], _ following: [AccountModel]) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        eventListTask?.cancel()
        eventListTask = Task { @MainActor in
            do {
                let followingAccounts = try await dataStore.getFollowingAccounts(userAccount: viewingAccount)
                let events = try await dataStore.getEvents(viewing: viewingAccount, following: followingAccounts)
                onSuccess(events, followingAccounts)
            } catch {
                if !Task.isCancelled {
                    onError(error)
                }
            }
        }
    }
}
