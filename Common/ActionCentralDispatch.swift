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

    private var registeredActions: [String: StringBuilder.Action] = [:]
    private let scheme = "calendarapp"
    private let host = "attributedaction"
    private let identifierQueryItemName = "identifier"

    func url(for action: StringBuilder.Action) -> URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.queryItems = [
            URLQueryItem(name: identifierQueryItemName, value: action.identifier)
        ]
        return components.url!
    }

    func action(for url: URL) -> StringBuilder.Action? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        guard components?.scheme == scheme else { return nil }
        guard components?.host == host else { return nil }
        let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
        guard let queryItemIdentifier = queryItems?.first(where: {
            $0.name == identifierQueryItemName
        })?.value else { return nil }
        let action = registeredActions[queryItemIdentifier]
        return action
    }

    func register(action: StringBuilder.Action) {
        ActionLogger.info("Register \(action.identifier)")
        registeredActions[action.identifier] = action
    }

    func register(identifier: String, action: @escaping () -> Void) {
        register(action: StringBuilder.Action("", identifier: identifier, segmentStyle: .init(), action: action))
    }

    func deregister(identifier: String) {
        ActionLogger.info("Deregister \(identifier)")
        if !registeredActions.contains(where: { $0.key == identifier }) {
            ActionLogger.error("Attempted to deregister non-existent action: \(identifier)")
        }
        registeredActions[identifier] = nil
    }

    func handle(url: URL) {
        let foundAction = action(for: url)
        foundAction?.action()
    }

    func handle(action identifier: String) {
        registeredActions[identifier]?.action()
    }
}
