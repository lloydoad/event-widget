//
//  EventView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/24/24.
//

import SwiftUI

struct EventView: View {
    struct Model: Hashable, Codable {
        var content: AttributedString
        var controls: AttributedString
    }

    @EnvironmentObject var actionCoordinator: AppActionCoordinator
    @EnvironmentObject var appSessionStore: AppSessionStore
    @EnvironmentObject var dataStoreProvider: DataStoreProvider

    let event: EventModel
    @Binding var listMessage: EventActionHandler.ListMessage
    @State private var itemMessage: EventActionHandler.ItemMessage = .showControl

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(eventContent)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                switch itemMessage {
                case .showControl:
                    if let viewingAccount = appSessionStore.userAccount {
                        if event.joinable(viewer: viewingAccount) {
                            ButtonView(title: "join", font: .light) {
                                Task {
                                    try await actionHandler.handle(.join(event: event))
                                }
                            }
                        }
                        if event.cancellable(viewer: viewingAccount) {
                            ButtonView(title: "can't go", font: .light) {
                                Task {
                                    try await actionHandler.handle(.cantGo(event: event))
                                }
                            }
                        }
                        if event.deletable(viewer: viewingAccount) {
                            ButtonView(title: "delete", font: .light) {
                                Task {
                                    try await actionHandler.handle(.delete(event: event))
                                }
                            }
                        }
                    }
                case .loading:
                    ProgressView()
                }
                Spacer()
            }
        }
    }

    private var eventContent: AttributedString {
        guard let viewingAccount = appSessionStore.userAccount else { return "" }
        do {
            if event.isActive() {
                return try ListItemView.Model.eventContent(viewer: viewingAccount, event: event)
            } else {
                return try ListItemView.Model.expiredEventContent(event: event)
            }
        } catch {
            return "event details unavailable"
        }
    }

    private var actionHandler: EventActionHandler {
        EventActionHandler(
            event: event,
            appSessionStore: appSessionStore,
            dataStoreProvider: dataStoreProvider,
            listMessage: $listMessage,
            itemMessage: $itemMessage
        )
    }
}
