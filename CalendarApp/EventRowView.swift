//
//  FeedRowView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

struct EventRowView: View {
	struct Model: Hashable {
		var primaryContent: AttributedString
		var controlContent: AttributedString
	}

	var model: Model

	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			Text(model.primaryContent)
				.frame(maxWidth: .infinity, alignment: .leading)
			Text(model.controlContent)
				.frame(maxWidth: .infinity, alignment: .leading)
			Color(cgColor: UIColor.tertiaryLabel.cgColor)
				.frame(width: 100, height: 1)
		}
	}
}

func viewModel(guest: String, guests: [String] = ["nick", "alan", "serena", "cat"]) -> EventRowView.Model {
	let mockModel = EventModel(
		creator: "lloyd",
		description: "building lego till 8 or later. I'm not sure",
		startDate: .now,
		endDate: .now,
		location: "235 Valencia St",
		guests: guests)
	return .init(
		primaryContent: mockModel.buildAttributedContent(for: guest),
		controlContent: mockModel.buildAttributedControlContent(for: guest)
	)
}

#Preview {
	ScrollView {
		Text("View: Cat")
		EventRowView(model: viewModel(guest: "cat"))
		Text("View: Ivo")
		EventRowView(model: viewModel(guest: "ivo"))
		Text("View: Lloyd")
		EventRowView(model: viewModel(guest: "lloyd"))
		Text("View: Cat")
		EventRowView(model: viewModel(guest: "cat", guests: []))
		Text("View: Ivo")
		EventRowView(model: viewModel(guest: "ivo", guests: []))
		Text("View: Lloyd")
		EventRowView(model: viewModel(guest: "lloyd", guests: []))
	}
}
