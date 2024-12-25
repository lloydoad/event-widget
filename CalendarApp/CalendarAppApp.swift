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
    @StateObject private var actionCoordinator = AppActionCoordinator()
    @StateObject private var dataStoreProvider = DataStoreProvider(dataStore: MockDataStore()) // TODO: Replace with network store
    
    private var accountWorker = AccountWorker()
    private var contactSyncWorker = ContactSyncWorker()

    var body: some Scene {
        WindowGroup {
            MainView(
                accountWorker: accountWorker,
                contactSyncWorker: contactSyncWorker
            )
            .environmentObject(appSessionStore)
            .environmentObject(onboardingStore)
            .environmentObject(dataStoreProvider)
            .environmentObject(actionCoordinator)
		}
    }
}
