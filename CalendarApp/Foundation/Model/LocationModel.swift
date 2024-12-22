//
//  LocationModel.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import Foundation

struct LocationModel: Codable, Hashable, Equatable {
	var address: String
	var city: String
	var state: String
}

extension LocationModel {
	var appleMapsDeepLink: URL? {
		let query = "\(address), \(city), \(state)"
			.replacingOccurrences(of: " ", with: "+") // Replace spaces with `+` for URL encoding
		return URL(string: "http://maps.apple.com/?q=\(query)")
	}
}
