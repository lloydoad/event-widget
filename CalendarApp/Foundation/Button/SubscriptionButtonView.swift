//
//  SubscriptionButtonView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/22/24.
//

import SwiftUI

struct SubscriptionButtonView: View {
    enum ButtonType: Equatable {
        case loading
        case subscribe
        case unsubscribe
    }

    @EnvironmentObject var appSessionStore: AppSessionStore
    @EnvironmentObject var dataStoreProvider: DataStoreProvider

    private let subscribeActionUUID = UUID()
    private let unsubscribeActionUUID = UUID()

    let account: AccountModel
    @Binding var buttonType: ButtonType

    var body: some View {
        switch buttonType {
        case .loading:
            ProgressView()
                .transition(.blurReplace)
        case .subscribe:
            ButtonView(
                title: "subscribe",
                identifier: subscribeActionUUID.uuidString,
                font: .light,
                action: {
                    subscribe()
                })
                .transition(.blurReplace)
                .errorAlert(error: $error)
        case .unsubscribe:
            ButtonView(
                title: "unsubscribe",
                identifier: unsubscribeActionUUID.uuidString,
                font: .light,
                action: {
                    unsubscribe()
                })
                .transition(.blurReplace)
                .errorAlert(error: $error)
        }
    }

    private func subscribe() {
        guard let userAccount = appSessionStore.userAccount else { return }
        performRequest(request: {
            try await dataStoreProvider.dataStore.addFollowing(account: userAccount, following: account)
        }, finalType: .unsubscribe)
    }

    private func unsubscribe() {
        guard let userAccount = appSessionStore.userAccount else { return }
        performRequest(request: {
            try await dataStoreProvider.dataStore.removeFollowing(account: userAccount, following: account)
        }, finalType: .subscribe)
    }

    @State private var error: Error?
    @State private var currentTask: Task<Void, Never>?
    private func performRequest(request: @escaping () async throws -> Void, finalType: ButtonType) {
        currentTask?.cancel()
        buttonType = .loading
        currentTask = Task {
            do {
                try await request()
                await MainActor.run {
                    buttonType = finalType
                }
            } catch {
                await MainActor.run {
                    self.error = error
                }
            }
        }
    }
}
