//
//  HomeFeedView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/24/24.
//

import SwiftUI

struct HomeFeedView: View {
    @EnvironmentObject var dataStoreProvider: DataStoreProvider
    @EnvironmentObject var appSessionStore: AppSessionStore

    struct EventListFetcher: EventListFetching {
        var dataStoreProvider: DataStoreProvider
        var appSessionStore: AppSessionStore

        func fetchLatestData() async throws -> [EventModel] {
            guard let viewingAccount = appSessionStore.userAccount else { return [] }
            let dataStore = dataStoreProvider.dataStore
            let events = try await dataStore.getEventFeed(viewing: viewingAccount, limit: nil)
            return events
        }
    }

    private let title = "untitled events widget"

	var body: some View {
		VStack {
            ListTitleView(title: title)
            EventListView(
                eventListFetcher: EventListFetcher(
                    dataStoreProvider: dataStoreProvider,
                    appSessionStore: appSessionStore
                )
            )
            VStack(spacing: 8) {
                ForEach(actions, id: \.identifier) { action in
                    ButtonView(baseStyle: .init(appFont: .large), action: action)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                if let userAccount = appSessionStore.userAccount {
                    StringBuilder(baseStyle: .init(appFont: .large))
                        .route(.bracket(
                            "my events",
                            page: .profile(userAccount),
                            color: .secondary))
                        .view()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
		}
		.padding(.horizontal, 16)
		.padding(.bottom, 16)
	}

    private var actions: [StringBuilder.Action] {
        [
            .bracket(
                "create new event",
                identifier: ButtonIdentifier.createNewEventAction,
                color: .secondary,
                action: {
                    let route = try! DeepLinkParser.Route.sheet(.composer(nil)).url()
                    UIApplication.shared.open(route)
                }),
            .bracket(
                "subscribe to more friends",
                identifier: ButtonIdentifier.subscribeToFriendsAction,
                color: .secondary,
                action: {
                    let route = try! DeepLinkParser.Route.push(.subscriptions).url()
                    UIApplication.shared.open(route)
                })
        ]
    }
}
