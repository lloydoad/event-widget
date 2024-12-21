//
//  EventListView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

struct EventListView: View {
	private enum Model {
        case loading
        case success(events: [ListItemView.Model], subscription: AccountListView.Model)
	}

    var viewingAccount: AccountModel
    var eventWorker: EventWorking

    @State private var error: Error?
    @State private var model: Model = .loading

	var body: some View {
        
		VStack {
            switch model {
            case .loading:
                ZStack {
                    ProgressView()
                }
            case .success(let events, let subscription):
                ScrollView {
                    VStack(spacing: 16) {
                        ListTitleView(title: title)
                        ForEach(events, id: \.hashValue) { event in
                            ListItemView(model: event)
                                .padding(.bottom, 16)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                VStack {
                    ForEach(buttons(subscription: subscription), id: \.self) { button in
                        Text(button.asAttributedString)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(4)
                    }
                }
            }
		}
		.padding(.horizontal, 16)
		.padding(.bottom, 16)
        .errorAlert(error: $error)
        .onAppear {
            Task {
                await fetchLatestData()
            }
        }
	}
    
    private func buttons(subscription: AccountListView.Model) -> [ButtonModel] {
        [
            ButtonModel(
                title: "create new event",
                color: .secondary,
                route: .sheet(.composer)
            ),
            ButtonModel(
                title: "subscribe to more friends",
                color: .secondary,
                route: .push(.subscriptions(subscription))
            ),
        ]
    }

	private var title: String {
		"untitled events widget"
	}
    
    private func fetchLatestData() async {
        do {
            let result = try await eventWorker.fetchEventList(viewingAccount: viewingAccount)
            let eventViewModels = try result.events.map {
                try ListItemView.Model.event(
                    viewer: viewingAccount,
                    following: result.following.map(\.uuid),
                    event: $0
                )
            }
            let followingViewModels = try result.following.map {
                try ListItemView.Model.account(
                    viewer: viewingAccount,
                    account: $0,
                    following: result.following.map(\.uuid)
                )
            }
            model = .success(
                events: eventViewModels,
                subscription: .init(variant: .subscriptions, accounts: followingViewModels)
            )
        } catch {
            self.error = error
        }
    }
}

#Preview {
    EventListView(
        viewingAccount: AccountModelMocks.catAccount,
        eventWorker: MockEventWorker(
            events: [
                EventModelMocks.event(
                    creator: AccountModelMocks.lloydAccount,
                    description: "meditation at the SF Dharma collective. will be focused on emotions",
                    startDate: DateFormatter().createDate(hour: 19, minute: 30)!,
                    endDate: DateFormatter().createDate(hour: 21, minute: 30)!,
                    guests: []
                )
            ],
            following: [
                AccountModelMocks.lloydAccount
            ]
        )
    )
    EventListView(
        viewingAccount: AccountModelMocks.catAccount,
        eventWorker: MockEventWorker(
            events: [
                EventModelMocks.event(creator: AccountModelMocks.lloydAccount, guests: [AccountModelMocks.catAccount])
            ],
            following: [AccountModelMocks.lloydAccount]
        )
    )
    EventListView(
        viewingAccount: AccountModelMocks.catAccount,
        eventWorker: MockEventWorker(
            events: [
                EventModelMocks.event(creator: AccountModelMocks.lloydAccount, guests: [])
            ],
            following: []
        )
    )
}
