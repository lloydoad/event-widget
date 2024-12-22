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

    enum Message: Equatable {
        case loading
        case subscribe
        case unsubscribe
    }

    let account: AccountModel
    let appSessionStore: AppSessionStore
    let dataStoreProvider: DataStoreProvider
    @Binding var message: Message

    var id: String {
        "SubscriptionAppActionHandler"
    }

    init(
        account: AccountModel,
        appSessionStore: AppSessionStore,
        dataStoreProvider: DataStoreProvider,
        message: Binding<Message>
    ) {
        self.account = account
        self.appSessionStore = appSessionStore
        self.dataStoreProvider = dataStoreProvider
        self._message = message
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
        message = .loading
        switch action {
        case .subscribe:
            try await dataStoreProvider.dataStore.addFollowing(account: userAccount, following: account)
            message = .unsubscribe
        case .unsubscribe:
            try await dataStoreProvider.dataStore.removeFollowing(account: userAccount, following: account)
            message = .subscribe
        default:
            throw ActionError.unhandledAction
        }
    }
}
