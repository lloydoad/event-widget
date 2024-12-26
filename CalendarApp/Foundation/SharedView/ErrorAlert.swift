//
//  ErrorAlert.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/20/24.
//

import SwiftUI

struct ErrorManager {
    static func with(message: String) -> Error {
        NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
    }
}

struct ErrorAlert: ViewModifier {
    @Binding var error: Error?
    
    func body(content: Content) -> some View {
        content.alert(
            "Something went wrong",
            isPresented: .constant(error != nil),
            presenting: error,
            actions: { _ in Button("OK") { error = nil } },
            message: { error in Text(error.localizedDescription) }
        )
    }
}

extension View {
    func errorAlert(error: Binding<Error?>) -> some View {
        modifier(ErrorAlert(error: error))
    }
}
