//
//  EventListItemViewModel.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

extension EventListItemView.Model {
	init(viewer: AccountModel, event: EventModel) throws {
		content = try EventListItemView.Model.content(viewer: viewer, event: event)
		controls = try EventListItemView.Model.controls(viewer: viewer, event: event)
	}

	static func otherGoingText(isGoing: Bool, event: EventModel) -> String {
		let guestCount = max(event.guests.count - (isGoing ? 1 : 0), 0)
		return "\(guestCount) other\(guestCount > 1 ? "s" : "")"
	}

	static func controls(viewer: AccountModel, event: EventModel) throws -> AttributedString {
		let baseStyle = AttributedStringBuilder.BaseStyle(appFont: .light)
		let builder = AttributedStringBuilder(baseStyle: baseStyle)
		if event.joinable(viewer: viewer) {
			builder.appendBracketButton("join", destination: "calendarapp://account", color: .accent)
			builder.appendPrimaryText(" ")
		}
		if event.cancellable(viewer: viewer) {
			builder.appendBracketButton("can't go", destination: "calendarapp://account", color: .accent)
			builder.appendPrimaryText(" ")
		}
		if event.deletable(viewer: viewer) {
			builder.appendBracketButton("delete", destination: "calendarapp://account", color: .accent)
			builder.appendPrimaryText(" ")
		}
		builder.appendPrimaryText(" ")
		return builder.build()
	}

	static func content(viewer: AccountModel, event: EventModel) throws -> AttributedString {
		let timeValue = DateFormatter().formattedRange(start: event.startDate,
													   end: event.endDate)
		let isNonCreatorGuest = event.isGoing(viewer: viewer) && viewer != event.creator
		let baseStyle = AttributedStringBuilder.BaseStyle(appFont: .light)
		let builder = try AttributedStringBuilder(baseStyle: baseStyle)
			.appendPrimaryText("\(event.description) • \(timeValue) at ")
			.appendLocationButton(event.location)
			.appendPrimaryText(" • ")

		if isNonCreatorGuest {
			if event.guests.count > 1 {
				try builder
					.appendAccountButton(viewer, isCurrentViewer: true)
					.appendPrimaryText(", ")
					.appendAccountButton(event.creator)
					.appendPrimaryText(" and ")
					.appendGuestListButton(
						text: otherGoingText(isGoing: true, event: event),
						viewer: viewer,
						guests: event.guests
					)
					.appendPrimaryText(" are going •")
			} else {
				try builder
					.appendAccountButton(viewer, isCurrentViewer: true)
					.appendPrimaryText(" and ")
					.appendAccountButton(event.creator)
					.appendPrimaryText(" are going •")
			}
		} else {
			if event.guests.count > 0 {
				try builder
					.appendAccountButton(event.creator)
					.appendPrimaryText(" and ")
					.appendGuestListButton(
						text: otherGoingText(isGoing: false, event: event),
						viewer: viewer,
						guests: event.guests
					)
					.appendPrimaryText(" are going •")
			} else {
				try builder
					.appendAccountButton(event.creator)
					.appendPrimaryText(" is going •")
			}
		}

		return builder.build()
	}
}
