//
//  DateFormatterExtension.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import Foundation

extension DateFormatter {
	func formattedRange(start: Date, end: Date) -> String {
		dateFormat = "h:mma" // 12-hour format with am/pm
		let startTime = string(from: start).lowercased()
		let endTime = string(from: end).lowercased()
		let cleanStartTime = startTime
			.replacingOccurrences(of: ":00", with: "")
		let cleanEndTime = endTime
			.replacingOccurrences(of: ":00", with: "")
		return "\(cleanStartTime) to \(cleanEndTime)"
	}
}
