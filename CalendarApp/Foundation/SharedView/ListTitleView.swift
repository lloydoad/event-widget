//
//  ListTitleView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/18/24.
//

import SwiftUI

struct ListTitleView: View {
	var title: String

	var body: some View {
		Text(
			StringBuilder(baseStyle: .init(appFont: .navigationTitle))
                .text(.primary(title))
				.build()
		)
		.frame(maxWidth: .infinity, alignment: .leading)
	}
}
