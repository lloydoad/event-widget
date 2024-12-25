//
//  EventTransformer.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/25/24.
//

import SwiftUI

struct EventTransformer {
    let viewer: AccountModel

    func expiredContent(event: EventModel) throws -> AttributedString {
        let timeValue = DateFormatter().formattedRange(start: event.startDate,
                                                       end: event.endDate)
        let baseStyle = AttributedStringBuilder.BaseStyle(appFont: .light, strikeThrough: true)
        return try AttributedStringBuilder(baseStyle: baseStyle)
            .primaryText("\(event.description) • \(timeValue) at ")
            .location(event.location)
            .primaryText(" • ")
            .build()
    }

    func content(event: EventModel) throws -> AttributedString {
        let timeValue = DateFormatter().formattedRange(start: event.startDate,
                                                       end: event.endDate)
        let isNonCreatorGuest = event.isGoing(viewer: viewer) && viewer != event.creator
        let baseStyle = AttributedStringBuilder.BaseStyle(appFont: .light)
        let builder = try AttributedStringBuilder(baseStyle: baseStyle)
            .primaryText("\(event.description) • \(timeValue) at ")
            .location(event.location)
            .primaryText(" • ")

        if isNonCreatorGuest {
            if event.guests.count > 1 {
                try builder
                    .account(viewer)
                    .primaryText(", ")
                    .account(event.creator)
                    .primaryText(" and ")
                    .guestList(
                        otherGoingText(isGoing: true, event: event),
                        viewer: viewer,
                        event: event
                    )
                    .primaryText(" are going •")
            } else {
                try builder
                    .account(viewer)
                    .primaryText(" and ")
                    .account(event.creator)
                    .primaryText(" are going •")
            }
        } else {
            if event.guests.count > 0 {
                try builder
                    .account(event.creator)
                    .primaryText(" and ")
                    .guestList(
                        otherGoingText(isGoing: false, event: event),
                        viewer: viewer,
                        event: event
                    )
                    .primaryText(" are going •")
            } else {
                try builder
                    .account(event.creator)
                    .primaryText(" is going •")
            }
        }

        return builder.build()
    }

    private func otherGoingText(isGoing: Bool, event: EventModel) -> String {
        let guestCount = max(event.guests.count - (isGoing ? 1 : 0), 0)
        return "\(guestCount) other\(guestCount > 1 ? "s" : "")"
    }
}

extension AttributedStringBuilder {
	func account(_ account: AccountModel) throws -> AttributedStringBuilder {
		try self.underline(account.username, deeplink: .push(.profile(account)), color: .primary)
	}

	func location(_ location: LocationModel) throws -> AttributedStringBuilder {
		guard let url = location.appleMapsDeepLink else {
			throw NSError(domain: "calendarApp", code: 1)
		}
		return try underline(location.address, url: url, color: .primary)
	}

    func guestList(_ text: String, viewer: AccountModel, event: EventModel) throws -> AttributedStringBuilder {
        let route = DeepLinkParser.Route.push(.guestList(event.guests))
		return try underline(text, deeplink: route, color: .primary)
	}
}
