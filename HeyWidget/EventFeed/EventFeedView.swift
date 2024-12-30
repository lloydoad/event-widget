//
//  EventFeedView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/29/24.
//

import SwiftUI
import WidgetKit

struct EventFeedView : View {
    var entry: EventFeedProvider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            if entry.events.isEmpty {
                Text(StringBuilder(baseStyle: .init(appFont: .widget))
                    .text(.primary("no current events, "))
                    .text(.colored("[create one]", color: .appTint))
                    .build())
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                ForEach(entry.events, id: \.event.uuid) { eventViewModel in
                    VStack(alignment: .leading) {
                        Text(eventTitle(event: eventViewModel.event, isGuest: eventViewModel.isGuest))
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

    func eventTitle(event: EventModel, isGuest: Bool) -> AttributedString {
        let actionTitle = isGuest ? "joining " : "tap to join "
        var text = event.creator.username
        text += " @ \(DateFormatter().cleanString(date: event.startDate)): "
        text += event.description
        return StringBuilder(baseStyle: .init(appFont: .widget))
            .text(.colored(actionTitle, color: .appTint))
            .text(.colored(text.lowercased(), color: .primary))
            .build()
    }
}

#Preview(as: .systemSmall) {
    HeyWidget()
} timeline: {
    EventFeedEntry(date: .now, events: [])
    EventFeedEntry(date: .now, events: EventFeedProvider.placeholderEvents())
}
