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
    @StateObject private var onboardingStore = OnboardingStore()
    @StateObject private var dataStoreProvider = DataStoreProvider(dataStore: MockDataStore()) // TODO: Replace with network store

    var body: some Scene {
        WindowGroup {
            MainView(
                accountWorker: AccountWorker(dataStore: dataStoreProvider.dataStore),
                eventWorker: EventWorker(dataStore: dataStoreProvider.dataStore),
                contactSyncWorker: ContactSyncWorker()
            )
            .environmentObject(appSessionStore)
            .environmentObject(onboardingStore)
            .environmentObject(dataStoreProvider)
		}
    }
}
