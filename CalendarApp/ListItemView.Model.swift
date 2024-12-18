//
//  EventListItemViewModel.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

extension ListItemView.Model {

	// MARK: - Account

	static func account(viewer: AccountModel, account: AccountModel) throws -> ListItemView.Model {
		ListItemView.Model(
			content: try ListItemView.Model.accountContent(viewer: viewer, account: account),
			controls: try ListItemView.Model.accountControls(viewer: viewer, account: account)
		)
	}

	static private func accountControls(viewer: AccountModel, account: AccountModel) throws -> AttributedString {
		let baseStyle = AttributedStringBuilder.BaseStyle(appFont: .large)
		let builder = AttributedStringBuilder(baseStyle: baseStyle)
		try builder.appendProfileBracket(account)
		builder.appendPrimaryText(" ")

		guard viewer != account else { return builder.build() }
		if account.isSubscriber(viewer: viewer) {
			try builder
				.bracket("unsubscribe", deeplink: .action(.unsubscribe), color: .appTint)
				.appendPrimaryText(" ")
		} else {
			try builder
				.bracket("subscribe", deeplink: .action(.subscribe), color: .appTint)
				.appendPrimaryText(" ")
		}

		return builder.build()
	}

	static private func accountContent(viewer: AccountModel, account: AccountModel) throws -> AttributedString {
		let baseStyle = AttributedStringBuilder.BaseStyle(appFont: .large)
		let builder = AttributedStringBuilder(baseStyle: baseStyle)
		builder.appendPrimaryText("\(account.username), \(account.phoneNumber)")
		let content = builder.build()
		return content
	}

	// MARK: - Event

	static func event(viewer: AccountModel, event: EventModel) throws -> ListItemView.Model {
		if event.endDate < .now {
			ListItemView.Model(
				content: try ListItemView.Model.expiredEventContent(event: event),
				controls: try ListItemView.Model.eventControls(viewer: viewer, event: event)
			)
		} else {
			ListItemView.Model(
				content: try ListItemView.Model.eventContent(viewer: viewer, event: event),
				controls: try ListItemView.Model.eventControls(viewer: viewer, event: event)
			)
		}
	}

	static private func otherGoingText(isGoing: Bool, event: EventModel) -> String {
		let guestCount = max(event.guests.count - (isGoing ? 1 : 0), 0)
		return "\(guestCount) other\(guestCount > 1 ? "s" : "")"
	}

	static private func eventControls(viewer: AccountModel, event: EventModel) throws -> AttributedString {
		let baseStyle = AttributedStringBuilder.BaseStyle(appFont: .light)
		let builder = AttributedStringBuilder(baseStyle: baseStyle)
		if event.joinable(viewer: viewer) {
			try builder
				.bracket("join", deeplink: .action(.join), color: .appTint)
				.appendPrimaryText(" ")
		}
		if event.cancellable(viewer: viewer) {
			try builder
				.bracket("can't go", deeplink: .action(.cantGo), color: .appTint)
				.appendPrimaryText(" ")
		}
		if event.deletable(viewer: viewer) {
			try builder
				.bracket("delete", deeplink: .action(.delete), color: .appTint)
				.appendPrimaryText(" ")
		}
		return builder.build()
	}

	static private func expiredEventContent(event: EventModel) throws -> AttributedString {
		let timeValue = DateFormatter().formattedRange(start: event.startDate,
													   end: event.endDate)
		let baseStyle = AttributedStringBuilder.BaseStyle(appFont: .light, strikeThrough: true)
		return try AttributedStringBuilder(baseStyle: baseStyle)
			.appendPrimaryText("\(event.description) • \(timeValue) at ")
			.appendLocationButton(event.location)
			.appendPrimaryText(" • ")
			.build()
	}

	static private func eventContent(viewer: AccountModel, event: EventModel) throws -> AttributedString {
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
					.account(viewer)
					.appendPrimaryText(", ")
					.account(event.creator)
					.appendPrimaryText(" and ")
					.appendGuestListButton(
						text: otherGoingText(isGoing: true, event: event),
						viewer: viewer,
						guests: event.guests
					)
					.appendPrimaryText(" are going •")
			} else {
				try builder
					.account(viewer)
					.appendPrimaryText(" and ")
					.account(event.creator)
					.appendPrimaryText(" are going •")
			}
		} else {
			if event.guests.count > 0 {
				try builder
					.account(event.creator)
					.appendPrimaryText(" and ")
					.appendGuestListButton(
						text: otherGoingText(isGoing: false, event: event),
						viewer: viewer,
						guests: event.guests
					)
					.appendPrimaryText(" are going •")
			} else {
				try builder
					.account(event.creator)
					.appendPrimaryText(" is going •")
			}
		}

		return builder.build()
	}
}

extension AttributedStringBuilder {
	func account(_ account: AccountModel) throws -> AttributedStringBuilder {
		try self.underline(account.username,
					   deeplink: .account(.init(account: account)),
					   color: .primary)
	}
}
