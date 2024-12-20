//
//  SignInWithAppleView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/19/24.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var onboardingContext: OnboardingContext
    
    @State private var showAlert = false
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            SignInWithAppleButton(
                onRequest: { request in
                    request.requestedScopes = [.fullName]
                },
                onCompletion: { result in
                    switch result {
                    case .success(let authResults):
                        let credential = authResults.credential as? ASAuthorizationAppleIDCredential
                        print(credential?.user)
                        print(credential?.authorizedScopes)
                        print(credential)
                        print(credential?.fullName)
                        print(credential?.fullName?.givenName)
                        print(credential?.fullName?.familyName)
                        if
                            let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential,
                            let fullName = appleIDCredential.fullName,
                            let firstName = fullName.givenName,
                            let lastName = fullName.familyName,
                            !firstName.isEmpty,
                            !lastName.isEmpty
                        {
                            let firstCharacterOfLastName = lastName.first?.lowercased()
                            var username: String = firstName
                            if let firstCharacterOfLastName {
                                username += " " + firstCharacterOfLastName
                            }
//                            onboardingContext.username = username
                            dismiss()
                        } else {
                            
                            errorMessage = "Something went wrong"
                            showAlert = true
                        }
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                        showAlert = true
                    }
                }
            )
            .frame(height: 50)
            .padding()
            .signInWithAppleButtonStyle(colorScheme == .dark ? .black : .white)
            Spacer()
                .frame(maxHeight: .infinity)
        }
        .presentationDetents([.height(100)])
        .alert("Authorization Failed", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
}

#Preview("light") {
    @Previewable @State var isShowing: Bool = false
    Button("Show") {
        isShowing.toggle()
    }
    .sheet(isPresented: $isShowing) {
        SignInWithAppleView()
            .environmentObject(OnboardingContext())
            .environment(\.colorScheme, .light)
    }
}

#Preview("dark") {
    @Previewable @State var isShowing: Bool = false
    Button("Show") {
        isShowing.toggle()
    }
    .sheet(isPresented: $isShowing) {
        SignInWithAppleView()
            .environmentObject(OnboardingContext())
            .environment(\.colorScheme, .dark)
    }
}
