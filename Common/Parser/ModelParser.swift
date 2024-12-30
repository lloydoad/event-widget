//
//  ModelParser.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI
import os

fileprivate let codingLogger = Logger(subsystem: "ModelParser", category: "Coding")

struct ModelParser {
	enum ParseError: Error {
		case encodingFailed
		case decodingFailed
	}

	func encode<T: Codable>(_ value: T) throws -> String {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(value)
            guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                throw ErrorManager.with(loggedMessage: "unable to convert json data to string")
            }
            return jsonString
        } catch {
            codingLogger.error("\(error.localizedDescription)")
            throw error
        }
	}

	func decode<T: Codable>(_ jsonString: String, as type: T.Type) throws -> T {
        do {
            let decoder = JSONDecoder()
            guard let jsonData = jsonString.data(using: .utf8) else {
                throw ErrorManager.with(loggedMessage: "unable to convert json string to data")
            }
            return try decoder.decode(type, from: jsonData)
        } catch {
            codingLogger.error("\(error.localizedDescription)")
            throw error
        }
	}
}
