//
//  ProfileView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/18/24.
//

import SwiftUI

struct ProfileView: View {
    enum Model: Equatable {
        case loading
        case success([ListItemView.Model])
    }

    @EnvironmentObject var appSessionStore: AppSessionStore
    @EnvironmentObject var dataStoreProvider: DataStoreProvider
    let account: AccountModel

    @State private var eventViewModels: Model = .loading
    @State private var subscriptionButtonModel: SubscriptionAppActionHandler.Message = .loading
    @State private var error: Error?

    var titleView: some View {
        switch eventViewModels {
        case .loading:
            ListTitleView(title: "fetching events by \(account.username)")
                .transition(.blurReplace)
        case .success(let array):
            if array.isEmpty {
                ListTitleView(title: "no events by \(account.username) yet!")
                    .transition(.blurReplace)
            } else {
                ListTitleView(title: "events by \(account.username)")
                    .transition(.blurReplace)
            }
        }
    }

	var body: some View {
		VStack {
			ScrollView {
				VStack(spacing: 16) {
                    titleView
                    if appSessionStore.userAccount != account {
                        HStack {
                            SubscriptionButtonView(account: account, message: $subscriptionButtonModel)
                            Spacer()
                        }
                    }
                    switch eventViewModels {
                    case .loading:
                        ZStack {
                            ProgressView()
                        }
                        .transition(.blurReplace)
                    case .success(let viewModels):
                        ForEach(viewModels, id: \.hashValue) { viewModel in
                            ListItemView(model: viewModel)
                                .padding(.bottom, 16)
                        }
                        .transition(.blurReplace)
                    }
				}
				.frame(maxWidth: .infinity)
                .animation(.easeInOut, value: eventViewModels)
			}
		}
		.padding(.horizontal, 16)
		.padding(.bottom, 16)
        .onAppear {
            fetchEvents()
            fetchSubscription()
        }
	}

    // MARK: Network

    private func fetchEvents() {
        Task {
            do {
                guard let viewer = appSessionStore.userAccount else { return }
                let eventModels = try await dataStoreProvider.dataStore.getEvents(creator: account)
                eventViewModels = .success(
                    try eventModels.map { eventModel in
                        try ListItemView.Model.event(viewer: viewer, event: eventModel)
                    }
                )
            } catch {
                self.error = error
            }
        }
    }

    private func fetchSubscription() {
        guard let userAccount = appSessionStore.userAccount else { return }
        guard account != userAccount else { return }
        Task {
            do {
                let following = try await dataStoreProvider
                    .dataStore
                    .getFollowingAccounts(userAccount: userAccount)
                if following.contains(account.uuid) {
                    subscriptionButtonModel = .unsubscribe
                } else {
                    subscriptionButtonModel = .subscribe
                }
            } catch {
                self.error = error
            }
        }
    }
}
