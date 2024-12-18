//
//  EventListView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

struct EventListView: View {

	struct Model: Codable, Hashable {
		var events: [EventListItemView.Model]
	 }

	var model: Model
	private let buttons = [
		ButtonModel(
		   title: "create new event",
		   destination: "http://maps.apple.com/?ll=50.894967,4.341626",
		   color: .secondary
		),
		ButtonModel(
		   title: "subscribe to more friends",
		   destination: "http://maps.apple.com/?ll=50.894967,4.341626",
		   color: .secondary
		),
	]

	var body: some View {
		VStack {
			ScrollView {
				VStack(spacing: 16) {
					Text("untitled events widget")
						.font(.system(size: 24, weight: .medium, design: .serif))
						.frame(maxWidth: .infinity, alignment: .leading)
					ForEach(model.events, id: \.hashValue) { event in
						EventListItemView(model: event)
							.padding(.bottom, 16)
					}
				}
				.frame(maxWidth: .infinity)
			}
			VStack() {
				ForEach(buttons, id: \.self) { button in
					Text(
						AttributedStringBuilder(baseStyle: .init(appFont: .large))
							.appendBracketButton(
								button.title,
								destination: button.destination,
								color: button.color
							).build()
					)
					.frame(maxWidth: .infinity, alignment: .trailing)
					.padding(4)
				}
			}
		}
		.padding(.horizontal, 16)
		.padding(.bottom, 16)
	}
}

#Preview {
	EventListView(
		model: EventListView.Model(events: [
			try! EventListItemView.Model(
				guest: AccountModelMocks.catAccount,
				event: EventModelMocks.event(creator: AccountModelMocks.lloydAccount)
			),
			try! EventListItemView.Model(
				guest: AccountModelMocks.ivoAccount,
				event: EventModelMocks.event(creator: AccountModelMocks.lloydAccount)
			),
			try! EventListItemView.Model(
				guest: AccountModelMocks.lloydAccount,
				event: EventModelMocks.event(creator: AccountModelMocks.lloydAccount)
			)
		])
	)
}
