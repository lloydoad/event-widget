//
//  ButtonView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/22/24.
//

import SwiftUI

struct ButtonView: View {
    let baseStyle: StringBuilder.BaseStyle
    let action: StringBuilder.Action

    init(baseStyle: StringBuilder.BaseStyle, action: StringBuilder.Action) {
        self.baseStyle = baseStyle
        self.action = action
    }

    init(title: String, identifier: String, font: AppFont, action: @escaping () -> Void) {
        self.baseStyle = .init(appFont: font)
        self.action = .bracket(title, identifier: identifier, color: .appTint, action: action)
    }

    var body: some View {
        Text(
            StringBuilder(baseStyle: baseStyle)
                .action(action)
                .build()
        )
        .accessibilityIdentifier(action.identifier)
        .onAppear {
            print(action.identifier)
            ActionCentralDispatch.shared.register(action: action)
        }
        .onDisappear {
            ActionCentralDispatch.shared.deregister(identifier: action.text)
        }
    }
}
