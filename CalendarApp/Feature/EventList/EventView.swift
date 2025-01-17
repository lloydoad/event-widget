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

    var listIdentifier: String
    var event: EventModel
    var removeEvent: (UUID) -> Void

    @StateObject private var viewModel: EventViewModel = .init()

    var body: some View {
        Text(viewModel.content)
            .frame(maxWidth: .infinity, alignment: .leading)
            .transition(.blurReplace)
        .animation(.easeInOut, value: viewModel.content)
        .onAppear {
            registerActions()
            viewModel.configure(
                dataStore: dataStoreProvider.dataStore,
                appSessionStore: appSessionStore,
                event: event,
                listIdentifier: listIdentifier,
                removeEvent: removeEvent
            )
        }
        .onDisappear {
            unregisterActions()
        }
    }

    private func registerActions() {
        for control in EventControl.allCases {
            ActionCentralDispatch.shared
                .register(identifier: control.identifier(event: event, listIdentifier: listIdentifier), action: {
                viewModel.perform(control: control)
            })
        }
    }

    private func unregisterActions() {
        for control in EventControl.allCases {
            ActionCentralDispatch.shared
                .deregister(identifier: control.identifier(event: event, listIdentifier: listIdentifier))
        }
    }
}
