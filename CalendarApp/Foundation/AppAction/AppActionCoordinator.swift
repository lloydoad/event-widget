//
//  ActionCoordinator.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/21/24.
//

import SwiftUI

@MainActor
class AppActionCoordinator: ObservableObject {
    enum CoordinatorError: Error {
        case notHandled
        case duplicateHandlers
    }

    private var handlers: [AppActionHandler] = []

    func register(_ handler: AppActionHandler) {
        handlers.append(handler)
    }

    func handle(_ action: AppAction) async throws {
        let possibleHandlers = handlers.filter { $0.canHandle(action) }
        guard let handler = possibleHandlers.first else {
            throw CoordinatorError.notHandled
        }
        if possibleHandlers.count > 1 {
            throw CoordinatorError.duplicateHandlers
        }
        try await handler.handle(action)
    }
}
