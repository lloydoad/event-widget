//
//  ButtonModel.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import Foundation

struct ButtonModel: Hashable, Codable {
	var title: String
	var color: AppColor
	var route: DeepLinkParser.Route
}

extension ButtonModel {
	var asAttributedString: AttributedString {
		do {
			return try AttributedStringBuilder(baseStyle: .init(appFont: .large))
				.bracket(title, deeplink: route, color: color)
				.build()
		} catch {
			return ""
		}
	}
}
