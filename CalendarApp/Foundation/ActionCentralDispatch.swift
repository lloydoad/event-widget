//
//  AttributedActionHandler.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/25/24.
//

import SwiftUI

class ActionCentralDispatch {
    static let shared = ActionCentralDispatch()
    private init() {}

    private var registeredActions: [String: AttributedStringBuilder.Action] = [:]
    private let scheme = "calendarapp"
    private let host = "attributedaction"
    private let identifierQueryItemName = "identifier"

    func url(for actionHandler: AttributedStringBuilder.Action) -> URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.queryItems = [
            URLQueryItem(name: identifierQueryItemName, value: actionHandler.identifier.uuidString)
        ]
        return components.url!
    }

    func action(for url: URL) -> AttributedStringBuilder.Action? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        guard components?.scheme == scheme else { return nil }
        guard components?.host == host else { return nil }
        let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
        guard let queryItemIdentifier = queryItems?.first(where: {
            $0.name == identifierQueryItemName
        })?.value else { return nil }
        return registeredActions[queryItemIdentifier]
    }

    func register(action: AttributedStringBuilder.Action) {
        registeredActions[action.identifier.uuidString] = action
    }

    func deregister(identifier: UUID) {
        registeredActions[identifier.uuidString] = nil
    }

    func handle(url: URL) {
        action(for: url)?.action()
    }
}
