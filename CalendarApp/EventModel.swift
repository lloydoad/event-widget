//
//  EventModel.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import Foundation

struct EventModel {
	let creator: String
	let description: String
	let startDate: Date
	let endDate: Date
	let location: String
	let guests: [String]
}

extension EventModel {
	func isGoing(guest: String) -> Bool {
		guests.contains(guest)
	}

	func joinable(guest: String) -> Bool {
		!isGoing(guest: guest) && guest != creator
	}

	func cancellable(guest: String) -> Bool {
		isGoing(guest: guest)
	}

	func deletable(guest: String) -> Bool {
		creator == guest
	}
}

extension EventModel {
	func otherGoingText(isGoing: Bool) -> String {
		let guestCount = max(guests.count - (isGoing ? 1 : 0), 0)
		return "\(guestCount) other\(guestCount > 1 ? "s" : "")"
	}

	func buildAttributedControlContent(for guest: String) -> AttributedString {
		let baseStyle = AttributedStringBuilder.BaseStyle(appFont: .light)
		let builder = AttributedStringBuilder(baseStyle: baseStyle)
		if joinable(guest: guest) {
			builder.appendBracketButton("join", destination: "calendarapp://account", color: .accent)
			builder.appendPrimaryText(" ")
		}
		if cancellable(guest: guest) {
			builder.appendBracketButton("cancel", destination: "calendarapp://account", color: .accent)
			builder.appendPrimaryText(" ")
		}
		if deletable(guest: guest) {
			builder.appendBracketButton("delete", destination: "calendarapp://account", color: .accent)
			builder.appendPrimaryText(" ")
		}
		builder.appendBracketButton("remind me", destination: "calendarapp://account", color: .secondary)
		builder.appendPrimaryText(" ")
		return builder.build()
	}

	func buildAttributedContent(for guest: String) -> AttributedString {
		let timeValue = DateFormatter().formattedRange(start: startDate,
													   end: endDate)
		let isGuestGoing = isGoing(guest: guest)

		let baseStyle = AttributedStringBuilder.BaseStyle(appFont: .light)
		let builder = AttributedStringBuilder(baseStyle: baseStyle)
			.appendPrimaryText("\(description) • \(timeValue) at ")
			.appendPrimaryUnderlinedButton(location, destination: "calendarapp://account")
			.appendPrimaryText(" • ")

		if isGuestGoing && guest != creator {
			if guests.count > 1 {
				builder
					.appendPrimaryUnderlinedButton("you", destination: "calendarapp://account")
					.appendPrimaryText(", ")
					.appendPrimaryUnderlinedButton(creator, destination: "calendarapp://account")
					.appendPrimaryText(" and ")
					.appendPrimaryUnderlinedButton(otherGoingText(isGoing: true), destination: "calendarapp://account")
					.appendPrimaryText(" are going •")
			} else {
				builder
					.appendPrimaryUnderlinedButton("you", destination: "calendarapp://account")
					.appendPrimaryText(" and ")
					.appendPrimaryUnderlinedButton(creator, destination: "calendarapp://account")
					.appendPrimaryText(" are going •")
			}
		} else {
			if guests.count > 0 {
				builder
					.appendPrimaryUnderlinedButton(creator, destination: "calendarapp://account")
					.appendPrimaryText(" and ")
					.appendPrimaryUnderlinedButton(otherGoingText(isGoing: false), destination: "calendarapp://account")
					.appendPrimaryText(" are going •")
			} else {
				builder
					.appendPrimaryUnderlinedButton(creator, destination: "calendarapp://account")
					.appendPrimaryText(" is going •")
			}
		}

		return builder.build()
	}
}
