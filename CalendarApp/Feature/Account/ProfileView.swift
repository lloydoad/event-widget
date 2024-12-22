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
    @State private var error: Error?

	var body: some View {
		VStack {
			ScrollView {
				VStack(spacing: 16) {
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
                    // TODO: add a subscribe button
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
        }
	}

    func fetchEvents() {
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
}
