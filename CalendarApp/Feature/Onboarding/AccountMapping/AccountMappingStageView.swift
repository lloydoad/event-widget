//
//  AccountMappingStageView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/28/24.
//

import SwiftUI

struct AccountMappingStageView: View {
    @EnvironmentObject var context: OnboardingContext
    @EnvironmentObject var appSessionStore: AppSessionStore
    @EnvironmentObject var dataStoreProvider: DataStoreProvider

    var body: some View {
        HStack {
            ProgressView()
                .tint(AppColor.appTint.asColor)
            Spacer()
        }
        .onAppear {
            fetchAccountIfPresent()
        }
    }

    private func fetchAccountIfPresent() {
        guard let userIdentifier = context.userIdentifier else { return }
        Task {
            do {
                let existingAccount = try await dataStoreProvider
                    .dataStore
                    .getAccount(appleUserIdentifier: userIdentifier)
                Task { @MainActor in
                    if let existingAccount {
                        appSessionStore.userAccount = existingAccount
                    } else {
                        context.stageIdentifier = UsernameOnboardingStage.identifier
                    }
                }
            } catch {
                Task { @MainActor in
                    SystemLogger.error("\(error.localizedDescription)")
                    context.userIdentifier = nil
                    context.stageIdentifier = AppleAuthOnboardingStage.identifier
                }
            }
        }
    }
}
