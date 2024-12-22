//
//  ButtonView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/22/24.
//

import SwiftUI

struct ButtonView: View {
    @EnvironmentObject var actionCoordinator: AppActionCoordinator
    var text: String
    var baseStyle: AttributedStringBuilder.BaseStyle
    var route: DeepLinkParser.Route
    var actionHandler: AppActionHandler

    var body: some View {
        Text(title(text, route: route))
            .onAppear {
                actionCoordinator.register(actionHandler)
            }
    }

    private func title(_ text: String, route: DeepLinkParser.Route) -> AttributedString {
        AttributedStringBuilder(baseStyle: baseStyle)
            .bracket(text, fallbackURL: DeepLinkParser.Route.fallbackURL, deeplink: route, color: .appTint)
            .build()
    }
}

// MARK: Convenience inits

extension ButtonView {
    static func subscribe(
        account: AccountModel,
        appSessionStore: AppSessionStore,
        dataStoreProvider: DataStoreProvider,
        message: Binding<SubscriptionAppActionHandler.Message>
    ) -> ButtonView {
        ButtonView(
            text: "subscribe",
            baseStyle: .init(appFont: .light),
            route: .action(.subscribe),
            actionHandler: SubscriptionAppActionHandler(
                account: account,
                appSessionStore: appSessionStore,
                dataStoreProvider: dataStoreProvider,
                message: message
            )
        )
    }

    static func unsubscribe(
        account: AccountModel,
        appSessionStore: AppSessionStore,
        dataStoreProvider: DataStoreProvider,
        message: Binding<SubscriptionAppActionHandler.Message>
    ) -> ButtonView {
        ButtonView(
            text: "unsubscribe",
            baseStyle: .init(appFont: .light),
            route: .action(.unsubscribe),
            actionHandler: SubscriptionAppActionHandler(
                account: account,
                appSessionStore: appSessionStore,
                dataStoreProvider: dataStoreProvider,
                message: message
            )
        )
    }
}
