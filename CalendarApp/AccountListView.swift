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
			),
			try! AccountListItemView.Model(
				viewer: AccountModelMocks.lloydAccount,
				account: AccountModelMocks.nickAccount
			),
			try! AccountListItemView.Model(
				viewer: AccountModelMocks.lloydAccount,
				account: AccountModelMocks.catAccount
			)
		])
	)
}
