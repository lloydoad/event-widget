//
//  FeedRowView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

struct ListItemView: View {
	struct Model: Hashable, Codable {
		var content: AttributedString
		var controls: AttributedString
	}

	var model: Model

	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			Text(model.content)
				.frame(maxWidth: .infinity, alignment: .leading)
			if !model.controls.characters.isEmpty {
				Text(model.controls)
					.frame(maxWidth: .infinity, alignment: .leading)
			}
		}
	}
}

#Preview {
	ScrollView {
		Text("View: Cat")
		ListItemView(model: try! .event(
            viewer: AccountModelMocks.catAccount,
			event: EventModelMocks.event(creator: AccountModelMocks.lloydAccount)
		))
		Text("View: Ivo")
		ListItemView(model: try! .event(
			viewer: AccountModelMocks.ivoAccount,
			event: EventModelMocks.event(creator: AccountModelMocks.lloydAccount)
		))
		Text("View: Lloyd")
		ListItemView(model: try! .event(
			viewer: AccountModelMocks.lloydAccount,
			event: EventModelMocks.event(creator: AccountModelMocks.lloydAccount)
		))
		Text("View: Cat")
		ListItemView(model: try! .event(
			viewer: AccountModelMocks.catAccount,
			event: EventModelMocks.event(creator: AccountModelMocks.lloydAccount, guests: [])
		))
		Text("View: Ivo")
		ListItemView(model: try! .event(
			viewer: AccountModelMocks.ivoAccount,
			event: EventModelMocks.event(creator: AccountModelMocks.lloydAccount, guests: [])
		))
		Text("View: Lloyd")
		ListItemView(model: try! .event(
			viewer: AccountModelMocks.lloydAccount,
			event: EventModelMocks.event(creator: AccountModelMocks.lloydAccount, guests: [])
		))
	}
}
