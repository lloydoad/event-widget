//
//  OnboardingContext.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/19/24.
//

import SwiftUI

class OnboardingContext: ObservableObject {
    @Published var completedSteps: [OnboardingStepComplete] = []
    @Published var usernameEntry: String = ""
    @Published var isPerformingActivity: Bool = false

    init(completedSteps: [OnboardingStepComplete] = [], usernameEntry: String = "", isPerformingActivity: Bool = false) {
        self.completedSteps = completedSteps
        self.usernameEntry = usernameEntry
        self.isPerformingActivity = isPerformingActivity
    }

    var hasUsername: Bool {
        completedSteps.contains(where: { step in
            switch step {
            case .username:
                return true
            default:
                return false
            }
        })
    }

    var hasSyncedContacts: Bool {
        completedSteps.contains(.hasSyncedContacts)
    }
}
