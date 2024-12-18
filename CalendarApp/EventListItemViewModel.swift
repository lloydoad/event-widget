//
//  EventListItemViewModel.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

extension EventListItemView.Model {
	init(guest: AccountModel, event: EventModel) throws {
		content = try EventListItemView.Model.content(guest: guest, event: event)
		controls = try EventListItemView.Model.controls(guest: guest, event: event)
	}

	static func otherGoingText(isGoing: Bool, event: EventModel) -> String {
		let guestCount = max(event.guests.count - (isGoing ? 1 : 0), 0)
		return "\(guestCount) other\(guestCount > 1 ? "s" : "")"
	}

	static func controls(guest: AccountModel, event: EventModel) throws -> AttributedString {
		let baseStyle = AttributedStringBuilder.BaseStyle(appFont: .light)
		let builder = AttributedStringBuilder(baseStyle: baseStyle)
		if event.joinable(guest: guest) {
			builder.appendBracketButton("join", destination: "calendarapp://account", color: .accent)
			builder.appendPrimaryText(" ")
		}
		if event.cancellable(guest: guest) {
			builder.appendBracketButton("cancel", destination: "calendarapp://account", color: .accent)
			builder.appendPrimaryText(" ")
		}
		if event.deletable(guest: guest) {
			builder.appendBracketButton("delete", destination: "calendarapp://account", color: .accent)
			builder.appendPrimaryText(" ")
		}
		builder.appendBracketButton("remind me", destination: "calendarapp://account", color: .secondary)
		builder.appendPrimaryText(" ")
		return builder.build()
	}

	static func content(guest: AccountModel, event: EventModel) throws -> AttributedString {
		let timeValue = DateFormatter().formattedRange(start: event.startDate,
													   end: event.endDate)
		let isNonCreatorGuest = event.isGoing(guest: guest) && guest != event.creator
		let baseStyle = AttributedStringBuilder.BaseStyle(appFont: .light)
		let builder = AttributedStringBuilder(baseStyle: baseStyle)
			.appendPrimaryText("\(event.description) • \(timeValue) at ")
			.appendPrimaryUnderlinedButton(event.location, destination: "calendarapp://account")
			.appendPrimaryText(" • ")

		if isNonCreatorGuest {
			if event.guests.count > 1 {
				try builder
					.appendPrimaryUnderlinedButton("you", destination: "calendarapp://account")
					.appendPrimaryText(", ")
					.appendPrimaryUnderlinedAccount(event.creator)
					.appendPrimaryText(" and ")
					.appendPrimaryUnderlinedButton(
						otherGoingText(isGoing: true, event: event),
						destination: "calendarapp://account"
					)
					.appendPrimaryText(" are going •")
			} else {
				try builder
					.appendPrimaryUnderlinedButton("you", destination: "calendarapp://account")
					.appendPrimaryText(" and ")
					.appendPrimaryUnderlinedAccount(event.creator)
					.appendPrimaryText(" are going •")
			}
		} else {
			if event.guests.count > 0 {
				try builder
					.appendPrimaryUnderlinedAccount(event.creator)
					.appendPrimaryText(" and ")
					.appendPrimaryUnderlinedButton(
						otherGoingText(isGoing: false, event: event),
						destination: "calendarapp://account"
					)
					.appendPrimaryText(" are going •")
			} else {
				try builder
					.appendPrimaryUnderlinedAccount(event.creator)
					.appendPrimaryText(" is going •")
			}
		}

		return builder.build()
	}
}
