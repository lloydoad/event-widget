//
//  OnboardingStore.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/19/24.
//

import SwiftUI

class OnboardingStore: ObservableObject {
    @Published var stage: OnboardingStage = .enterUsername
    @Published var entryText: String = ""
    @Published var isPerformingActivity: Bool = false

    init(
        stage: OnboardingStage = .enterUsername,
        entryText: String = "",
        isPerformingActivity: Bool = false
    ) {
        self.stage = stage
        self.entryText = entryText
        self.isPerformingActivity = isPerformingActivity
    }
}
