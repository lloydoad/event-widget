//
//  EventFeedEntry.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/29/24.
//

import WidgetKit
import SwiftUI

struct EventFeedEntry: TimelineEntry {
    struct EventViewModel {
        var event: EventModel
        var isGuest: Bool
    }
    var date: Date
    let events: [EventViewModel]
}
