//
//  HeyWidget.swift
//  HeyWidget
//
//  Created by Lloyd Dapaah on 12/29/24.
//

import WidgetKit
import SwiftUI
import Supabase

class WidgetDataStore {

    func fetchEventsFeed(viewerId: String) async throws -> Data? {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1")!

        let (data, _) = try await URLSession.shared.data(from: url)
        return data
//        // Configure the URL
//        guard let url = URL(string: "https://xozqockpbwpxkgrwgyef.supabase.co/rest/v1/rpc/get_events_feed") else {
//            throw URLError(.badURL)
//        }
//
//        // Create the request
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//
//        // Set headers
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhvenFvY2twYndweGtncndneWVmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUyNTM5NTYsImV4cCI6MjA1MDgyOTk1Nn0.41sYnPXprk0BiDAjwUQYkGNx_DoZ6NmwInhgshe6m3w", forHTTPHeaderField: "apikey")
//        request.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhvenFvY2twYndweGtncndneWVmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUyNTM5NTYsImV4cCI6MjA1MDgyOTk1Nn0.41sYnPXprk0BiDAjwUQYkGNx_DoZ6NmwInhgshe6m3w", forHTTPHeaderField: "Authorization")
//
//        // Create and set the body
//        let body = ["p_viewer_id": viewerId]
//        request.httpBody = try JSONSerialization.data(withJSONObject: body)
//
//        // Make the request
//        let (data, response) = try await URLSession.shared.data(for: request)
//
//        // Verify response status code
//        guard let httpResponse = response as? HTTPURLResponse,
//              (200...299).contains(httpResponse.statusCode) else {
//            throw URLError(.badServerResponse)
//        }
//
//        return data
    }
}

struct Provider: TimelineProvider {
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

    func placeholder(in context: Context) -> FeedEntry {
        FeedEntry(date: .now, events: Self.placeholderEvents(), userAccount: Self.placeholderUser)
    }

    func getSnapshot(in context: Context, completion: @escaping (FeedEntry) -> ()) {
        fetchEvents { events, userAccount in
            completion(FeedEntry(date: .now, events: events, userAccount: userAccount))
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        fetchEvents { events, userAccount in
            let entry = FeedEntry(date: .now, events: events, userAccount: userAccount)
            let timeOfRelevance = Calendar.current.date(byAdding: .minute, value: 30, to: .now) ?? .now
            let timeline = Timeline(entries: [entry], policy: .after(timeOfRelevance))
            completion(timeline)
        }
    }

    static let placeholderUser = AccountModel(uuid: UUID(), username: "alex", phoneNumber: "")
    static func placeholderEvents() -> [EventModel] {
        let dateFormatter = DateFormatter()
        let mockLocation = LocationModel(address: "", city: "", state: "")
        return [
            EventModel(
                uuid: UUID(),
                creator: .init(uuid: UUID(), username: "taylor", phoneNumber: ""),
                description: "warehouse 23 to check out this underground synth jazz band tonight",
                startDate: dateFormatter.createDate(hour: 19, minute: 30) ?? .now,
                endDate: dateFormatter.createDate(hour: 21, minute: 30) ?? .now,
                location: mockLocation,
                guests: [placeholderUser]
            ),
            EventModel(
                uuid: UUID(),
                creator: .init(uuid: UUID(), username: "drew", phoneNumber: ""),
                description: "hitting up ocean beach for some pickup volleyball - apparently there's a hidden gem team",
                startDate: dateFormatter.createDate(hour: 20) ?? .now,
                endDate: dateFormatter.createDate(hour: 22, minute: 30) ?? .now,
                location: mockLocation,
                guests: []
            )
        ]
    }

    private func fetchEvents(completion: @escaping ([EventModel], AccountModel) -> ()) {
        guard let userAccount = appSessionStore.userAccount else {
            completion([], Self.placeholderUser)
            return
        }
        Task {
            do {
//                let events = try await dataStore.getEventFeed(viewing: userAccount, limit: 2)
                let widgetDatastore = WidgetDataStore()
                let data = try await widgetDatastore.fetchEventsFeed(viewerId: userAccount.uuid.uuidString)
                print(data)
                Task { @MainActor in
                    completion([], userAccount)
                }
            } catch {
                print(error)
                Task { @MainActor in
                    completion([], userAccount)
                }
            }
        }
    }
}

struct FeedEntry: TimelineEntry {
    var date: Date
    let events: [EventModel]
    let userAccount: AccountModel
}

struct HeyWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            if entry.events.isEmpty {
                Text(StringBuilder(baseStyle: .init(appFont: .widget))
                    .text(.primary("no current events, "))
                    .text(.colored("[create one]", color: .appTint))
                    .build())
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                ForEach(entry.events, id: \.uuid) { event in
                    VStack(alignment: .leading) {
                        Text(eventTitle(event: event, userAccount: entry.userAccount))
                        .lineLimit(3, reservesSpace: true)
                    }
                    .padding(.bottom, 2)
                }
                Spacer()
                Text(attributed(
                    text: "[create event]",
                    color: .appTint
                ))
                .lineLimit(1, reservesSpace: true)
            }
        }
    }

    func attributed(text: String, color: AppColor) -> AttributedString {
        StringBuilder(baseStyle: .init(appFont: .widget))
            .text(.colored(text, color: color))
            .build()
    }

    func eventTitle(event: EventModel, userAccount: AccountModel) -> AttributedString {
        let userIsGuest = event.guests.contains(where: { $0.uuid == userAccount.uuid })
        let actionTitle = userIsGuest ? "joining " : "tap to join "
        var text = event.creator.username
        text += " @ \(DateFormatter().cleanString(date: event.startDate)): "
        text += event.description
        return StringBuilder(baseStyle: .init(appFont: .widget))
            .text(.colored(actionTitle, color: .appTint))
            .text(.colored(text.lowercased(), color: .primary))
            .build()
    }
}

struct HeyWidget: Widget {
    let kind: String = "HeyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                HeyWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                HeyWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Hey Event Feed")
        .description("See upcoming events from friends and quickly join in")
    }
}

#Preview(as: .systemSmall) {
    HeyWidget()
} timeline: {
    FeedEntry(date: .now, events: [], userAccount: Provider.placeholderUser)
    FeedEntry(date: .now, events: Provider.placeholderEvents(), userAccount: Provider.placeholderUser)
}
