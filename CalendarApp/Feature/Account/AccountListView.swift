//
//  AccountListView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/18/24.
//

import SwiftUI

struct AccountListView: View {
	enum Variant: Hashable, Codable {
		case guestList
		case subscriptions
	}
	struct Model: Hashable, Codable {
		var variant: Variant
		var accounts: [ListItemView.Model]
	}

    @EnvironmentObject var appSessionStore: AppSessionStore
	var model: Model

    var body: some View {
		VStack {
			ScrollView {
				VStack(spacing: 16) {
					ListTitleView(title: title)
					ForEach(model.accounts, id: \.hashValue) { account in
						ListItemView(model: account)
							.padding(.bottom, 4)
					}
					if let footer {
						Text(footer)
							.frame(maxWidth: .infinity, alignment: .leading)
					}
				}
				.frame(maxWidth: .infinity)
			}
		}
		.padding(.horizontal, 16)
		.padding(.bottom, 16)
    }

	private var title: String {
		switch model.variant {
		case .guestList:
			"guest list"
		case .subscriptions:
			"subscriptions"
		}
	}

	private var footer: AttributedString? {
		switch model.variant {
		case .guestList:
			return nil
		case .subscriptions:
			do {
				let builder = AttributedStringBuilder(baseStyle: .init(appFont: .light))
                if !appSessionStore.hasSyncedContacts {
					try builder
						.primaryText("sync your contacts to see who has upcoming events\n")
                        .bracket("sync contacts",
                                 deeplink: .action(.syncContacts),
                                 color: .appTint)
				}
				if model.accounts.isEmpty {
					try builder
						.primaryText("\n\nlooks like your contacts aren't here yet\n")
						.bracket("send invites", deeplink: .action(.invite), color: .appTint)
				}
				return builder.build()
			} catch {
				return nil
			}
		}
	}
}

#Preview("many accounts") {
    AccountListView(model: AccountListView.Model(
        variant: .guestList,
        accounts: [
            try! .account(
                viewer: AccountModelMocks.lloydAccount,
                account: AccountModelMocks.alanAccount,
                following: [AccountModelMocks.alanUUID]
            ),
            try! .account(
                viewer: AccountModelMocks.lloydAccount,
                account: AccountModelMocks.serenaAccount,
                following: [AccountModelMocks.alanUUID]
            ),
            try! .account(
                viewer: AccountModelMocks.lloydAccount,
                account: AccountModelMocks.ivoAccount,
                following: [AccountModelMocks.alanUUID]
            )
        ])
    )
    .environmentObject(mockAppSessionStore())
}

#Preview("no accounts - contacts synced") {
	AccountListView(model: AccountListView.Model(
		variant: .subscriptions,
		accounts: []
	))
    .environmentObject(mockAppSessionStore())
}

#Preview("no accounts - contacts not synced") {
    AccountListView(model: AccountListView.Model(
        variant: .subscriptions,
        accounts: []
    ))
    .environmentObject(mockAppSessionStore(hasSyncedContacts: false))
}
