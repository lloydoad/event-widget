//
//  AccountMappingStage.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/28/24.
//

import SwiftUI

struct AccountMappingStage: OnboardingStage {
    static var identifier: String {
        "map_identifier_to_account"
    }

    var identifier: String {
        Self.identifier
    }

    var personalizedTitle: String? {
        "🔐 connecting your account"
    }

    func body(context: OnboardingContext) -> AnyView {
        AnyView(
            AccountMappingStageView()
                .environmentObject(context)
        )
    }

    func isApplicable(context: OnboardingContext) -> Bool {
        context.stageIdentifier == Self.identifier && context.userIdentifier != nil
    }
}
