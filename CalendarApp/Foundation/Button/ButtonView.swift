//
//  ButtonView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/22/24.
//

import SwiftUI

struct ButtonView: View {
    let action: AppAction
    let font: AppFont
    let actionCoordinator: AppActionCoordinator

    var body: some View {
        Text(text(
            action.defaultTitle,
            baseStyle: .init(appFont: font),
            action: action
        ))
    }

    private func text(_ value: String, baseStyle: AttributedStringBuilder.BaseStyle, action: AppAction) -> AttributedString {
        AttributedStringBuilder(baseStyle: baseStyle)
            .bracket(value, fallbackURL: DeepLinkParser.Route.fallbackURL, deeplink: .action(action), color: .appTint)
            .build()
    }

    func onAction(handler: AppActionHandler) -> Self {
        actionCoordinator.register(handler)
        return self
    }
}
