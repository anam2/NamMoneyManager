//
//  ExpenseDetailView.swift
//  NamMoneyManager
//
//  Created by Admin on 5/4/23.
//

import SwiftUI

struct ExpenseDetailView: View {

    let selectedExpense: ExpensePayment
    @Binding var reloadExpenseView: Bool

    @State var showEditView: Bool = false

    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode

    // MARK: MAIN BODY

    var backgroundColor: CGColor = UIColor.systemGroupedBackground.cgColor

    var body: some View {
        ZStack {
            Color(backgroundColor)
                .ignoresSafeArea()
            VStack {
                VStack {
                    VStack {
                        Text(selectedExpense.title ?? "")
                            .font(.system(size: 25.0))
                            .bold()
                        Text(selectedExpense.category?.name ?? "")
                    }

                    VStack {
                        HStack {
                            VStack {
                                Text(getDate(date: selectedExpense.inputDate) ?? "")
                            }
                            Spacer()
                            VStack {
                                Text(selectedExpense.amount ?? "")
                                Text("")
                                    .bold()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()

                    Button {
                        print("Delete Button clicked.")
                        DataController().deleteExpense(id: selectedExpense.id,
                                                       context: managedObjectContext)
                        reloadExpenseView = true
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Text("Delete Expense")
                                .bold()
                        }
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.red, lineWidth: 2))
                        .foregroundColor(Color.red)
                    }
                }
                .padding()
                .background(Color.white)
                Spacer()
            }
            .padding([.top, .leading, .trailing, .bottom])
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            backToolbarItem
            editToolbarItem
        }
    }

    // MARK: TOOLBAR ITEMS

    var editToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                self.showEditView = true
            } label: {
                Text("Edit")
            }
        }
    }

    var backToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                HStack {
                    Image(systemName: "chevron.backward")
                    Text("Back")
                }
            }
        }
    }

    private func getDate(date: Date?) -> String? {
        guard let date = date else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        print("Current date: \(formatter.string(from: Date.now))")
        return formatter.string(from: date)
    }

}
