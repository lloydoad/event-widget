//
//  FeedRowView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

struct EventListItemView: View {
	struct Model: Hashable, Codable {
		var content: AttributedString
		var controls: AttributedString
	}

	var model: Model

	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			Text(model.content)
				.frame(maxWidth: .infinity, alignment: .leading)
			Text(model.controls)
				.frame(maxWidth: .infinity, alignment: .leading)
			Color(cgColor: UIColor.tertiaryLabel.cgColor)
				.frame(width: 100, height: 1)
		}
	}
}

#Preview {
	ScrollView {
		Text("View: Cat")
		EventListItemView(model: try! EventListItemView.Model(
			viewer: AccountModelMocks.catAccount,
			event: EventModelMocks.event(creator: AccountModelMocks.lloydAccount)
		))
		Text("View: Ivo")
		EventListItemView(model: try! EventListItemView.Model(
			viewer: AccountModelMocks.ivoAccount,
			event: EventModelMocks.event(creator: AccountModelMocks.lloydAccount)
		))
		Text("View: Lloyd")
		EventListItemView(model: try! EventListItemView.Model(
			viewer: AccountModelMocks.lloydAccount,
			event: EventModelMocks.event(creator: AccountModelMocks.lloydAccount)
		))
		Text("View: Cat")
		EventListItemView(model: try! EventListItemView.Model(
			viewer: AccountModelMocks.catAccount,
			event: EventModelMocks.event(creator: AccountModelMocks.lloydAccount, guests: [])
		))
		Text("View: Ivo")
		EventListItemView(model: try! EventListItemView.Model(
			viewer: AccountModelMocks.ivoAccount,
			event: EventModelMocks.event(creator: AccountModelMocks.lloydAccount, guests: [])
		))
		Text("View: Lloyd")
		EventListItemView(model: try! EventListItemView.Model(
			viewer: AccountModelMocks.lloydAccount,
			event: EventModelMocks.event(creator: AccountModelMocks.lloydAccount, guests: [])
		))
	}
}
