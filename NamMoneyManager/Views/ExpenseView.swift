//
//  ExpenseView.swift
//  NamMoneyManager
//
//  Created by Admin on 5/1/23.
//

import SwiftUI
import Foundation

struct ExpenseView: View {

    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.inputDate, order: .reverse)]) var expenses: FetchedResults<ExpensePayment>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var categories: FetchedResults<PaymentCategory>

    @State private var showingInputView = false
    @State private var selectedCategoryIndex: Int?

    var body: some View {
        NavigationView {
            List {
                Section {
                    Text("Total Money: $\(totalMoney())")
                        .foregroundColor(.gray)
                }

                Section {
                    PickerView(pickerIcons: getPickerIconViews())
                }

                Section {
                    if let selectedCategoryIndex = selectedCategoryIndex {
                        createExpenseTableView(expenses: DataController().getSpecificExpense(by: categories[selectedCategoryIndex],
                                                                                             context: managedObjectContext) ?? [])
                    } else {
                        createExpenseTableView(expenses: DataController().getExpenses(context: managedObjectContext) ?? [])
                    }
                }
            }
            .navigationTitle("Nam Money Manager")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingInputView.toggle()
                    } label: {
                        Label("Add", systemImage: "plus.circle")
                    }
                }
            }
            .sheet(isPresented: $showingInputView) {
                ExpenseInputView(showExpenseSheet: $showingInputView)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func createExpenseTableView(expenses: [ExpensePayment]) -> some View {
        ForEach(expenses) { expense in
            NavigationLink(destination: ExpenseDetailView()) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(expense.title ?? "")
                            .bold()
                        Text(expense.category?.name ?? "")
                            .font(.system(size: 12.0))
                        Text(getDate(date: expense.inputDate) ?? "")
                            .font(.system(size: 12.0))
                    }
                    Spacer()
                    Text("$ \(expense.amount ?? "")")
                }
                .padding([.top, .bottom], 5.0)
            }
        }
    }

    private func getPickerIconViews() -> [PickerIcon] {
        var pickerIcons: [PickerIcon] = []
        for (index, category) in categories.enumerated() {
            let pickerIcon = PickerIcon(text: category.name ?? "",
                                        iconIndex: index,
                                        selectedCategoryIndex: $selectedCategoryIndex)
            pickerIcons.append(pickerIcon)
        }
        return pickerIcons
    }

    private func totalMoney() -> String {
        var totalAmount: Double = 0.0
        for expense in expenses {
            let doubleAmount = Double(expense.amount ?? "0.00")
            totalAmount += doubleAmount ?? 0.00
        }
        return String(format: "%.2f", totalAmount)
    }

    private func getDate(date: Date?) -> String? {
        guard let date = date else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        print("Current date: \(formatter.string(from: Date.now))")
        return formatter.string(from: date)
    }
}
