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
            let followingAccounts = try await dataStore.getFollowingAccounts(userAccount: viewingAccount)
            let events = try await dataStore.getEvents(viewing: viewingAccount, following: followingAccounts)
            return events
        }
    }

	var body: some View {
		VStack {
            ListTitleView(title: title)
            EventListView(eventListFetcher: eventListFetcher)
            VStack {
                ForEach(actions, id: \.identifier) { action in
                    ButtonView(baseStyle: .init(appFont: .large), action: action)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(4)
                }
            }
		}
		.padding(.horizontal, 16)
		.padding(.bottom, 16)
	}

    private let createNewEventActionIdentifier: String = UUID().uuidString
    private let subscribeToFriendsActionIdentifier: String = UUID().uuidString
    private var actions: [StringBuilder.Action] {
        [
            .bracket(
                "create new event",
                identifier: createNewEventActionIdentifier,
                color: .secondary,
                action: {
                    let route = try! DeepLinkParser.Route.sheet(.composer).url()
                    UIApplication.shared.open(route)
                }),
            .bracket(
                "subscribe to more friends",
                identifier: subscribeToFriendsActionIdentifier,
                color: .secondary,
                action: {
                    let route = try! DeepLinkParser.Route.push(.subscriptions).url()
                    UIApplication.shared.open(route)
                })
        ]
    }

	private var title: String {
		"untitled events widget"
	}

    private var eventListFetcher: EventListFetching {
        EventListFetcher(
            dataStoreProvider: dataStoreProvider,
            appSessionStore: appSessionStore
        )
    }
}
