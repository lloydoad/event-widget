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
	func primaryText(_ text: String) -> AttributedStringBuilder {
		self.appendText(.primary(text))
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
}
