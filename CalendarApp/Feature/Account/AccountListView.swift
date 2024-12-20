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

	@Environment(\.hasSyncedContacts) var hasSyncedContacts
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
				if !hasSyncedContacts {
					try builder
						.primaryText("sync your contacts to see who has upcoming events\n")
						.bracket("sync contacts", deeplink: .action(.sync), color: .appTint)
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

#Preview {
	AccountListView(model: AccountListView.Model(
		variant: .guestList,
		accounts: [
			try! .account(
				viewer: AccountModelMocks.lloydAccount,
				account: AccountModelMocks.alanAccount
			),
			try! .account(
				viewer: AccountModelMocks.lloydAccount,
				account: AccountModelMocks.serenaAccount
			),
			try! .account(
				viewer: AccountModelMocks.lloydAccount,
				account: AccountModelMocks.ivoAccount
			)
		])
	)
	AccountListView(model: AccountListView.Model(
		variant: .subscriptions,
		accounts: []
	))
	.environment(\.hasSyncedContacts, true)
	AccountListView(model: AccountListView.Model(
		variant: .subscriptions,
		accounts: []
	))
	.environment(\.hasSyncedContacts, false)
}
