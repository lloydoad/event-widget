//
//  SubscriptionAppActionHandler.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/22/24.
//

import SwiftUI

@MainActor
struct SubscriptionAppActionHandler: AppActionHandler {
    enum ActionError: Error {
        case unhandledAction
    }

    let account: AccountModel
    let appSessionStore: AppSessionStore
    let dataStoreProvider: DataStoreProvider
    let onComplete: () -> Void

    var id: String {
        "SubscriptionAppActionHandler"
    }

    init(account: AccountModel, appSessionStore: AppSessionStore, dataStoreProvider: DataStoreProvider, onComplete: @escaping () -> Void) {
        self.account = account
        self.appSessionStore = appSessionStore
        self.dataStoreProvider = dataStoreProvider
        self.onComplete = onComplete
    }

    func canHandle(_ action: AppAction) -> Bool {
        switch action {
        case .subscribe, .unsubscribe:
            return true
        default:
            return false
        }
    }

    func handle(_ action: AppAction) async throws {
        guard let userAccount = appSessionStore.userAccount else { return }
        switch action {
        case .subscribe:
            try await dataStoreProvider.dataStore.addFollowing(account: userAccount, following: account)
            onComplete()
        case .unsubscribe:
            try await dataStoreProvider.dataStore.removeFollowing(account: userAccount, following: account)
            onComplete()
        default:
            throw ActionError.unhandledAction
        }
    }
}
