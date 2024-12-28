//
//  OnboardingStep.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/19/24.
//

import SwiftUI

class OnboardingContext: ObservableObject {
    @Published var stageIdentifier: String
    @Published var savedUsername: String? = nil
    @Published var savedPhoneNumber: String? = nil
    @Published var userIdentifier: String? = nil

    init(stageIdentifier: String, savedUsername: String? = nil, savedPhoneNumber: String? = nil, userIdentifier: String? = nil) {
        self.stageIdentifier = stageIdentifier
        self.savedUsername = savedUsername
        self.savedPhoneNumber = savedPhoneNumber
        self.userIdentifier = userIdentifier
    }
}
