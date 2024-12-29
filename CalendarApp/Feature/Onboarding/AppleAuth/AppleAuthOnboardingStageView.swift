//
//  UsernameOnboardingStageView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/26/24.
//

import SwiftUI
import AuthenticationServices



struct AppleAuthOnboardingStageView: View {
    @EnvironmentObject var context: OnboardingContext
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    @State private var error: Error?

    var body: some View {
        VStack(spacing: 8) {
            SignInWithAppleButton(
                onRequest: configure(request:),
                onCompletion: handle(result:)
            )
            .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
            .frame(maxWidth: .infinity, idealHeight: 40, maxHeight: 40)
        }
        .errorAlert(error: $error)
    }

    private func configure(request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = []
    }

    private func handle(result: Result<ASAuthorization, any Error>) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                context.userIdentifier = appleIDCredential.user
                context.stageIdentifier = AccountMappingStage.identifier
            } else {
                self.error = ErrorManager.with(
                    loggedMessage: "unable to retrieve apple ID credential",
                    appMessage: "unable to retrieve apple ID credential"
                )
            }
        case .failure(let error):
            self.error = error
        }
    }
}

#Preview("step 0") {
    @Previewable @State var dataStore: MockDataStore = MockDataStore(followings: [:])
    OnboardingView()
        .environmentObject(OnboardingContext(stageIdentifier: AppleAuthOnboardingStage.identifier))
        .environmentObject(mockAppSessionStore(account: nil))
        .environmentObject(DataStoreProvider(dataStore: dataStore))
}
