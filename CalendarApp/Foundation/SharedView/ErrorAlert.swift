//
//  ErrorAlert.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/20/24.
//

import SwiftUI
import os

fileprivate let SystemLogger = Logger(subsystem: "App", category: "ErrorAlert")

struct ErrorAlert: ViewModifier {
    @Binding var error: Error?
    
    func body(content: Content) -> some View {
        content.alert(
            "Something went wrong",
            isPresented: .constant(error != nil),
            presenting: error,
            actions: { _ in
                Button("OK") {
                    error = nil
                }
                .font(AppFont.light.asFont)
            },
            message: { error in
                Text(error.localizedDescription)
                    .font(AppFont.light.asFont)
                    .onAppear {
                        logError(error)
                    }
            }
        )
    }

    private func logError(_ error: Error) {
        let nsError = error as NSError
        guard
            let failureReason = nsError.userInfo[NSLocalizedFailureReasonErrorKey] as? String
        else { return }
        SystemLogger.error("\(failureReason)")
    }
}

extension View {
    func errorAlert(error: Binding<Error?>) -> some View {
        modifier(ErrorAlert(error: error))
    }
}
