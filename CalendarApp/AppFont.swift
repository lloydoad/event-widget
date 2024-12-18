//
//  AppFont.swift
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
