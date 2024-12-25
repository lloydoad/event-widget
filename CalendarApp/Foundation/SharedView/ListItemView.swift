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
