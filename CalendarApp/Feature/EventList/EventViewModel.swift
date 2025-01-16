//
//  EventViewModel.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/25/24.
//

import SwiftUI

class EventViewModel: ObservableObject, Identifiable {
    enum Control: Equatable {
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
        func action(
            userAccount: AccountModel,
            event: EventModel,
            dataStore: DataStoring
        ) async throws {
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
    }

    enum ControlState: Equatable {
        case enable([Control])
        case disabled
    }

    var id: String
    var dataStore: DataStoring?
    var appSessionStore: AppSessionStore?
    var event: EventModel?
    var removeEvent: ((UUID) -> Void)?

    @Published var content: AttributedString
    @Published var controls: ControlState
    @Published var error: Error?

    init() {
        self.id = UUID().uuidString
        self.event = nil
        self.content = ""
        self.controls = .disabled
        self.dataStore = nil
        self.appSessionStore = nil
        self.removeEvent = nil
    }

    func configure(dataStore: DataStoring, appSessionStore: AppSessionStore, event: EventModel, removeEvent: @escaping ((UUID) -> Void)) {
        self.id = event.uuid.uuidString
        self.dataStore = dataStore
        self.appSessionStore = appSessionStore
        self.event = event
        self.removeEvent = removeEvent
        self.controls = .enable(Self.getControls(event: event, appSessionStore: appSessionStore))
        self.content = Self.getContent(event: event, appSessionStore: appSessionStore)
    }

    // MARK: Actions

    var currentTask: Task<Void, Never>?
    func perform(control: Control) {
        guard let appSessionStore else { return }
        guard let userAccount = appSessionStore.userAccount else { return }
        guard let dataStore else { return }
        guard let event else { return }
        currentTask?.cancel()
        controls = .disabled
        currentTask = Task {
            do {
                try await control.action(userAccount: userAccount,
                                         event: event,
                                         dataStore: dataStore)

                let updatedEvent = try await dataStore.getEvent(uuid: event.uuid)

                await MainActor.run {
                    if let updatedEvent {
                        self.event = updatedEvent
                        self.content = Self.getContent(event: updatedEvent, appSessionStore: appSessionStore)
                        self.controls = .enable(Self.getControls(event: updatedEvent, appSessionStore: appSessionStore))
                    } else {
                        self.removeEvent?(event.uuid)
                    }
                }
            } catch {
                await MainActor.run {
                    self.error = error
                }
            }
        }
    }

    // MARK: Content Builders

    static func getControls(event: EventModel, appSessionStore: AppSessionStore) -> [Control] {
        guard let userAccount = appSessionStore.userAccount else { return [] }
        var controls = [Control]()
        if event.joinable(viewer: userAccount) {
            controls.append(.joinable)
        }
        if event.cancellable(viewer: userAccount) {
            controls.append(.cancellable)
        }
        if event.deletable(viewer: userAccount) {
            controls.append(.edit)
            controls.append(.deletable)
        }
        return controls
    }

    static func getContent(event: EventModel, appSessionStore: AppSessionStore) -> AttributedString {
        guard let userAccount = appSessionStore.userAccount else { return "" }
        let eventTransformer = EventTransformer(viewer: userAccount)
        do {
            if event.isActive() {
                return try eventTransformer.content(event: event)
            } else {
                return try eventTransformer.expiredContent(event: event)
            }
        } catch {
            return "event details unavailable"
        }
    }
}
