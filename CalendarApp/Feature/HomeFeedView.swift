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

	var body: some View {
		VStack {
            ListTitleView(title: "events")
            EventListView(
                identifier: "homeFeed",
                eventListFetcher: EventListFetcher(
                    dataStoreProvider: dataStoreProvider,
                    appSessionStore: appSessionStore
                )
            )
            VStack(spacing: 8) {
                Action("create new event", route: .sheet(.composer(nil)))
                Action("subcribe to more feeds", route: .push(.subscriptions))
                if let userAccount = appSessionStore.userAccount {
                    Action("my events", route: .push(.profile(userAccount)))
                }
            }
		}
		.padding(.horizontal, 16)
		.padding(.bottom, 16)
	}

    private func Action(_ title: String, route: DeepLinkParser.Route) -> some View {
        StringBuilder(baseStyle: .init(appFont: .large))
            .route(.bracket(title, route: route, color: .appTint))
            .view()
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
}
