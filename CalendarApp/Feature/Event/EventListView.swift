//
//  EventListView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

struct EventListView: View {
	struct Model: Codable, Hashable {
		var events: [ListItemView.Model]
		var subscription: AccountListView.Model
	}

	var model: Model

	var body: some View {
		VStack {
			ScrollView {
				VStack(spacing: 16) {
					ListTitleView(title: title)
					ForEach(model.events, id: \.hashValue) { event in
						ListItemView(model: event)
							.padding(.bottom, 16)
					}
				}
				.frame(maxWidth: .infinity)
			}
			VStack() {
				ForEach(buttons(), id: \.self) { button in
					Text(button.asAttributedString)
						.frame(maxWidth: .infinity, alignment: .trailing)
						.padding(4)
				}
			}
		}
		.padding(.horizontal, 16)
		.padding(.bottom, 16)
	}

	private func buttons() -> [ButtonModel] {
		[
			ButtonModel(
				title: "create new event",
				color: .secondary,
                route: .sheet(.composer)
			),
			ButtonModel(
				title: "subscribe to more friends",
				color: .secondary,
                route: .push(.subscriptions(model.subscription))
			),
		]
	}

	private var title: String {
		"untitled events widget"
	}
}

#Preview {
	EventListView(
		model: EventListView.Model(
			events: [
				try! .event(
					viewer: AccountModelMocks.catAccount,
                    following: [AccountModelMocks.alanUUID],
					event: EventModelMocks.event(creator: AccountModelMocks.lloydAccount)
				),
				try! .event(
					viewer: AccountModelMocks.ivoAccount,
                    following: [AccountModelMocks.alanUUID],
					event: EventModelMocks.event(creator: AccountModelMocks.lloydAccount)
				),
				try! .event(
					viewer: AccountModelMocks.lloydAccount,
                    following: [AccountModelMocks.alanUUID],
					event: EventModelMocks.event(creator: AccountModelMocks.lloydAccount)
				)
			],
			subscription: AccountListView.Model(
				variant: .subscriptions,
				accounts: []
			))
	)
}
