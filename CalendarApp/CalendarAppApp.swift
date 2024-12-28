//
//  CalendarAppApp.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

@main
struct CalendarAppApp: App {
    @StateObject private var appSessionStore = AppSessionStore()
    @StateObject private var dataStoreProvider = DataStoreProvider(dataStore: SupabaseDataStore())

    private var contactSyncWorker = ContactSyncWorker()

    var body: some Scene {
        WindowGroup {
            MainView(contactSyncWorker: contactSyncWorker)
                .environmentObject(appSessionStore)
                .environmentObject(dataStoreProvider)
		}
    }
}
