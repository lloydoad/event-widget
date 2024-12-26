//
//  GuestView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/21/24.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var dataStoreProvider: DataStoreProvider
    @EnvironmentObject var appSessionStore: AppSessionStore

    var account: AccountModel

    @StateObject private var viewModel: AccountViewModel = .init()

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(viewModel.content)
                .frame(maxWidth: .infinity, alignment: .leading)
                .transition(.blurReplace)
            HStack {
                switch viewModel.controls {
                case .enable(let controlTypes):
                    ForEach(controlTypes) { controlType in
                        switch controlType {
                        case .profile(let identifier):
                            ButtonView(title: "profile", identifier: identifier.uuidString, font: .light, action: {
                                let route = DeepLinkParser.Route.push(.profile(account))
                                let url = try! route.url()
                                UIApplication.shared.open(url)
                            })
                            .transition(.blurReplace)
                        case .subscription:
                            SubscriptionButtonView(
                                account: account,
                                buttonType: $viewModel.subscriptionButtonType
                            )
                        }
                    }
                case .disabled:
                    ProgressView()
                        .transition(.blurReplace)
                }
                Spacer()
            }
        }
        .animation(.easeInOut, value: viewModel.content)
        .animation(.easeInOut, value: viewModel.controls)
        .padding(.bottom, 4)
        .onAppear {
            viewModel.configure(
                dataStore: dataStoreProvider.dataStore,
                appSessionStore: appSessionStore,
                account: account
            )
        }
    }
}
