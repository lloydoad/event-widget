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
        let baseStyle = StringBuilder.BaseStyle(appFont: .large)
        let builder = StringBuilder(baseStyle: baseStyle)
        builder.text(.primary("\(account.username), \(account.phoneNumber)"))
        let content = builder.build()
        return content
    }
}

