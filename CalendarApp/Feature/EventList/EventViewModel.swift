//
//  EventViewModel.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/25/24.
//

import SwiftUI



class EventViewModel: ObservableObject, Identifiable {
    var id: String
    var dataStore: DataStoring?
    var appSessionStore: AppSessionStore?
    var event: EventModel?
    var transformer: EventTransformer?
    var removeEvent: ((UUID) -> Void)?

    @Published var content: AttributedString
    @Published var error: Error?

    init() {
        self.id = UUID().uuidString
        self.event = nil
        self.content = ""
        self.dataStore = nil
        self.appSessionStore = nil
        self.removeEvent = nil
        self.transformer = nil
    }

    func configure(dataStore: DataStoring, appSessionStore: AppSessionStore, event: EventModel, removeEvent: @escaping ((UUID) -> Void)) {
        self.id = event.uuid.uuidString
        self.dataStore = dataStore
        self.appSessionStore = appSessionStore
        self.event = event
        self.removeEvent = removeEvent
        if let userAccount = appSessionStore.userAccount {
            self.transformer = EventTransformer(viewer: userAccount)
        }
        self.content = transformer?.content(event: event, hasTask: false) ?? ""
    }

    // MARK: Actions

    var currentTask: Task<Void, Never>?
    func perform(control: EventControl) {
        guard let appSessionStore else { return }
        guard let userAccount = appSessionStore.userAccount else { return }
        guard let dataStore else { return }
        guard let event else { return }
        currentTask?.cancel()
        content = transformer?.content(event: event, hasTask: true) ?? ""
        currentTask = Task {
            do {
                try await control.action(userAccount: userAccount, event: event, dataStore: dataStore)
                let updatedEvent = try await dataStore.getEvent(uuid: event.uuid)
                await MainActor.run {
                    if let updatedEvent {
                        self.event = updatedEvent
                        self.content = transformer?.content(event: updatedEvent, hasTask: false) ?? ""
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
}
