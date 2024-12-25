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
                ForEach(buttons, id: \.identifier) { button in
                    Text(button.asAttributedString)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(4)
                }
            }
		}
		.padding(.horizontal, 16)
		.padding(.bottom, 16)
	}
    
    private var buttons: [ButtonModel] {
        [
            ButtonModel(
                identifier: UUID().uuidString,
                title: "create new event",
                color: .secondary,
                route: .sheet(.composer)
            ),
            ButtonModel(
                identifier: UUID().uuidString,
                title: "subscribe to more friends",
                color: .secondary,
                route: .push(.subscriptions)
            ),
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
