//
//  EventListView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

struct EventListView: View {
    private enum Model: Equatable {
        case success(events: [ListItemView.Model])
        case loading
	}

    @EnvironmentObject var dataStoreProvider: DataStoreProvider
    let viewingAccount: AccountModel
    let eventWorker: EventWorking

    @State private var error: Error?
    @State private var model: Model = .loading

	var body: some View {
		VStack {
            ListTitleView(title: title)
            switch model {
            case .loading:
                VStack {
                    Spacer().frame(maxHeight: .infinity)
                    ProgressView()
                    Spacer().frame(maxHeight: .infinity)
                }
                .transition(.blurReplace)
            case .success(let events):
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(events, id: \.hashValue) { event in
                            ListItemView(model: event)
                                .padding(.bottom, 16)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .transition(.blurReplace)
            }
            VStack {
                ForEach(buttons, id: \.identifier) { button in
                    Text(button.asAttributedString)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(4)
                }
            }
		}
        .animation(.easeInOut, value: model)
		.padding(.horizontal, 16)
		.padding(.bottom, 16)
        .errorAlert(error: $error)
        .onAppear {
            Task {
                await fetchLatestData()
            }
        }
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

    private func fetchLatestData() async {
        do {
            let dataStore = dataStoreProvider.dataStore
            let result = try await eventWorker.fetchEventList(viewingAccount: viewingAccount, dataStore: dataStore)
            let eventViewModels = try result.map { event in
                try ListItemView.Model.event(viewer: viewingAccount, event: event)
            }
            model = .success(events: eventViewModels)
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
            ]
        )
    )
    .environmentObject(DataStoreProvider(dataStore: MockDataStore()))
    EventListView(
        viewingAccount: AccountModelMocks.catAccount,
        eventWorker: MockEventWorker(
            events: [
                EventModelMocks.event(creator: AccountModelMocks.lloydAccount, guests: [AccountModelMocks.catAccount])
            ]
        )
    )
    .environmentObject(DataStoreProvider(dataStore: MockDataStore()))
    EventListView(
        viewingAccount: AccountModelMocks.catAccount,
        eventWorker: MockEventWorker(
            events: [
                EventModelMocks.event(creator: AccountModelMocks.lloydAccount, guests: [])
            ]
        )
    )
    .environmentObject(DataStoreProvider(dataStore: MockDataStore()))
}
