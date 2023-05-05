//
//  PickerIcon.swift
//  NamMoneyManager
//
//  Created by Admin on 5/3/23.
//

import SwiftUI

struct PickerView: View {
    var pickerIcons: [PickerIcon]

    var body: some View {
        ScrollView(.horizontal) {
            HStack() {
                ForEach(0..<pickerIcons.count, id: \.self) { index in
                    pickerIcons[index]
                }
            }
            .padding([.top, .leading, .bottom, .trailing], 5.0)
        }
    }
}

struct PickerIcon: View {
    var text: String
    var iconIndex: Int
    @Binding var selectedCategoryIndex: Int?
    @State private var isSelected: Bool = false

    var body: some View {
        Text(text)
            .bold()
            .padding([.top, .leading, .trailing, .bottom], 5)
            .overlay(
                RoundedRectangle(cornerRadius: 16.0)
                    .stroke(.black, lineWidth: 0.0)
            )
            .onTapGesture {
                if selectedCategoryIndex == iconIndex {
                    selectedCategoryIndex = nil
                } else {
                    selectedCategoryIndex = iconIndex
                }
            }
            .background(setBackgroundBasedOnSelected())
    }

    private func setBackgroundBasedOnSelected() -> some View {
        if let selectedCategoryIndex = selectedCategoryIndex,
           selectedCategoryIndex == iconIndex {
            return RoundedRectangle(cornerRadius: 16.0, style: .continuous).fill(Color.blue)
        } else {
            return RoundedRectangle(cornerRadius: 16.0, style: .continuous).fill(Color.white)
        }
    }
}

//struct PickerIcon_Previews: PreviewProvider {
//    static var previews: some View {
//        PickerIcon(text: "Gas") {
//            print("Test")
//        }
//    }
//}
