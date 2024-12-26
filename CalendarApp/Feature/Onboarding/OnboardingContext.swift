//
//  OnboardingStep.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/19/24.
//

import SwiftUI

class OnboardingContext: ObservableObject {
    @Published var stageIdentifier: String
    @Published var savedUsername: String?
    @Published var savedPhoneNumber: String?

    init(stageIdentifier: String, savedUsername: String? = nil, savedPhoneNumber: String? = nil) {
        self.stageIdentifier = stageIdentifier
        self.savedUsername = savedUsername
        self.savedPhoneNumber = savedPhoneNumber
    }
}
