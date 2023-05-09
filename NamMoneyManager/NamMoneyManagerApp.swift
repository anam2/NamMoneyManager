//
//  NamMoneyManagerApp.swift
//  NamMoneyManager
//
//  Created by Admin on 5/1/23.
//

import SwiftUI

@main
struct NamMoneyManagerApp: App {

    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            ExpenseView(context: dataController.container.viewContext)
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
