//
//  EventFeedEntry.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/29/24.
//

import WidgetKit
import SwiftUI

struct EventFeedEntry: TimelineEntry {
    var date: Date
    let events: [EventModel]
    let userAccount: AccountModel
}
