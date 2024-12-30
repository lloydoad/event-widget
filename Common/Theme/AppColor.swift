//
//  AppColor.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

enum AppColor: Codable {
	case primary
	case secondary
//	case accent
	case appTint

	var asUIColor: UIColor {
		switch self {
		case .appTint:
//			return UIColor(red: 38.0 / 255.0, green: 167.0 / 255.0, blue: 222.0 / 255.0, alpha: 1)
            return UIColor.tintColor
		case .primary:
			return UIColor.label
		case .secondary:
			return UIColor.secondaryLabel
		}
	}
    
    var asColor: Color {
        Color(asUIColor)
    }
}
