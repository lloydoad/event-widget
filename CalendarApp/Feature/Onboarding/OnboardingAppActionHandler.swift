//
//  OnboardingAppActionHandler.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/21/24.
//

import SwiftUI

@MainActor
struct OnboardingAppActionHandler: AppActionHandler {
    enum ActionError: Error {
        case unhandledAction
    }

    let accountWorker: AccountWorking
    let appSessionStore: AppSessionStore
    let onboardingStore: OnboardingStore
    let dataStoreProvider: DataStoreProvider
    
    init(
        accountWorker: AccountWorking,
        appSessionStore: AppSessionStore,
        onboardingStore: OnboardingStore,
        dataStoreProvider: DataStoreProvider
    ) {
        self.accountWorker = accountWorker
        self.appSessionStore = appSessionStore
        self.onboardingStore = onboardingStore
        self.dataStoreProvider = dataStoreProvider
    }
    
    func canHandle(_ action: AppAction) -> Bool {
        switch action {
        case .claimUsername, .createAccount:
            return true
        default:
            return false
        }
    }

    func handle(_ action: AppAction) async throws {
        switch action {
        case .claimUsername(username: let username):
            onboardingStore.entryText = ""
            onboardingStore.stage = .enterPhoneNumber(username: username)
        case .createAccount(username: let username, phoneNumber: let phoneNumber):
            onboardingStore.isPerformingActivity = true
            Task {
                do {
                    let newUserAccount = try await accountWorker
                        .createAccount(
                            username: username,
                            phoneNumber: phoneNumber,
                            dataStore: dataStoreProvider.dataStore
                        )
                    appSessionStore.userAccount = newUserAccount
                    onboardingStore.isPerformingActivity = false
                    onboardingStore.stage = .enterUsername
                } catch {
                    onboardingStore.isPerformingActivity = false
                    throw error
                }
            }
        default:
            throw ActionError.unhandledAction
        }
    }
}
