//
//  ExpenseDetailView.swift
//  NamMoneyManager
//
//  Created by Admin on 5/4/23.
//

import SwiftUI

struct ExpenseDetailView: View {
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            VStack {
                VStack {
                    Text("Grocery")
                        .font(.system(size: 25.0))
                        .bold()
                    Text("Target")
                }

                VStack {
                    HStack {
                        VStack {
                            Text("2/29/23")
                        }
                        Spacer()
                        VStack {
                            Text("$43.69")
                                .bold()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()

                Button {
                    print("Button clicked.")
                } label: {
                    HStack {
                        Text("Delete Expense")
                            .bold()
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.red, lineWidth: 2))
                    .foregroundColor(Color.red)
                }
                Spacer()
            }
            .padding([.top, .leading, .trailing, .bottom])
        }

    }
}

struct ExpenseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseDetailView()
    }
}
