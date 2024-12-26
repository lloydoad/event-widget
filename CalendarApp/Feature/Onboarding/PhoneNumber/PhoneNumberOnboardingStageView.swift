//
//  PhoneNumberOnboardingStageView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/26/24.
//

import SwiftUI

struct PhoneNumberOnboardingStageView: View {
    @EnvironmentObject var context: OnboardingContext
    @EnvironmentObject var appSessionStore: AppSessionStore
    @EnvironmentObject var dataStoreProvider: DataStoreProvider

    @State private var entryText: String = ""
    @State private var showProgress: Bool = false
    @State private var error: Error?

    private let createAccountActionUUID = UUID()
    private let formatter = PhoneNumberFormatter()

    var body: some View {
        VStack(spacing: 8) {
            PhoneNumberFieldView(formatter: formatter, text: $entryText)
            if formatter.isValid(entryText) {
                if showProgress {
                    HStack {
                        ProgressView()
                        StringBuilder(baseStyle: .init(appFont: .large))
                            .text(.primary("creating account "))
                            .view()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                } else {
                    ButtonView(
                        title: "create account",
                        identifier: createAccountActionUUID.uuidString,
                        font: .large,
                        action: {
                            createAccount()
                        })
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .errorAlert(error: $error)
    }

    @State private var currentTask: Task<Void, Error>? = nil
    func createAccount() {
        guard let username = context.savedUsername else { return }
        let phoneNumber = entryText

        showProgress = true
        currentTask?.cancel()

        currentTask = Task {
            do {
                let newAccount = AccountModel(uuid: .init(), username: username, phoneNumber: phoneNumber)
                try await dataStoreProvider.dataStore.save(account: newAccount)
                showProgress = false
                appSessionStore.userAccount = newAccount
            } catch {
                showProgress = false
                self.error = error
            }
        }
    }
}

#Preview("phone number entry - without text") {
    OnboardingView()
        .environmentObject(OnboardingContext(
            stageIdentifier: PhoneNumberOnboardingStage.identifier,
            savedUsername: "johndoe"
        ))
        .environmentObject(mockAppSessionStore(account: nil))
        .environmentObject(DataStoreProvider(dataStore: MockDataStore()))
}
