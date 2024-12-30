//
//  AppFont.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

enum AppFont {
    case widget
	case light
	case large
	case footer
	case navigationTitle

	var asFont: Font {
		switch self {
        case .widget:
            Font.system(size: 13, weight: .light, design: .serif)
		case .light:
			Font.system(size: 18, weight: .light, design: .serif)
		case .large:
			Font.system(size: 20, weight: .medium, design: .serif)
		case .footer:
			Font.system(size: 20, weight: .ultraLight, design: .serif)
		case .navigationTitle:
			Font.system(size: 24, weight: .medium, design: .serif)
		}
	}
}
