//
//  ContentView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

struct ContentView: View {
	struct Model {
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

	init(model: Model) {
		self.model = model
		UINavigationBar.appearance().largeTitleTextAttributes = [
			.font : UIFont.systemFont(ofSize: 22, weight: .medium)
		]
	}

    var body: some View {
		NavigationStack {
			VStack {
				ScrollView {
					VStack(spacing: 16) {
						Text("unentitled events widget")
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
	ContentView(
		model: ContentView.Model(eventRows: [
			viewModel(guest: "cat"),
			viewModel(guest: "cat"),
			viewModel(guest: "cat"),
			viewModel(guest: "cat"),
			viewModel(guest: "cat")
		])
	)
}
