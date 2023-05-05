//
//  SectionTextFieldStyle.swift
//  NamMoneyManager
//
//  Created by Admin on 5/2/23.
//

import SwiftUI

struct SectionTextFieldStyle: TextFieldStyle {

    let leftTitleText: String
    let rightTitleText: String
    var showDollarSign: Bool = false

    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            Text(leftTitleText)
            Divider()
                .padding([.leading, .trailing])
            if showDollarSign { Text("$") }
            configuration
        }
    }
}
