//
//  EventListItemViewModel.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

struct AccountTransformer {
    let viewer: AccountModel

    func transform(account: AccountModel) -> AttributedString {
        let baseStyle = AttributedStringBuilder.BaseStyle(appFont: .large)
        let builder = AttributedStringBuilder(baseStyle: baseStyle)
        builder.primaryText("\(account.username), \(account.phoneNumber)")
        let content = builder.build()
        return content
    }
}

