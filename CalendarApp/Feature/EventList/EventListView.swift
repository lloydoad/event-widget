//
//  EventListView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

struct EventView: View {
    struct Model: Hashable, Codable {
        var content: AttributedString
        var controls: AttributedString
    }

    @EnvironmentObject var actionCoordinator: AppActionCoordinator
    @EnvironmentObject var appSessionStore: AppSessionStore
    @EnvironmentObject var dataStoreProvider: DataStoreProvider

    let event: EventModel
    @Binding var listMessage: EventActionHandler.ListMessage
    @State private var itemMessage: EventActionHandler.ItemMessage = .showControl

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(eventContent)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                switch itemMessage {
                case .showControl:
                    if let viewingAccount = appSessionStore.userAccount {
                        if event.joinable(viewer: viewingAccount) {
                            ButtonView(
                                action: .join(event: event),
                                font: .light,
                                actionCoordinator: actionCoordinator
                            )
                            .onAction(handler: actionHandler)
                        }
                        if event.cancellable(viewer: viewingAccount) {
                            ButtonView(
                                action: .cantGo(event: event),
                                font: .light,
                                actionCoordinator: actionCoordinator
                            )
                            .onAction(handler: actionHandler)
                        }
                        if event.deletable(viewer: viewingAccount) {
                            ButtonView(
                                action: .delete(event: event),
                                font: .light,
                                actionCoordinator: actionCoordinator
                            )
                            .onAction(handler: actionHandler)
                        }
                    }
                case .loading:
                    ProgressView()
                }
                Spacer()
            }
        }
    }

    private var eventContent: AttributedString {
        guard let viewingAccount = appSessionStore.userAccount else { return "" }
        do {
            if event.isActive() {
                return try ListItemView.Model.eventContent(viewer: viewingAccount, event: event)
            } else {
                return try ListItemView.Model.expiredEventContent(event: event)
            }
        } catch {
            return "event details unavailable"
        }
    }

    private var actionHandler: EventActionHandler {
        EventActionHandler(
            event: event,
            appSessionStore: appSessionStore,
            dataStoreProvider: dataStoreProvider,
            listMessage: $listMessage,
            itemMessage: $itemMessage
        )
    }
}

@MainActor
struct EventActionHandler: AppActionHandler {
    enum ActionError: Error {
        case unhandledAction
    }

    enum ListMessage: Equatable {
        case none
        case refresh
    }

    enum ItemMessage: Equatable {
        case showControl
        case loading
    }

    let event: EventModel
    let appSessionStore: AppSessionStore
    let dataStoreProvider: DataStoreProvider
    @Binding var listMessage: ListMessage
    @Binding var itemMessage: ItemMessage

    var id: String {
        "EventActionHandler-\(event.uuid.uuidString)"
    }

    init(
        event: EventModel,
        appSessionStore: AppSessionStore,
        dataStoreProvider: DataStoreProvider,
        listMessage: Binding<ListMessage>,
        itemMessage: Binding<ItemMessage>
    ) {
        self.event = event
        self.appSessionStore = appSessionStore
        self.dataStoreProvider = dataStoreProvider
        self._listMessage = listMessage
        self._itemMessage = itemMessage
    }

    func canHandle(_ action: AppAction) -> Bool {
        switch action {
        case .join(let event), .delete(let event), .cantGo(let event):
            return id.contains(event.uuid.uuidString)
        default:
            return false
        }
    }

    func handle(_ action: AppAction) async throws {
        guard let userAccount = appSessionStore.userAccount else { return }
        itemMessage = .loading
        switch action {
        case .join:
            try await dataStoreProvider.dataStore.joinEvent(guest: userAccount, event: event)
            listMessage = .refresh
            break
        case .delete:
            try await dataStoreProvider.dataStore.deleteEvent(creator: userAccount, event: event)
            listMessage = .refresh
            break
        case .cantGo:
            try await dataStoreProvider.dataStore.leaveEvent(guest: userAccount, event: event)
            listMessage = .refresh
            break
        default:
            throw ActionError.unhandledAction
        }
    }
}

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
