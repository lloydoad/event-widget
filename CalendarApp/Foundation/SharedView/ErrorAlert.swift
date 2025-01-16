//
//  ErrorAlert.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/20/24.
//

import SwiftUI
import os

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
                Text(getAppMessage(error))
                    .font(AppFont.light.asFont)
                    .onAppear {
                        logError(error)
                    }
            }
        )
    }

    private func getAppMessage(_ error: Error) -> String {
        let nsError = error as NSError
        if let appMessage = nsError.userInfo[ErrorManager.appMessageKey] as? String {
            return appMessage
        } else {
            return "Please try again later"
        }
    }

    private func logError(_ error: Error) {
        let nsError = error as NSError
        if let failureReason = nsError.userInfo[ErrorManager.loggedMessageKey] as? String {
            ErrorAlertLogger.error("\(failureReason)")
        } else {
            ErrorAlertLogger.error("\(error.localizedDescription)")
        }

    }
}

extension View {
    func errorAlert(error: Binding<Error?>) -> some View {
        modifier(ErrorAlert(error: error))
    }
}
