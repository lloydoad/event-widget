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

		static func primaryUnderline(_ text: String, destination: URL) -> Button {
			Button(text,
				   segmentStyle: .init(underline: true, color: .primary),
				   destination: destination)
		}
	}

	let baseStyle: BaseStyle
	init(baseStyle: BaseStyle) {
		self.baseStyle = baseStyle
	}

	@discardableResult
	func appendText(_ text: Text) -> AttributedStringBuilder {
		fullString += get(text: text.text, segmentStyle: text.segmentStyle)
		return self
	}

	@discardableResult
	func appendButton(_ button: Button) -> AttributedStringBuilder {
		var segment = get(text: button.text, segmentStyle: button.segmentStyle)
		segment.link = button.destination
		fullString += segment
		return self
	}

	func build() -> AttributedString {
		return fullString
	}

	@discardableResult
	func appendPrimaryText(_ text: String) -> AttributedStringBuilder {
		self.appendText(.primary(text))
	}

	@discardableResult
	func appendPrimaryUnderlinedButton(_ text: String, destination: String) -> AttributedStringBuilder {
		self.appendButton(.primaryUnderline(text,
											destination: URL(string: destination)!))
	}

	@discardableResult
	func appendBracketButton(_ text: String, destination: String, color: AppColor) -> AttributedStringBuilder {
		self.appendButton(.bracket(text, destination: URL(string: destination)!, color: color))
	}

	@discardableResult
	func appendPrimaryUnderlinedAccount(_ account: AccountModel, isCurrentViewer: Bool = false) throws -> AttributedStringBuilder {
		let url = try DeepLinkParser.Route.account(account).url()
		return appendButton(.primaryUnderline(isCurrentViewer ? "you" : account.username, destination: url))
	}

	@discardableResult
	func appendGuestListButton(text: String, guests: [AccountModel]) throws -> AttributedStringBuilder {
		let url = try DeepLinkParser.Route.eventGuests(guests).url()
		return appendButton(.primaryUnderline(text, destination: url))
	}

	private func get(text: String, segmentStyle: SegmentStyle) -> AttributedString {
		var attributedSegment = AttributedString(text)
		attributedSegment.font = baseStyle.appFont.asFont
		if segmentStyle.underline {
			attributedSegment.underlineStyle = .single
		}
		attributedSegment.foregroundColor = Color(segmentStyle.color.asUIColor)
		return attributedSegment
	}
}
