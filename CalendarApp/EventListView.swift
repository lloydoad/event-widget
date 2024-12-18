//
//  EventListView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

import SwiftUI

//enum PageModel {
//	case eventList()
//}

struct EventListView: View {
	struct Model: Hashable {
		var eventRows: [EventRowView.Model]
		var bottomButtons: [ButtonModel] = [
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
	}

	var model: Model

	var body: some View {
		NavigationStack {
			VStack {
				ScrollView {
					VStack(spacing: 16) {
						Text("untitled events widget")
							.font(.system(size: 24, weight: .medium, design: .serif))
							.frame(maxWidth: .infinity, alignment: .leading)
						ForEach(model.eventRows, id: \.hashValue) { model in
							EventRowView(model: model)
								.padding(.bottom, 16)
						}
					}
					.frame(maxWidth: .infinity)
				}
				EventListButtonGroup(models: model.bottomButtons)
			}
			.padding(.horizontal, 16)
			.padding(.bottom, 16)
		}
	}
}

#Preview {
	EventListView(
		model: EventListView.Model(eventRows: [
			viewModel(guest: "cat"),
			viewModel(guest: "cat"),
			viewModel(guest: "cat"),
			viewModel(guest: "cat"),
			viewModel(guest: "cat")
		])
	)
}
