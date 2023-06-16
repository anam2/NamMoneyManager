//
//  ExpenseView.swift
//  NamMoneyManager
//
//  Created by Admin on 5/1/23.
//

import SwiftUI
import CoreData

struct ExpenseView: View {

    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var viewModel: ExpenseViewModel

    /// Toggle for ExpenseInputView.
    @State private var showingInputView = false
    /// The index of the selected category. If nil, no categories has been selected.
    @State private var selectedCategoryIndex: Int?
    /// If toggled, will make call to CoreData and populate viewModel with latest data.
    @State private var reloadData: Bool = false

    init(context: NSManagedObjectContext) {
        viewModel = ExpenseViewModel(context: context)
    }

    // MARK: MAIN BODY

    var body: some View {
        if viewModel.displayErrorView == true {
            ErrorView()
        } else {
            NavigationView {
                List {
                    // Total money view.
                    Section {
                        totalMoneyView
                    }
                    // Category picker view.
                    Section {
                        categoryPickerView
                    }
                    // Expense list view.
                    Section {
                        expenseView
                    }
                }
                .navigationTitle("Expenses")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    addToolbarItem
                }
                .sheet(isPresented: $showingInputView) {
                    ExpenseInputView(showExpenseSheet: $showingInputView,
                                     reloadExpenseView: $reloadData)
                }
                .onChange(of: reloadData) { reloadData in
                    if reloadData == true {
                        viewModel.fetchExpenses()
                        self.reloadData = false
                    }
                }
            }
        }
    }

    private var addToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                showingInputView.toggle()
            } label: {
                Label("Add", systemImage: "plus.circle")
            }
        }
    }

    private var totalMoneyView: some View {
        HStack {
            Spacer()
            VStack(alignment: .center) {
                Text("TOTAL")
                    .font(.system(size: 18.0))
                    .bold()
                    .foregroundColor(.gray)
                Text("$\(totalMoney())")
                    .foregroundColor(.black)
                    .bold()
                    .font(.system(size: 26.0))
            }
            Spacer()
        }
    }

    private var categoryPickerView: some View {
        VStack(alignment: .leading) {
            Text("CATEGORIES")
                .font(.system(size: 12.0))
                .bold()
                .foregroundColor(Color.gray.opacity(0.9))
            PickerView(pickerIcons: getPickerIconViews())
        }
    }

    private func getPickerIconViews() -> [PickerIcon] {
        var pickerIcons: [PickerIcon] = []
        for (index, category) in viewModel.categories.enumerated() {
            let pickerIcon = PickerIcon(text: category.name ?? "",
                                        iconIndex: index,
                                        selectedCategoryIndex: $selectedCategoryIndex)
            pickerIcons.append(pickerIcon)
        }
        return pickerIcons
    }

    private var expenseView: some View {
        if let selectedCategoryIndex = selectedCategoryIndex {
            return createExpenseTableView(expenses: viewModel.getSpecificExpenses(by: viewModel.categories[selectedCategoryIndex]))
        } else {
            return createExpenseTableView(expenses: viewModel.allExpenses)
        }
    }

    private func createExpenseTableView(expenses: [ExpensePayment]) -> some View {
        ForEach(expenses) { expense in
            NavigationLink(destination: ExpenseDetailView(selectedExpense: expense,
                                                          reloadExpenseView: $reloadData)) {
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
                    let amountText = getMoneyFormatString(from: expense.amount ?? "")
                    Text("$ \(amountText)")
                }
                .padding([.top, .bottom], 5.0)
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

    private func getMoneyFormatString(from stringMoney: String) -> String {
        let doubleMoney = Double(stringMoney) ?? 0.0
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: doubleMoney)) ?? ""
    }

    private func totalMoney() -> String {
        var totalAmount: Double = 0.0
        for expense in viewModel.allExpenses {
            let doubleAmount = Double(expense.amount ?? "0.00")
            totalAmount += doubleAmount ?? 0.00
        }
        let totalMoneyString = String(format: "%.2f", totalAmount)
        let moneyString = getMoneyFormatString(from: totalMoneyString)
        return moneyString
    }

}
