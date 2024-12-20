//
//  AccountView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/18/24.
//

import SwiftUI

struct AccountView: View {
	struct Model: Codable, Hashable {
		var account: AccountModel
	}

	var model: Model
	@State private var events: [ListItemView.Model] = []

	var body: some View {
		VStack {
			ScrollView {
				VStack(spacing: 16) {
					ListTitleView(title: title)
					ForEach(events, id: \.hashValue) { event in
						ListItemView(model: event)
							.padding(.bottom, 16)
					}
				}
				.frame(maxWidth: .infinity)
			}
		}
		.padding(.horizontal, 16)
		.padding(.bottom, 16)
	}

	private var title: String {
		"events by \(model.account.username)"
	}
}
