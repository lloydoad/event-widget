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

    @State private var subscriptionButtonType: SubscriptionButtonView.ButtonType = .loading
    @State private var error: Error?

	var body: some View {
		VStack {
            ListTitleView(title: "events by \(account.username)")
            if appSessionStore.userAccount != account {
                HStack {
                    SubscriptionButtonView(account: account, buttonType: $subscriptionButtonType)
                    Spacer()
                }
            }
            EventListView(
                identifier: "profile",
                eventListFetcher: ProfileEventListFetcher(
                    dataStoreProvider: dataStoreProvider,
                    account: account
                )
            )
		}
        .errorAlert(error: $error)
        .animation(.easeInOut, value: subscriptionButtonType)
		.padding(.horizontal, 16)
		.padding(.bottom, 16)
        .onAppear {
            fetchSubscription()
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

    private func fetchSubscription() {
        guard let userAccount = appSessionStore.userAccount else { return }
        guard account != userAccount else { return }
        Task {
            do {
                let isFollowing = try await dataStoreProvider.dataStore.isFollowing(
                    follower: userAccount,
                    following: account
                )
                await MainActor.run {
                    self.subscriptionButtonType = isFollowing ? .unsubscribe : .subscribe
                }
            } catch {
                self.error = error
            }
        }
    }
}
