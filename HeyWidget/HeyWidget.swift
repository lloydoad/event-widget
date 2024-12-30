//
//  HeyWidget.swift
//  HeyWidget
//
//  Created by Lloyd Dapaah on 12/29/24.
//

import WidgetKit
import SwiftUI

struct HeyWidget: Widget {
    let kind: String = "HeyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: EventFeedProvider()) { entry in
            if #available(iOS 17.0, *) {
                EventFeedView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                EventFeedView(entry: entry)
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
    EventFeedEntry(date: .now, events: [], userAccount: EventFeedProvider.placeholderUser)
    EventFeedEntry(date: .now, events: EventFeedProvider.placeholderEvents(), userAccount: EventFeedProvider.placeholderUser)
}
