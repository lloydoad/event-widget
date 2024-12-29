//
//  OnboardingStage.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/26/24.
//

import SwiftUI

protocol OnboardingStage {
    static var identifier: String { get }
    var identifier: String { get }
    var personalizedTitle: String? { get }
    func body(context: OnboardingContext) -> AnyView
    func isApplicable(context: OnboardingContext) -> Bool
}
