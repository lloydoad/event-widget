//
//  EventListView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

protocol EventListFetching {
    func fetchLatestData() async throws -> [EventModel]
}

struct EventListView: View {
    private enum Model: Equatable {
        case success(events: [EventModel])
        case loading
    }

    var identifier: String
    var eventListFetcher: EventListFetching

    @State private var error: Error?
    @State private var model: Model = .loading

    var body: some View {
        VStack {
            switch model {
            case .loading:
                VStack {
                    Spacer().frame(maxHeight: .infinity)
                    ProgressView()
                    Spacer().frame(maxHeight: .infinity)
                }
                .transition(.blurReplace)
            case .success(let events):
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(events, id: \.hashValue.description) { event in
                            EventView(
                                listIdentifier: identifier,
                                event: event,
                                removeEvent: { eventID in
                                    removeEvent(eventID: eventID)
                                })
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .transition(.blurReplace)
            }
        }
        .animation(.easeInOut, value: model)
        .errorAlert(error: $error)
        .onAppear {
            ActionCentralDispatch
                .shared
                .register(
                    identifier: ButtonIdentifier.refreshEventListAction
                ) {
                    reloadData()
                }
            reloadData()
        }
        .onDisappear {
            ActionCentralDispatch.shared.deregister(identifier: ButtonIdentifier.refreshEventListAction)
        }
        .refreshable {
            reloadData()
        }
    }

    private func removeEvent(eventID: UUID) {
        guard case var .success(events: events) = model else { return }
        events.removeAll(where: { $0.uuid == eventID })
        model = .success(events: events)
    }

    @State private var currentTask: Task<Void, Never>?
    func reloadData() {
        currentTask?.cancel()
        currentTask = Task {
            do {
                let events = try await eventListFetcher.fetchLatestData()
                await MainActor.run {
                    model = .success(events: events)
                }
            } catch {
                await MainActor.run {
                    self.error = error
                }
            }
        }
    }
}

#Preview {
    HomeFeedView()
        .environmentObject(mockAppSessionStore(account: AccountModelMocks.catAccount))
        .environmentObject(DataStoreProvider(dataStore: MockDataStore()))
    HomeFeedView()
        .environmentObject(mockAppSessionStore(account: AccountModelMocks.lloydAccount))
        .environmentObject(DataStoreProvider(dataStore: MockDataStore()))
}
