//
//  AttributedStringBuilder.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

enum AppFont {
	case light
	case large

	var asFont: Font {
		switch self {
		case .light:
			Font.system(size: 18, weight: .light, design: .serif)
		case .large:
			Font.system(size: 20, weight: .medium, design: .serif)
		}
	}
}

enum AppColor: Codable {
	case primary
	case secondary
	case accent

	var asUIColor: UIColor {
		switch self {
		case .accent:
			return UIColor(red: 38.0 / 255.0, green: 167.0 / 255.0, blue: 222.0 / 255.0, alpha: 1)
		case .primary:
			return UIColor.label
		case .secondary:
			return UIColor.secondaryLabel
		}
	}
}

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
	func appendPrimaryUnderlinedAccount(_ account: AccountModel) throws -> AttributedStringBuilder {
		let url = try DeepLinkParser.Route.account(account).url()
		return appendButton(.primaryUnderline(account.username, destination: url))
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
