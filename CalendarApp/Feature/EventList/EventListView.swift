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

    var eventListFetcher: EventListFetching

    @State private var error: Error?
    @State private var model: Model = .loading
    @State private var eventActionMessage: EventActionHandler.ListMessage = .none

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
                        ForEach(events, id: \.uuid.uuidString) { event in
                            EventView(event: event, listMessage: $eventActionMessage)
                                .padding(.bottom, 16)
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
            Task {
                await reloadData()
            }
        }
        .onChange(of: eventActionMessage) { oldValue, newValue in
            if newValue == .refresh {
                Task {
                    await reloadData()
                    eventActionMessage = .none
                }
            }
        }
    }

    private func reloadData() async {
        Task {
            do {
                let events = try await eventListFetcher.fetchLatestData()
                model = .success(events: events)
            } catch {
                self.error = error
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
