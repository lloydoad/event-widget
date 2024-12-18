//
//  FeedRowView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

struct EventRowView: View {
	struct Model: Hashable, Codable {
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

let nickAccount = AccountModel(uuid: .init(), username: "nick", phoneNumber: "301-367-6761")
let alanAccount = AccountModel(uuid: .init(), username: "alan", phoneNumber: "301-367-6761")
let serenaAccount = AccountModel(uuid: .init(), username: "serena", phoneNumber: "301-367-6761")
let catAccount = AccountModel(uuid: .init(), username: "cat", phoneNumber: "301-367-6761")
let lloydAccount = AccountModel(uuid: .init(), username: "lloyd", phoneNumber: "301-367-6761")
let ivoAccount = AccountModel(uuid: .init(), username: "ivo", phoneNumber: "301-367-6761")
let guests = [nickAccount, alanAccount, serenaAccount, catAccount]

func viewModel(guest: AccountModel, guests: [AccountModel] = guests) -> EventRowView.Model {
	let mockModel = EventModel(
		creator: lloydAccount,
		description: "building lego till 8 or later. I'm not sure",
		startDate: .now,
		endDate: .now,
		location: "235 Valencia St",
		guests: guests)
	return .init(
		primaryContent: try! mockModel.buildAttributedContent(for: guest),
		controlContent: mockModel.buildAttributedControlContent(for: guest)
	)
}

#Preview {
	ScrollView {
		Text("View: Cat")
		EventRowView(model: viewModel(guest: catAccount))
		Text("View: Ivo")
		EventRowView(model: viewModel(guest: ivoAccount))
		Text("View: Lloyd")
		EventRowView(model: viewModel(guest: lloydAccount))
		Text("View: Cat")
		EventRowView(model: viewModel(guest: catAccount, guests: []))
		Text("View: Ivo")
		EventRowView(model: viewModel(guest: ivoAccount, guests: []))
		Text("View: Lloyd")
		EventRowView(model: viewModel(guest: lloydAccount, guests: []))
	}
}
