//
//  EventControl.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 1/16/25.
//

import SwiftUI

enum EventControl: Equatable, CaseIterable {
    case joinable
    case cancellable
    case deletable
    case edit

    var title: String {
        switch self {
        case .joinable:
            "join"
        case .cancellable:
            "can't go"
        case .deletable:
            "delete"
        case .edit:
            "edit"
        }
    }

    @MainActor
    func action(userAccount: AccountModel, event: EventModel, dataStore: DataStoring) async throws {
        switch self {
        case .joinable:
            try await dataStore.joinEvent(guest: userAccount, event: event)
        case .cancellable:
            try await dataStore.leaveEvent(guest: userAccount, event: event)
        case .deletable:
            try await dataStore.deleteEvent(creator: userAccount, event: event)
            ActionCentralDispatch.shared.handle(action: ButtonIdentifier.refreshEventListAction)
        case .edit:
            let url = try DeepLinkParser.Route.sheet(.composer(event)).url()
            await UIApplication.shared.open(url)
        }
    }

    func identifier(event: EventModel) -> String {
        let prefix: String = {
            switch self {
            case .joinable:
                return ButtonIdentifier.joinEventAction
            case .cancellable:
                return ButtonIdentifier.cantGoEventAction
            case .deletable:
                return ButtonIdentifier.deleteEventAction
            case .edit:
                return ButtonIdentifier.editEventAction
            }
        }()
        return prefix + "_" + event.uuid.uuidString
    }
}
