//
//  AccountListView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/18/24.
//

import SwiftUI

struct AccountListView: View {
	struct Model: Hashable, Codable {
		var title: String
		var accounts: [AccountListItemView.Model]
		var footer: AttributedString?
	}

	var model: Model

    var body: some View {
		VStack {
			ScrollView {
				VStack(spacing: 16) {
					Text(model.title)
						.font(.system(size: 24, weight: .medium, design: .serif))
						.frame(maxWidth: .infinity, alignment: .leading)
					ForEach(model.accounts, id: \.hashValue) { account in
						AccountListItemView(model: account)
							.padding(.bottom, 4)
					}
					if let footer = model.footer {
						Text(footer)
							.font(.system(size: 20, weight: .ultraLight, design: .serif))
							.frame(maxWidth: .infinity, alignment: .leading)
					}
				}
				.frame(maxWidth: .infinity)
			}
		}
		.padding(.horizontal, 16)
		.padding(.bottom, 16)
    }
}

#Preview {
	AccountListView(model: AccountListView.Model(
		title: "Guest list",
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
		title: "Subscriptions",
		accounts: [],
		footer: "Sync your contacts to see who has events!\n[Sync contacts]"
	))
	AccountListView(model: AccountListView.Model(
		title: "Subscriptions",
		accounts: [],
		footer: "No contacts have joined yet!\n[Send some invites]"
	))
}
