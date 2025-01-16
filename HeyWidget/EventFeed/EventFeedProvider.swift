//
//  EventFeedProvider.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/29/24.
//

import WidgetKit
import SwiftUI
import os

let widgetLogger = Logger(subsystem: "Hey.Widget", category: "Provider")
struct EventFeedProvider: TimelineProvider {
    var appSessionStore: AppSessionStore
    var dataStore: DataStoring

    init() {
        appSessionStore = AppSessionStore()
        if let dataStore = try? SupabaseDataStore() {
            self.dataStore = dataStore
        } else {
            self.dataStore = MockDataStore(accounts: [], followings: [:], events: [])
        }
    }

    func placeholder(in context: Context) -> EventFeedEntry {
        EventFeedEntry(date: .now, events: Self.placeholderEvents())
    }

    func getSnapshot(in context: Context, completion: @escaping (EventFeedEntry) -> ()) {
        fetchEvents { events in
            completion(EventFeedEntry(date: .now, events: events))
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<EventFeedEntry>) -> ()) {
        fetchEvents { events in
            let entry = EventFeedEntry(date: .now, events: events)
            let timeOfRelevance = Calendar.current.date(byAdding: .minute, value: 30, to: .now) ?? .now
            let timeline = Timeline(entries: [entry], policy: .after(timeOfRelevance))
            completion(timeline)
        }
    }

    static let placeholderUser = AccountModel(uuid: UUID(), username: "alex", phoneNumber: "")
    static func placeholderEvents() -> [EventFeedEntry.EventViewModel] {
        let dateFormatter = DateFormatter()
        let mockLocation = LocationModel(address: "", code: "", city: "", state: "", country: "")
        return [
            .init(
                event: EventModel(
                    uuid: UUID(),
                    creator: .init(uuid: UUID(), username: "taylor", phoneNumber: ""),
                    description: "warehouse 23 to check out this underground synth jazz band tonight",
                    startDate: dateFormatter.createDate(hour: 19, minute: 30) ?? .now,
                    endDate: dateFormatter.createDate(hour: 21, minute: 30) ?? .now,
                    location: mockLocation,
                    guests: [placeholderUser]
                ),
                isGuest: true
            ),
            .init(
                event: EventModel(
                    uuid: UUID(),
                    creator: .init(uuid: UUID(), username: "drew", phoneNumber: ""),
                    description: "hitting up ocean beach for some pickup volleyball - apparently there's a hidden gem team",
                    startDate: dateFormatter.createDate(hour: 20) ?? .now,
                    endDate: dateFormatter.createDate(hour: 22, minute: 30) ?? .now,
                    location: mockLocation,
                    guests: []
                ),
                isGuest: false
            )
        ]
    }

    private func fetchEvents(completion: @escaping ([EventFeedEntry.EventViewModel]) -> ()) {
        guard let userAccount = appSessionStore.userAccount else {
            completion([])
            return
        }
        Task {
            do {
                let events = try await dataStore.getEventFeed(viewing: userAccount, limit: 2)
                let eventViewModels = events.map { event in
                    EventFeedEntry.EventViewModel(
                        event: event,
                        isGuest: event.guests.map(\.uuid).contains(userAccount.uuid)
                    )
                }
                Task { @MainActor in
                    completion(eventViewModels)
                }
            } catch {
                widgetLogger.error("\(error.localizedDescription)")
                Task { @MainActor in
                    completion([])
                }
            }
        }
    }
}
