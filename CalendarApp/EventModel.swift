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
			builder.appendBracketButton("join", destination: "www.apple.com", color: .positive)
			builder.appendPrimaryText(" ")
		}
		if cancellable(guest: guest) {
			builder.appendBracketButton("cancel", destination: "www.apple.com", color: .negative)
			builder.appendPrimaryText(" ")
		}
		if deletable(guest: guest) {
			builder.appendBracketButton("delete", destination: "www.apple.com", color: .negative)
			builder.appendPrimaryText(" ")
		}
		builder.appendBracketButton("remind me", destination: "www.apple.com", color: .secondary)
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
			.appendPrimaryUnderlinedButton(location, destination: "www.apple.com")
			.appendPrimaryText(" • ")

		if isGuestGoing && guest != creator {
			if guests.count > 1 {
				builder
					.appendPrimaryUnderlinedButton("you", destination: "www.apple.com")
					.appendPrimaryText(", ")
					.appendPrimaryUnderlinedButton(creator, destination: "www.apple.com")
					.appendPrimaryText(" and ")
					.appendPrimaryUnderlinedButton(otherGoingText(isGoing: true), destination: "www.apple.com")
					.appendPrimaryText(" are going •")
			} else {
				builder
					.appendPrimaryUnderlinedButton("you", destination: "www.apple.com")
					.appendPrimaryText(" and ")
					.appendPrimaryUnderlinedButton(creator, destination: "www.apple.com")
					.appendPrimaryText(" are going •")
			}
		} else {
			if guests.count > 0 {
				builder
					.appendPrimaryUnderlinedButton(creator, destination: "www.apple.com")
					.appendPrimaryText(" and ")
					.appendPrimaryUnderlinedButton(otherGoingText(isGoing: false), destination: "www.apple.com")
					.appendPrimaryText(" are going •")
			} else {
				builder
					.appendPrimaryUnderlinedButton(creator, destination: "www.apple.com")
					.appendPrimaryText(" is going •")
			}
		}

		return builder.build()
	}
}
