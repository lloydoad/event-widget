//
//  EventActionHandler.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/24/24.
//

import SwiftUI

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
        case .delete:
            try await dataStoreProvider.dataStore.deleteEvent(creator: userAccount, event: event)
            listMessage = .refresh
        case .cantGo:
            try await dataStoreProvider.dataStore.leaveEvent(guest: userAccount, event: event)
            listMessage = .refresh
        default:
            throw ActionError.unhandledAction
        }
    }
}
