//
//  DeepLinkParser.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

struct DeepLinkParser {
    enum Page: Codable, Hashable, Identifiable {
        case feed
        case profile(AccountModel)
        case guestList([AccountModel])
        case subscriptions
        case composer(EventModel?)

        var id: String {
            hashValue.description
        }
    }

	enum Route: Codable, Hashable {
        case push(Page)
        case sheet(Page)

		func url(modelParser: ModelParser = .init()) throws -> URL {
			let dataString = try modelParser.encode(self)
			var deeplinkURL = "calendarapp://"
			deeplinkURL += Key.routeHost.rawValue
			deeplinkURL += "?\(Key.queryItemDataString.rawValue)="
			deeplinkURL += dataString
			return URL(string: deeplinkURL)!
		}

        static var fallbackURL: URL {
            URL(string: "calendarapp://")!
        }

		static func decode(_ string: String, modelParser: ModelParser = .init()) throws -> Route {
			try modelParser.decode(string, as: Route.self)
		}
	}

	enum Key: String {
		case routeHost = "route"
		case queryItemDataString = "dataString"
	}

	func getRoute(url: URL) -> Route? {
		let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
		guard let host = components?.host, host == Key.routeHost.rawValue else { return nil }
		guard let dataString = components?.queryItems?.first(where: { item in
			item.name == Key.queryItemDataString.rawValue
		})?.value else { return nil }
		return try? Route.decode(dataString)
	}
}
