//
//  SubscriptionButtonView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/22/24.
//

import SwiftUI

struct SubscriptionButtonView: View {
    @EnvironmentObject var appSessionStore: AppSessionStore
    @EnvironmentObject var dataStoreProvider: DataStoreProvider
    @EnvironmentObject var actionCoordinator: AppActionCoordinator

    let account: AccountModel
    @Binding var message: SubscriptionAppActionHandler.Message

    var body: some View {
        switch message {
        case .loading:
            ProgressView()
                .transition(.blurReplace)
        case .subscribe:
            ButtonView(action: .subscribe, font: .light, actionCoordinator: actionCoordinator)
                .onAction(handler: subscriptionActionHandler)
                .transition(.blurReplace)
        case .unsubscribe:
            ButtonView(action: .unsubscribe, font: .light, actionCoordinator: actionCoordinator)
                .onAction(handler: subscriptionActionHandler)
                .transition(.blurReplace)
        }
    }

    private var subscriptionActionHandler: SubscriptionAppActionHandler {
        SubscriptionAppActionHandler(
            account: account,
            appSessionStore: appSessionStore,
            dataStoreProvider: dataStoreProvider,
            message: $message
        )
    }
}
