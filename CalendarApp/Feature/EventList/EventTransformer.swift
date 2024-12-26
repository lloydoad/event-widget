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
        guard let locationURL = event.location.appleMapsDeepLink else {
            throw ErrorManager.with(message: "Could not create maps for \(event.location.address)")
        }
        let timeValue = DateFormatter().formattedRange(start: event.startDate, end: event.endDate)
        let baseStyle = AttributedStringBuilder.BaseStyle(appFont: .light, strikeThrough: true)

        return AttributedStringBuilder(baseStyle: baseStyle)
            .text(.primary("\(event.description) • \(timeValue) at "))
            .route(.underline(event.location.address, destination: locationURL, color: .primary))
            .text(.primary(" • "))
            .build()
    }

    func content(event: EventModel) throws -> AttributedString {
        guard let locationURL = event.location.appleMapsDeepLink else {
            throw ErrorManager.with(message: "Could not create maps for \(event.location.address)")
        }

        let timeValue = DateFormatter().formattedRange(start: event.startDate, end: event.endDate)
        let isNonCreatorGuest = event.isGoing(viewer: viewer) && viewer != event.creator
        let baseStyle = AttributedStringBuilder.BaseStyle(appFont: .light)
        let builder = AttributedStringBuilder(baseStyle: baseStyle)
            .text(.primary("\(event.description) • \(timeValue) at "))
            .route(.underline(event.location.address, destination: locationURL, color: .primary))
            .text(.primary(" • "))
            .staticIfElse(
                condition: isNonCreatorGuest,
                trueBlock: { sb in
                    if event.guests.count > 1 {
                        sb
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
                        sb
                            .account(viewer)
                            .text(.primary(" and "))
                            .account(event.creator)
                            .text(.primary(" are going •"))
                    }
                },
                falseBlock: { sb in
                    if event.guests.count > 0 {
                        sb
                            .account(event.creator)
                            .text(.primary(" and "))
                            .guestList(
                                otherGoingText(isGoing: false, event: event),
                                viewer: viewer,
                                event: event
                            )
                            .text(.primary(" are going •"))
                    } else {
                        sb
                            .account(event.creator)
                            .text(.primary(" is going •"))
                    }
                }
            )

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

    func guestList(_ text: String, viewer: AccountModel, event: EventModel) -> AttributedStringBuilder {
        route(.underline(text, page: .guestList(event.guests), color: .primary))
	}
}
