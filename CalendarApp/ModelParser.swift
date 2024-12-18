//
//  ModelParser.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

struct ModelParser {
	enum ParseError: Error {
		case encodingFailed
		case decodingFailed
	}

	func encode<T: Codable>(_ value: T) throws -> String {
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		let jsonData = try encoder.encode(value)
		guard let jsonString = String(data: jsonData, encoding: .utf8) else {
			throw ParseError.encodingFailed
		}
		return jsonString
	}

	func decode<T: Codable>(_ jsonString: String, as type: T.Type) throws -> T {
		let decoder = JSONDecoder()
		guard let jsonData = jsonString.data(using: .utf8) else {
			throw ParseError.decodingFailed
		}
		return try decoder.decode(type, from: jsonData)
	}
}
