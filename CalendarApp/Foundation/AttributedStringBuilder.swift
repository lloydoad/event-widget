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

    @available(*, deprecated, renamed: "Action", message: "should be removed")
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

    class Action: Text {
        let identifier: UUID
        var action: () -> Void

        init(_ text: String, segmentStyle: SegmentStyle, action: @escaping () -> Void) {
            self.identifier = UUID()
            self.action = action
            super.init(text, segmentStyle: segmentStyle)
        }

        static func bracket(_ text: String, color: AppColor, action: @escaping () -> Void) -> Action {
            Action("[\(text)]",
                             segmentStyle: .init(underline: false, color: color),
                             action: action)
        }

        static func underline(_ text: String, color: AppColor, action: @escaping () -> Void) -> Action {
            Action(text,
                             segmentStyle: .init(underline: true, color: color),
                             action: action)
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

    @available(*, deprecated, renamed: "append(action:)", message: "will be removed")
	@discardableResult
	private func appendButton(_ button: Button) -> AttributedStringBuilder {
		var segment = get(text: button.text, segmentStyle: button.segmentStyle)
		segment.link = button.destination
		segment.foregroundColor = button.segmentStyle.color.asUIColor
		fullString += segment
		return self
	}

    @discardableResult
    private func append(action: Action) -> AttributedStringBuilder {
        var segment = get(text: action.text, segmentStyle: action.segmentStyle)
        segment.link = ActionCentralDispatch.shared.url(for: action)
        segment.foregroundColor = action.segmentStyle.color.asUIColor
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
    
    func view() -> SwiftUI.Text {
        SwiftUI.Text(build())
    }

	@discardableResult
	func primaryText(_ text: String) -> AttributedStringBuilder {
		self.appendText(.primary(text))
	}
    
    func text(_ text: Text) -> AttributedStringBuilder {
        return appendText(text)
    }

	@discardableResult
	func bracket(_ text: String, deeplink: DeepLinkParser.Route, color: AppColor) throws -> AttributedStringBuilder {
		appendButton(.bracket(text, destination: try deeplink.url(), color: color))
	}
    
    @discardableResult
    func bracket(_ text: String, fallbackURL: URL, deeplink: DeepLinkParser.Route, color: AppColor) -> AttributedStringBuilder {
        let url = (try? deeplink.url()) ?? fallbackURL
        return appendButton(.bracket(text, destination: url, color: color))
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
    func action(_ action: Action) -> AttributedStringBuilder {
        return append(action: action)
    }
}
