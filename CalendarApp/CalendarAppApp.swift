//
//  CalendarAppApp.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

@main
struct CalendarAppApp: App {
    @State private var isInitializing: Bool = true
    @State private var error: Error? = nil

    @StateObject private var appSessionStore = AppSessionStore()
    @StateObject private var dataStoreProvider = DataStoreProvider(
        dataStore: MockDataStore(accounts: [], followings: [:], events: [])
    )

    private var contactSyncWorker = ContactSyncWorker()

    var body: some Scene {
        WindowGroup {
            VStack {
                if isInitializing {
                    ZStack {
                        ProgressView()
                            .tint(AppColor.appTint.asColor)
                    }
                } else {
                    MainView(contactSyncWorker: contactSyncWorker)
                        .environmentObject(appSessionStore)
                        .environmentObject(dataStoreProvider)
                }
            }
            .errorAlert(error: $error)
            .onAppear {
                setupDatabase()
            }
		}
    }

    func setupDatabase() {
        do {
            dataStoreProvider.dataStore = try SupabaseDataStore()
            isInitializing = false
        } catch {
            self.error = error
        }
    }
}
