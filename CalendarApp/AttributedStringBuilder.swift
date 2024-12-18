//
//  AttributedStringBuilder.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

class AttributedStringBuilder {
	private var fullString = AttributedString()

	struct BaseStyle {
		var appFont: AppFont
		var strikeThrough: Bool = false
	}

	struct SegmentStyle {
		var underline: Bool = false
		var color: AppColor = .primary
	}

	class Text {
		var text: String
		var segmentStyle: SegmentStyle

		init(_ text: String, segmentStyle: SegmentStyle) {
			self.text = text
			self.segmentStyle = segmentStyle
		}

		static func primary(_ text: String) -> Text {
			Text(text, segmentStyle: .init(underline: false, color: .primary))
		}
	}

	class Button: Text {
		var destination: URL
		init(_ text: String, segmentStyle: SegmentStyle, destination: URL) {
			self.destination = destination
			super.init(text, segmentStyle: segmentStyle)
		}

		static func bracket(_ text: String, destination: URL, color: AppColor) -> Button {
			Button("[\(text)]",
				   segmentStyle: .init(underline: false, color: color),
				   destination: destination)
		}

		static func underline(_ text: String, destination: URL, color: AppColor) -> Button {
			Button(text,
				   segmentStyle: .init(underline: true, color: color),
				   destination: destination)
		}
	}

	let baseStyle: BaseStyle
	init(baseStyle: BaseStyle) {
		self.baseStyle = baseStyle
	}

	@discardableResult
	private func appendText(_ text: Text) -> AttributedStringBuilder {
		fullString += get(text: text.text, segmentStyle: text.segmentStyle)
		return self
	}

	@discardableResult
	private func appendButton(_ button: Button) -> AttributedStringBuilder {
		var segment = get(text: button.text, segmentStyle: button.segmentStyle)
		segment.link = button.destination
		segment.foregroundColor = button.segmentStyle.color.asUIColor
		fullString += segment
		return self
	}

	private func get(text: String, segmentStyle: SegmentStyle) -> AttributedString {
		var attributedSegment = AttributedString(text)
		attributedSegment.font = baseStyle.appFont.asFont
		if segmentStyle.underline {
			attributedSegment.underlineStyle = .single
		}
		attributedSegment.foregroundColor = Color(segmentStyle.color.asUIColor)
		if baseStyle.strikeThrough {
			attributedSegment.strikethroughStyle = .single
			attributedSegment.strikethroughColor = segmentStyle.color.asUIColor
		}
		return attributedSegment
	}

	// MARK: - API

	func build() -> AttributedString {
		return fullString
	}

	@discardableResult
	func appendPrimaryText(_ text: String) -> AttributedStringBuilder {
		self.appendText(.primary(text))
	}

//	@discardableResult
//	func appendAccountButton(_ account: AccountModel) throws -> AttributedStringBuilder {
//		let url = try DeepLinkParser.Route.account(.init(account: account)).url()
//		return appendButton(.primaryUnderline(account.username, destination: url))
//	}

	@discardableResult
	func appendProfileBracket(_ account: AccountModel) throws -> AttributedStringBuilder {
		let url = try DeepLinkParser.Route.account(.init(account: account)).url()
		// TODO: change
		return appendButton(.bracket("profile", destination: url, color: .appTint))
	}

	@discardableResult
	func bracket(_ text: String, deeplink: DeepLinkParser.Route, color: AppColor) throws -> AttributedStringBuilder {
		appendButton(.bracket(text, destination: try deeplink.url(), color: color))
	}

	@discardableResult
	func underline(_ text: String, deeplink: DeepLinkParser.Route, color: AppColor) throws -> AttributedStringBuilder {
		appendButton(.underline(text, destination: try deeplink.url(), color: color))
	}

	@discardableResult
	func underline(_ text: String, url: URL, color: AppColor) throws -> AttributedStringBuilder {
		appendButton(.underline(text, destination: url, color: color))
	}

	@discardableResult
	func appendGuestListButton(text: String, viewer: AccountModel, guests: [AccountModel]) throws -> AttributedStringBuilder {
		let accountListViewModel = try AccountListView.Model(
			variant: .guestList,
			accounts: guests.map({ account in
				try .account(viewer: viewer, account: account)
			})
		)
		let route = DeepLinkParser.Route.accounts(accountListViewModel)
		return try underline(text, deeplink: route, color: .primary)
	}

	func appendLocationButton(_ location: LocationModel) throws -> AttributedStringBuilder {
		guard let url = location.appleMapsDeepLink else {
			throw NSError(domain: "calendarApp", code: 1)
		}
		return try underline(location.address, url: url, color: .primary)
	}
}
