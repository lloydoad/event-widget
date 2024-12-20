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

	func createDate(
		day: Int? = nil,
		month: Int? = nil,
		year: Int? = nil,
		hour: Int? = nil,
		minute: Int? = nil
	) -> Date? {
		var components = Calendar.current.dateComponents([
			.year, .month, .day, .hour, .minute
		], from: Date())
		components.day = day ?? components.day
		components.month = month ?? components.month
		components.year = year ?? components.year
		components.hour = hour ?? components.hour
		components.minute = minute ?? components.minute
		return Calendar.current.date(from: components)
	}
}
