//
//  ExpenseViewModel.swift
//  NamMoneyManager
//
//  Created by Admin on 5/5/23.
//

import SwiftUI
import CoreData

class ExpenseViewModel: ObservableObject {

    // MARK: PARAMETERS
    private var context: NSManagedObjectContext

    @Published var allExpenses: [ExpensePayment] = []
    @Published var categories: [PaymentCategory] = []
    @Published var displayErrorView: Bool?

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchExpenses()
        fetchCategories()
    }

    func fetchExpenses() {
        do {
            let allExpenses = try DataController().getExpenses(context: context)
            self.allExpenses = allExpenses ?? []
            self.displayErrorView = false
        } catch {
            self.displayErrorView = true
        }
    }

    private func fetchCategories() {
        do {
            let allCategoires = try DataController().getCategory(context: context)
            self.categories = allCategoires ?? []
            self.displayErrorView = false
        } catch {
            self.displayErrorView = true
        }
    }

    func getSpecificExpenses(by category: PaymentCategory) -> [ExpensePayment] {
        var expenses = [ExpensePayment]()
        for expense in allExpenses {
            if expense.category == category {
                expenses.append(expense)
            }
        }
        return expenses
    }

}
