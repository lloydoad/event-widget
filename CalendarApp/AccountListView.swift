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
		var accounts: [AccountListItemView.Model]
	}

	@Environment(\.hasSyncedContacts) var hasSyncedContacts
	var model: Model

    var body: some View {
		VStack {
			ScrollView {
				VStack(spacing: 16) {
					Text(title)
						.frame(maxWidth: .infinity, alignment: .leading)
					ForEach(model.accounts, id: \.hashValue) { account in
						AccountListItemView(model: account)
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

	private var title: AttributedString {
		switch model.variant {
		case .guestList:
			AttributedStringBuilder(baseStyle: .init(appFont: .navigationTitle))
				.appendPrimaryText("guest list")
				.build()
		case .subscriptions:
			AttributedStringBuilder(baseStyle: .init(appFont: .navigationTitle))
				.appendPrimaryText("subscriptions")
				.build()
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
						.appendPrimaryText("sync your contacts to see who has upcoming events\n")
						.bracket("sync contacts", deeplink: .action(.sync), color: .accent)
				}
				if model.accounts.isEmpty {
					try builder
						.appendPrimaryText("\n\nlooks like your contacts aren't here yet\n")
						.bracket("send invites", deeplink: .action(.invite), color: .accent)
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
			try! AccountListItemView.Model(
				viewer: AccountModelMocks.lloydAccount,
				account: AccountModelMocks.alanAccount
			),
			try! AccountListItemView.Model(
				viewer: AccountModelMocks.lloydAccount,
				account: AccountModelMocks.serenaAccount
			),
			try! AccountListItemView.Model(
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
