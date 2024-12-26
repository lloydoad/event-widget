//
//  ButtonView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/22/24.
//

import SwiftUI

struct ButtonView: View {
    let baseStyle: AttributedStringBuilder.BaseStyle
    let action: AttributedStringBuilder.Action

    init(baseStyle: AttributedStringBuilder.BaseStyle, action: AttributedStringBuilder.Action) {
        self.baseStyle = baseStyle
        self.action = action
    }

    init(title: String, identifier: String, font: AppFont, action: @escaping () -> Void) {
        self.baseStyle = .init(appFont: font)
        self.action = .bracket(title, identifier: identifier, color: .appTint, action: action)
    }

    var body: some View {
        Text(
            AttributedStringBuilder(baseStyle: baseStyle)
                .action(action)
                .build()
        )
        .onAppear {
            ActionCentralDispatch.shared.register(action: action)
        }
        .onDisappear {
            ActionCentralDispatch.shared.deregister(identifier: action.text)
        }
    }
}
