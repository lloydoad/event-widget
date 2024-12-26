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
            .text(.primary("\(event.description) • \(timeValue) at "))
            .location(event.location)
            .text(.primary(" • "))
            .build()
    }

    func content(event: EventModel) throws -> AttributedString {
        let timeValue = DateFormatter().formattedRange(start: event.startDate,
                                                       end: event.endDate)
        let isNonCreatorGuest = event.isGoing(viewer: viewer) && viewer != event.creator
        let baseStyle = AttributedStringBuilder.BaseStyle(appFont: .light)
        let builder = try AttributedStringBuilder(baseStyle: baseStyle)
            .text(.primary("\(event.description) • \(timeValue) at "))
            .location(event.location)
            .text(.primary(" • "))

        if isNonCreatorGuest {
            if event.guests.count > 1 {
                try builder
                    .account(viewer)
                    .text(.primary(", "))
                    .account(event.creator)
                    .text(.primary(" and "))
                    .guestList(
                        otherGoingText(isGoing: true, event: event),
                        viewer: viewer,
                        event: event
                    )
                    .text(.primary(" are going •"))
            } else {
                builder
                    .account(viewer)
                    .text(.primary(" and "))
                    .account(event.creator)
                    .text(.primary(" are going •"))
            }
        } else {
            if event.guests.count > 0 {
                try builder
                    .account(event.creator)
                    .text(.primary(" and "))
                    .guestList(
                        otherGoingText(isGoing: false, event: event),
                        viewer: viewer,
                        event: event
                    )
                    .text(.primary(" are going •"))
            } else {
                builder
                    .account(event.creator)
                    .text(.primary(" is going •"))
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
	func account(_ account: AccountModel) -> AttributedStringBuilder {
        route(.underline(account.username, page: .profile(account), color: .primary))
	}

	func location(_ location: LocationModel) throws -> AttributedStringBuilder {
		guard let url = location.appleMapsDeepLink else {
			throw NSError(domain: "calendarApp", code: 1)
		}
        return route(.underline(location.address, destination: url, color: .primary))
	}

    func guestList(_ text: String, viewer: AccountModel, event: EventModel) throws -> AttributedStringBuilder {
        route(.underline(text, page: .guestList(event.guests), color: .primary))
	}
}
