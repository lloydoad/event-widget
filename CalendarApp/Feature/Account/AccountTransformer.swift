//
//  EventListItemViewModel.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

struct AccountTransformer {
    let listIdentifier: String

    func transform(account: AccountModel, controlResult: AccountControl.Result) -> AttributedString {
        let baseStyle = StringBuilder.BaseStyle(appFont: .large)
        var builder = StringBuilder(baseStyle: baseStyle)
            .text(.primary("\(account.username), \(account.phoneNumber)\n"))
            .route(.bracket(
                "profile",
                page: .profile(account),
                color: .appTint
            ))
            .text(.primary(" "))
            .account(result: controlResult, account: account, listIdentifier: listIdentifier)
        return builder.build()
    }
}

