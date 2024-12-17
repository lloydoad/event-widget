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
				VStack(spacing: 4) {
					Text(
						AttributedStringBuilder(baseStyle: .init(appFont: .large))
							.appendBracketButton("create new event",
												 destination: "www.apple.com",
												 color: .secondary).build()
					)
					.frame(maxWidth: .infinity, alignment: .trailing)
					Text(
						AttributedStringBuilder(baseStyle: .init(appFont: .large))
							.appendBracketButton("subscribe to more friends",
												 destination: "www.apple.com",
												 color: .secondary).build()
					)
					.frame(maxWidth: .infinity, alignment: .trailing)
				}
			}
			.padding(.horizontal, 16)
			.padding(.bottom, 16)
		}
    }
}

#Preview {
	ContentView(model: ContentView.Model(eventRows: [
		viewModel(guest: "cat"),
		viewModel(guest: "cat"),
		viewModel(guest: "cat"),
		viewModel(guest: "cat"),
		viewModel(guest: "cat")
	]))
}
