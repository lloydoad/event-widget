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

    private init(baseStyle: AttributedStringBuilder.BaseStyle, action: AttributedStringBuilder.Action) {
        self.baseStyle = baseStyle
        self.action = action
    }

    init(title: String, identifier: UUID = UUID(), font: AppFont, action: @escaping () -> Void) {
        self.baseStyle = .init(appFont: font)
        self.action = .bracket(title, uuid: identifier, color: .appTint, action: action)
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
            ActionCentralDispatch.shared.deregister(identifier: action.identifier)
        }
    }
}
