//
//  LocationModel.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import Foundation

struct LocationModel: Codable, Hashable, Equatable {
	var address: String
    var code: String
	var city: String
	var state: String
    var country: String

    struct Realtime: Codable {
        let address: String
        let code: String
        let city: String
        let state: String
        let country: String
    }
}

extension LocationModel {
	var appleMapsDeepLink: URL? {
        let query = "\(address), \(code) \(city), \(state), \(country)"
			.replacingOccurrences(of: " ", with: "+") // Replace spaces with `+` for URL encoding
		return URL(string: "http://maps.apple.com/?q=\(query)")
	}
}

extension LocationModel.Realtime {
    init(model: LocationModel) {
        self.address = model.address
        self.code = model.code
        self.city = model.city
        self.state = model.state
        self.country = model.country
    }

    var model: LocationModel {
        LocationModel(address: address, code: code, city: city, state: state, country: country)
    }
}
