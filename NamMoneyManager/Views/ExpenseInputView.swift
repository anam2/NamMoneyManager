//
//  ExpenseInputView.swift
//  NamMoneyManager
//
//  Created by Admin on 5/1/23.
//

import SwiftUI
import CoreData

struct ExpenseInputViewDataModel {
    var expenseTitle: String = ""
    var amountSpent: String = ""
    var description: String = ""
    var displayCategory: String = ""
    var inputDate: Date = Date.now
}

struct ExpenseInputView: View {
    @Binding var showExpenseSheet: Bool
    @Binding var reloadExpenseView: Bool

    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss

//    @State var viewDataModel = ExpenseInputViewDataModel()

    @State var expenseTitle: String = ""
    @State var amountSpent: String = ""
    @State var description: String = ""
    @State var displayCategory: String = ""
    @State var inputDate: Date = Date.now

    var categories: [String] = ["Gas", "Rent", "Groceries"]

    // MARK: ERROR HANDLING

    @FocusState var amountIsFocused: Bool

    init(showExpenseSheet: Binding<Bool> = .constant(false),
         reloadExpenseView: Binding<Bool> = .constant(false),
         expenseTitle: String = "",
         amountSpent: String = "",
         description: String = "",
         displayCategory: String = "",
         inputDate: Date = Date.now) {
        _showExpenseSheet = showExpenseSheet
        _reloadExpenseView = reloadExpenseView
        self.expenseTitle = expenseTitle
        self.amountSpent = amountSpent
        self.description = description
        self.displayCategory = displayCategory
        self.inputDate = inputDate
        navbarSetup()
    }

    private func navbarSetup() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().standardAppearance = navBarAppearance
    }

    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter
    }()

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("", text: $expenseTitle)
                        .textFieldStyle(SectionTextFieldStyle(leftTitleText: "Title",
                                                              rightTitleText: expenseTitle))
                        .onAppear {
                            self.expenseTitle = "Test"
                        }

                    TextField("", text: $amountSpent)
                        .textFieldStyle(SectionTextFieldStyle(leftTitleText: "Amount",
                                                              rightTitleText: "$\(amountSpent)",
                                                              showDollarSign: true))
                        .keyboardType(.decimalPad)
                        .autocorrectionDisabled(true)
                        .focused($amountIsFocused)
                        .onChange(of: amountSpent) { _ in
                            let amountSpent = String(amountSpent)
                            let components = amountSpent.components(separatedBy: ".")
                            if components.count == 2, components[1].count >= 2 {
                                amountIsFocused = false
                                let amountSpentDouble = Double(amountSpent)
                                self.amountSpent = String(format: "%.2f", amountSpentDouble ?? 0.00)
                            }
                        }
                        .onChange(of: amountIsFocused) { isFocused in
                            if !isFocused {
                                amountSpent = convertStringToMoney(inputString: amountSpent) ?? ""
                            }
                        }

                    NavigationLink {
                        CategoryListView(displayCategory: $displayCategory)
                    } label: {
                        HStack {
                            Text("Category")
                            Spacer()
                            Text(displayCategory)
                        }
                    }

                    DatePicker(selection: $inputDate, in: ...Date.now, displayedComponents: .date) {
                        Text("Select a Date")
                    }

                    TextField("Description (Optional)", text: $description)
                }

                Section {
                    HStack {
                        Spacer()
                        Button("Add") {
                            NSLog("Add button clicked.")
                            DataController().addExpense(title: expenseTitle,
                                                        amount: amountSpent,
                                                        description: description,
                                                        category: displayCategory,
                                                        inputDate: inputDate,
                                                        context: managedObjectContext)
                            reloadExpenseView = true
                            showExpenseSheet = false
                        }
                        Spacer()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        showExpenseSheet.toggle()
                    }
                }
            }
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func convertStringToMoney(inputString: String) -> String? {
        guard let inputStringDouble = Double(inputString) else { return nil }
        return String(format: "%.2f", inputStringDouble)
    }

}
