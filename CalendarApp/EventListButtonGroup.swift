//
//  EventListButtonGroup.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

struct EventListButtonGroup: View {
	var models: [ButtonModel]

	var body: some View {
		VStack() {
			ForEach(models, id: \.self) { model in
				Text(
					AttributedStringBuilder(baseStyle: .init(appFont: .large))
						.appendBracketButton(
							model.title,
							destination: model.destination,
							color: model.color
						).build()
				)
				.frame(maxWidth: .infinity, alignment: .trailing)
				.padding(4)
			}
		}
	}
}
