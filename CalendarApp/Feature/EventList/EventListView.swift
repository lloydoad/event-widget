//
//  EventListView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

struct EventListView: View {
    private enum Model: Equatable {
        case success(events: [EventModel])
        case loading
	}

    @EnvironmentObject var dataStoreProvider: DataStoreProvider
    let viewingAccount: AccountModel
    let eventWorker: EventWorking

    @State private var error: Error?
    @State private var model: Model = .loading
    @State private var eventActionMessage: EventActionHandler.ListMessage = .none

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
                        ForEach(events, id: \.uuid.uuidString) { event in
                            EventView(event: event, listMessage: $eventActionMessage)
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
        .onChange(of: eventActionMessage) { oldValue, newValue in
            if newValue == .refresh {
                Task {
                    await fetchLatestData()
                    eventActionMessage = .none
                }
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
            let events = try await eventWorker.fetchEventList(viewingAccount: viewingAccount, dataStore: dataStore)
            model = .success(events: events)
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
