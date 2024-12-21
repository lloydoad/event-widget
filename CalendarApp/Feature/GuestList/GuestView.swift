//
//  GuestView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/21/24.
//

import SwiftUI

struct GuestView: View {
    @ObservedObject var viewModel: GuestViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(viewModel.content)
                .frame(maxWidth: .infinity, alignment: .leading)
            switch viewModel.actions {
            case .loading:
                ProgressView()
            case .success(let content):
                if !content.characters.isEmpty {
                    Text(content)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(.bottom, 4)
    }
}
