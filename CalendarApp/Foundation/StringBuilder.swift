//
//  StringBuilder.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

class StringBuilder {
	private var fullString = AttributedString()

    struct BaseStyle: Hashable {
		var appFont: AppFont
		var strikeThrough: Bool = false
	}

    struct SegmentStyle: Hashable {
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

        static func secondary(_ text: String) -> Text {
            Text(text, segmentStyle: .init(underline: false, color: .secondary))
        }
	}

	class Route: Text {
		var destination: URL

        private init(_ text: String, segmentStyle: SegmentStyle, destination: URL) {
			self.destination = destination
			super.init(text, segmentStyle: segmentStyle)
		}

        static func underline(_ text: String, page: DeepLinkParser.Page, color: AppColor) -> Route {
            Route(text,
                  segmentStyle: .init(underline: true, color: color),
                  destination: try! DeepLinkParser.Route.push(page).url())
		}

        static func underline(_ text: String, destination: URL, color: AppColor) -> Route {
            Route(text,
                  segmentStyle: .init(underline: true, color: color),
                  destination: destination)
        }

        static func bracket(_ text: String, page: DeepLinkParser.Page, color: AppColor) -> Route {
            Route("[\(text)]",
                  segmentStyle: .init(underline: false, color: color),
                  destination: try! DeepLinkParser.Route.push(page).url())
        }
	}

    class Action: Text, Equatable {
        var identifier: String
        var action: () -> Void

        init(_ text: String, identifier: String, segmentStyle: SegmentStyle, action: @escaping () -> Void) {
            self.action = action
            self.identifier = identifier
            super.init(text, segmentStyle: segmentStyle)
        }

        static func bracket(_ text: String, identifier: String, color: AppColor, action: @escaping () -> Void) -> Action {
            Action("[\(text)]",
                   identifier: identifier,
                   segmentStyle: .init(underline: false, color: color),
                   action: action)
        }

        static func underline(_ text: String, identifier: String, color: AppColor, action: @escaping () -> Void) -> Action {
            Action(text,
                   identifier: identifier,
                   segmentStyle: .init(underline: true, color: color),
                   action: action)
        }

        static func == (lhs: Action, rhs: Action) -> Bool {
            return lhs.text == rhs.text
        }
    }

	let baseStyle: BaseStyle
	init(baseStyle: BaseStyle) {
		self.baseStyle = baseStyle
	}

	private func appendText(_ text: Text) -> StringBuilder {
		fullString += get(text: text.text, segmentStyle: text.segmentStyle)
		return self
	}

    private func append(route: Route) -> StringBuilder {
		var segment = get(text: route.text, segmentStyle: route.segmentStyle)
		segment.link = route.destination
		segment.foregroundColor = route.segmentStyle.color.asUIColor
		fullString += segment
		return self
	}

    private func append(action: Action) -> StringBuilder {
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
    func text(_ text: Text) -> StringBuilder {
        return appendText(text)
    }

    @discardableResult
    func route(_ route: Route) -> StringBuilder {
        append(route: route)
    }

    @discardableResult
    func action(_ action: Action) -> StringBuilder {
        append(action: action)
    }

    @discardableResult
    func staticIfElse(
        condition: Bool,
        trueBlock: (StringBuilder) -> StringBuilder,
        falseBlock: (StringBuilder) -> StringBuilder
    ) -> StringBuilder {
        if condition {
            return trueBlock(self)
        } else {
            return falseBlock(self)
        }
    }
}
