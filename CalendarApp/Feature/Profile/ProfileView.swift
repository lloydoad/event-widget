//
//  ProfileView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/18/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appSessionStore: AppSessionStore
    @EnvironmentObject var dataStoreProvider: DataStoreProvider

    let account: AccountModel

    private let listIdentifier: String = "profile"
    @State private var controlResult: AccountControl.Result = .unknown
    @State private var error: Error?

	var body: some View {
		VStack {
            Text(content())
                .frame(maxWidth: .infinity, alignment: .leading)
            EventListView(
                identifier: "profile",
                eventListFetcher: ProfileEventListFetcher(
                    dataStoreProvider: dataStoreProvider,
                    account: account
                )
            )
		}
        .errorAlert(error: $error)
        .animation(.easeInOut, value: controlResult)
		.padding(.horizontal, 16)
		.padding(.bottom, 16)
        .onAppear {
            registerActions()
            perform(control: .getSubscriptionStatus)
        }
        .onDisappear {
            unregisterActions()
        }
	}

    // MARK: Network

    struct ProfileEventListFetcher: EventListFetching {
        var dataStoreProvider: DataStoreProvider
        var account: AccountModel

        func fetchLatestData() async throws -> [EventModel] {
            return try await dataStoreProvider.dataStore.getEvents(creator: account)
        }
    }

    private func content() -> AttributedString {
        var builder = StringBuilder(baseStyle: .init(appFont: .navigationTitle))
        if account != appSessionStore.userAccount {
            switch controlResult {
            case .unknown:
                builder = builder.text(.colored("... ", color: .appTint))
            case .subscribed:
                builder = builder
                    .action(.bracket(
                        "unsubscribe",
                        identifier: AccountControl
                            .unsubscribe
                            .identifier(account: account, listIdentifier: listIdentifier),
                        color: .appTint,
                        action: {}
                    ))
                    .text(.primary(" from "))
            case .notSubscribed:
                builder = builder
                    .action(.bracket(
                        "subscribe",
                        identifier: AccountControl
                            .subscribe
                            .identifier(account: account, listIdentifier: listIdentifier),
                        color: .appTint,
                        action: {}
                    ))
                    .text(.primary(" to "))
            }
        }
        builder = builder.text(.primary("events by \(account.username)"))
        return builder.build()
    }

    private func registerActions() {
        for control in AccountControl.allCases {
            ActionCentralDispatch
                .shared
                .register(
                    identifier: control.identifier(account: account, listIdentifier: listIdentifier),
                    action: {
                        perform(control: control)
                    }
                )
        }
    }

    private func unregisterActions() {
        for control in AccountControl.allCases {
            ActionCentralDispatch
                .shared
                .deregister(
                    identifier: control.identifier(account: account, listIdentifier: listIdentifier)
                )
        }
    }

    @State private var currentTask: Task<Void, Never>?
    private func perform(control: AccountControl) {
        guard let userAccount = appSessionStore.userAccount else { return }
        let dataStore = dataStoreProvider.dataStore
        currentTask?.cancel()
        controlResult = .unknown
        currentTask = Task {
            do {
                let result = try await control.action(userAccount: userAccount, account: account, dataStore: dataStore)
                await MainActor.run {
                    controlResult = result
                }
            } catch {
                await MainActor.run {
                    self.error = error
                }
            }
        }
    }
}
