//
//  DataManager.swift
//  NamMoneyManager
//
//  Created by Admin on 5/1/23.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container: NSPersistentContainer = NSPersistentContainer(name: "MoneyManagerModel")

    init() {
        container.loadPersistentStores { _, error in
            if let error = error {
                // handle the error here
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
    }

    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            // handle the error here
            fatalError("Failed to save managed object context: \(error)")
        }
    }

    // MARK: PAYMENT EXPENSE

    func addExpense(title: String,
                    amount: String,
                    description: String,
                    category: String,
                    inputDate: Date,
                    context: NSManagedObjectContext) {
        do {
            let expense = ExpensePayment(context: context)
            expense.id = UUID()
            expense.title = title
            expense.amount = amount
            expense.expenseDescription = description
            expense.category = try getSpecificCategory(for: category, context: context)
            expense.inputDate = Date()
            save(context: context)
        } catch {
            // Handle error
            return
        }
    }

    func getExpenses(context: NSManagedObjectContext) throws -> [ExpensePayment]? {
        let request = NSFetchRequest<ExpensePayment>(entityName: "ExpensePayment")
        let sortDescriptor = NSSortDescriptor(key: "inputDate", ascending: false)
        request.sortDescriptors = [sortDescriptor]

        do {
            let expenses = try context.fetch(request)
            return expenses
        } catch let error as NSError {
            throw error
        }
    }

    func getSpecificExpense(by category: PaymentCategory, context: NSManagedObjectContext) -> [ExpensePayment]? {
        let request = NSFetchRequest<ExpensePayment>(entityName: "ExpensePayment")
//        let sortDescriptor = NSSortDescriptor(key: "inputDate", ascending: false)
        let predicate = NSPredicate(format: "category == %@", category)
        request.predicate = predicate

        do {
            let results = try context.fetch(request)
            return results
        } catch {
            // Handle error
            return nil
        }
    }

    func editExpense(expensePayment: ExpensePayment, amountPrice: String, description: String, context: NSManagedObjectContext) {
        expensePayment.lastEditDate = Date()
        expensePayment.amount = amountPrice
        expensePayment.expenseDescription = description
        save(context: context)
    }

    func deleteExpense(id: UUID?, context: NSManagedObjectContext) {
        guard let id = id else { return }
        let fetchRequest = ExpensePayment.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let results = try context.fetch(fetchRequest)
            if let deleteExpense = results.first {
                context.delete(deleteExpense)
            }
        } catch {
            NSLog("Failed to delete expense with id: \(id)")
        }
    }

    // MARK: CATEGORIES

    func addCategory(categoryName: String, context: NSManagedObjectContext) {
        let category = PaymentCategory(context: context)
        category.id = UUID()
        category.name = categoryName
        save(context:  context)
    }

    /**
     Fetches the entire category list stored in Core Data.
     */
    func getCategory(context: NSManagedObjectContext) throws -> [PaymentCategory]? {
        let request = NSFetchRequest<PaymentCategory>(entityName: "PaymentCategory")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        request.sortDescriptors = [sortDescriptor]

        do {
            let categories = try context.fetch(request)
            return categories
        } catch let error as NSError {
            print("Error fetching expenses: \(error.localizedDescription)")
            throw error
        }
    }

    /**
     Fetches a specfic category list stored in Core Data.
     */
    private func getSpecificCategory(for categoryName: String,
                                     context: NSManagedObjectContext) throws -> PaymentCategory? {

        do {
            guard let categories = try getCategory(context: context),
                  let index = categories.firstIndex(where: { $0.name == categoryName }) else { return nil }
            return categories[index]
        } catch let error as NSError {
            throw error
        }

    }
}
