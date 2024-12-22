//
//  EventListItemViewModel.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

extension ListItemView.Model {
	// MARK: - Account

    static func account(viewer: AccountModel, account: AccountModel, following: [UUID]) throws -> ListItemView.Model {
		ListItemView.Model(
			content: ListItemView.Model.accountContent(viewer: viewer, account: account),
            controls: try ListItemView.Model.accountControls(viewer: viewer, account: account, following: following)
		)
	}

	static func accountControls(viewer: AccountModel, account: AccountModel, following: [UUID]) throws -> AttributedString {
		let baseStyle = AttributedStringBuilder.BaseStyle(appFont: .large)
		let builder = try AttributedStringBuilder(baseStyle: baseStyle)
			.bracket("profile", deeplink: .push(.profile(account)), color: .appTint)
		builder.primaryText(" ")

		guard viewer != account else { return builder.build() }
        if following.contains(account.uuid) {
			try builder
				.bracket("unsubscribe", deeplink: .action(.unsubscribe), color: .appTint)
				.primaryText(" ")
		} else {
			try builder
				.bracket("subscribe", deeplink: .action(.subscribe), color: .appTint)
				.primaryText(" ")
		}

		return builder.build()
	}

	static func accountContent(viewer: AccountModel, account: AccountModel) -> AttributedString {
		let baseStyle = AttributedStringBuilder.BaseStyle(appFont: .large)
		let builder = AttributedStringBuilder(baseStyle: baseStyle)
		builder.primaryText("\(account.username), \(account.phoneNumber)")
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
				.primaryText(" ")
		}
		if event.cancellable(viewer: viewer) {
			try builder
				.bracket("can't go", deeplink: .action(.cantGo), color: .appTint)
				.primaryText(" ")
		}
		if event.deletable(viewer: viewer) {
			try builder
				.bracket("delete", deeplink: .action(.delete), color: .appTint)
				.primaryText(" ")
		}
		return builder.build()
	}

	static private func expiredEventContent(event: EventModel) throws -> AttributedString {
		let timeValue = DateFormatter().formattedRange(start: event.startDate,
													   end: event.endDate)
		let baseStyle = AttributedStringBuilder.BaseStyle(appFont: .light, strikeThrough: true)
		return try AttributedStringBuilder(baseStyle: baseStyle)
			.primaryText("\(event.description) • \(timeValue) at ")
			.location(event.location)
			.primaryText(" • ")
			.build()
	}

    static private func eventContent(viewer: AccountModel, event: EventModel) throws -> AttributedString {
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
