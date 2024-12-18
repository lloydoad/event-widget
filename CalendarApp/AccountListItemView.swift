//
//  AccountListItemView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/18/24.
//

import SwiftUI

struct AccountListItemView: View {
	struct Model: Hashable, Codable {
		var content: AttributedString
		var controls: AttributedString
	}

	var model: Model

	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			Text(model.content)
				.frame(maxWidth: .infinity, alignment: .leading)
			Text(model.controls)
				.frame(maxWidth: .infinity, alignment: .leading)
			Color(cgColor: UIColor.tertiaryLabel.cgColor)
				.frame(width: 100, height: 1)
		}
	}
}

extension AccountListItemView.Model {
	init(viewer: AccountModel, account: AccountModel) throws {
		content = try Self.content(viewer: viewer, account: account)
		controls = try Self.controls(viewer: viewer, account: account)
	}

	static func controls(viewer: AccountModel, account: AccountModel) throws -> AttributedString {
		let baseStyle = AttributedStringBuilder.BaseStyle(appFont: .large)
		let builder = AttributedStringBuilder(baseStyle: baseStyle)
		try builder.appendProfileBracket(account)
		builder.appendPrimaryText(" ")

		guard viewer != account else { return builder.build() }
		if account.isSubscriber(viewer: viewer) {
			builder.appendBracketButton("unsubscribe", destination: "calendarapp://account", color: .accent)
			builder.appendPrimaryText(" ")
		} else {
			builder.appendBracketButton("subscribe", destination: "calendarapp://account", color: .accent)
			builder.appendPrimaryText(" ")
		}

		return builder.build()
	}

	static func content(viewer: AccountModel, account: AccountModel) throws -> AttributedString {
		let baseStyle = AttributedStringBuilder.BaseStyle(appFont: .large)
		let builder = AttributedStringBuilder(baseStyle: baseStyle)
		builder.appendPrimaryText("\(account.username), \(account.phoneNumber)")
		return builder.build()
	}
}
