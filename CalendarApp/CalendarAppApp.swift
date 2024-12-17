//
//  CalendarAppApp.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

@main
struct CalendarAppApp: App {
    var body: some Scene {
        WindowGroup {
			ContentView(model: ContentView.Model(eventRows: []))
        }
    }
}
