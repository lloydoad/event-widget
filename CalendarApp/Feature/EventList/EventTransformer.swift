//
//  EventTransformer.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/25/24.
//

import SwiftUI

struct EventTransformer {
    let viewer: AccountModel
    let listIdentifier: String

    func content(event: EventModel, hasTask: Bool) -> AttributedString {
        do {
            if event.isActive() {
                return try nonExpiredContent(event: event, hasTask: hasTask)
            } else {
                return try expiredContent(event: event)
            }
        } catch {
            return "event details unavailable"
        }
    }

    private func expiredContent(event: EventModel) throws -> AttributedString {
        let locationURL = try locationURL(event: event)
        let timeValue = DateFormatter().formattedRange(start: event.startDate, end: event.endDate)
        let baseStyle = StringBuilder.BaseStyle(appFont: .light, strikeThrough: true)

        return StringBuilder(baseStyle: baseStyle)
            .text(.primary("\(event.description) • \(timeValue) at "))
            .route(.underline(event.location.address, destination: locationURL, color: .primary))
            .text(.primary(" "))
            .build()
    }

    private func nonExpiredContent(event: EventModel, hasTask: Bool) throws -> AttributedString {
        var builder = try content(event: event)
        if hasTask {
            builder = builder
                .text(.colored(" ... ", color: .appTint))
        } else {
            if event.joinable(viewer: viewer) {
                builder = addAction(
                    builder: builder,
                    event: event,
                    control: .joinable
                )
            }
            if event.cancellable(viewer: viewer) {
                builder = addAction(
                    builder: builder,
                    event: event,
                    control: .cancellable
                )
            }
            if event.deletable(viewer: viewer) {
                builder = addAction(
                    builder: builder,
                    event: event,
                    control: .edit
                )
                builder = addAction(
                    builder: builder,
                    event: event,
                    control: .deletable
                )
            }
        }
        return builder.build()
    }

    private func addAction(builder: StringBuilder, event: EventModel, control: EventControl) -> StringBuilder {
        builder
            .text(.primary(" • "))
            .action(.bracket(
                control.title,
                identifier: control.identifier(event: event, listIdentifier: listIdentifier),
                color: .appTint,
                action: { }
            ))
    }

    private func content(event: EventModel) throws -> StringBuilder {
        let locationURL = try locationURL(event: event)
        let timeValue = DateFormatter().formattedRange(start: event.startDate, end: event.endDate)
        let isNonCreatorGuest = event.isGoing(viewer: viewer) && viewer != event.creator
        let baseStyle = StringBuilder.BaseStyle(appFont: .light)
        let builder = StringBuilder(baseStyle: baseStyle)
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
                            .text(.primary(" are going"))
                    } else {
                        sb
                            .account(viewer)
                            .text(.primary(" and "))
                            .account(event.creator)
                            .text(.primary(" are going"))
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
                            .text(.primary(" are going"))
                    } else {
                        sb
                            .account(event.creator)
                            .text(.primary(" is going"))
                    }
                }
            )

        return builder
    }

    private func locationURL(event: EventModel) throws -> URL {
        guard let locationURL = event.location.appleMapsDeepLink else {
            throw ErrorManager.with(loggedMessage: "Could not create maps for \(event.location.address)")
        }
        return locationURL
    }

    private func otherGoingText(isGoing: Bool, event: EventModel) -> String {
        let guestCount = max(event.guests.count - (isGoing ? 1 : 0), 0)
        return "\(guestCount) other\(guestCount > 1 ? "s" : "")"
    }
}

extension StringBuilder {
	func account(_ account: AccountModel) -> StringBuilder {
        route(.underline(account.username, page: .profile(account), color: .primary))
	}

    func guestList(_ text: String, viewer: AccountModel, event: EventModel) -> StringBuilder {
        route(.underline(text, page: .guestList(event.guests), color: .primary))
	}
}
