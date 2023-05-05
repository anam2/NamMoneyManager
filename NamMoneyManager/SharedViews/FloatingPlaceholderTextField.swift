//
//  File.swift
//  NamMoneyManager
//
//  Created by Admin on 5/1/23.
//
import SwiftUI

struct FloatingPlaceholderTextField: View {
    @Binding var text: String
    var placeholder: String

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 15)
            }
            TextField("", text: $text)
                .padding(15)
        }
        .background(Color.white)
        .cornerRadius(5)
        .shadow(radius: 5)
    }
}
