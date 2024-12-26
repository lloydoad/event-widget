//
//  PhoneNumberFieldView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/26/24.
//

import SwiftUI

struct PhoneNumberFieldView: View {
    var formatter: PhoneNumberFormatter
    @Binding var text: String
    
    var body: some View {
        TextField("enter phone number", text: $text)
            .keyboardType(.phonePad)
            .font(AppFont.large.asFont)
            .onChange(of: text, { _, newValue in
                let formatted = formatter.format(newValue)
                if formatted != newValue {
                    text = formatted
                }
            })
    }
}
