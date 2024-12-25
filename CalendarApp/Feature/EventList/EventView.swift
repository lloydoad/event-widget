//
//  EventView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/24/24.
//

import SwiftUI

struct EventView: View {
    @EnvironmentObject var dataStoreProvider: DataStoreProvider
    @EnvironmentObject var appSessionStore: AppSessionStore

    var event: EventModel
    var removeEvent: (UUID) -> Void

    @StateObject private var viewModel: EventViewModel = .init()

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(viewModel.content)
                .frame(maxWidth: .infinity, alignment: .leading)
                .transition(.blurReplace)
            HStack {
                switch viewModel.controls {
                case .enable(let array):
                    ForEach(array, id: \.title) { control in
                        ButtonView(title: control.title, font: .light) {
                            viewModel.perform(control: control)
                        }
                        .transition(.blurReplace)
                    }
                case .disabled:
                    ProgressView()
                        .transition(.blurReplace)
                }
                Spacer()
            }
        }
        .animation(.easeInOut, value: viewModel.content)
        .animation(.easeInOut, value: viewModel.controls)
        .onAppear {
            viewModel.configure(
                dataStore: dataStoreProvider.dataStore,
                appSessionStore: appSessionStore,
                event: event,
                removeEvent: removeEvent
            )
        }
    }
}
