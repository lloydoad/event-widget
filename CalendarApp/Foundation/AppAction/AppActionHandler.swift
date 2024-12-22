//
//  AppActionHandler.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/21/24.
//

@MainActor
protocol AppActionHandler {
    var id: String { get }
    var onComplete: () -> Void { get }
    func canHandle(_ action: AppAction) -> Bool
    func handle(_ action: AppAction) async throws 
}
