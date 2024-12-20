//
//  OnboardingStore.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/19/24.
//

import SwiftUI

class OnboardingStore: ObservableObject {
    @Published var completedSteps: [OnboardingStepComplete] = []
    @Published var usernameEntry: String = ""
    @Published var phoneNumberEntry: String = ""
    @Published var isPerformingActivity: Bool = false

    init(
        completedSteps: [OnboardingStepComplete] = [],
        usernameEntry: String = "",
        phoneNumberEntry: String = "",
        isPerformingActivity: Bool = false
    ) {
        self.completedSteps = completedSteps
        self.usernameEntry = usernameEntry
        self.phoneNumberEntry = phoneNumberEntry
        self.isPerformingActivity = isPerformingActivity
    }
    
    var savedUsername: String? {
        return completedSteps.compactMap { step in
            switch step {
            case .username(let string):
                return string
            default:
                return nil
            }
        }.first
    }
    
    var savedPhoneNumber: String? {
        return completedSteps.compactMap { step in
            switch step {
            case .phoneNumber(let string):
                return string
            default:
                return nil
            }
        }.first
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
    
    var hasPhoneNumber: Bool {
        completedSteps.contains(where: { step in
            switch step {
            case .phoneNumber:
                return true
            default:
                return false
            }
        })
    }
    
    var hasUsernameAndPhoneNumber: Bool {
        hasUsername && hasPhoneNumber
    }

    var hasSyncedContacts: Bool {
        completedSteps.contains(.hasSyncedContacts)
    }
}
