//
//  AppActionHandler.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/21/24.
//

@MainActor
protocol AppActionHandler {
    func canHandle(_ action: AppAction) -> Bool
    func handle(_ action: AppAction) async throws 
}
