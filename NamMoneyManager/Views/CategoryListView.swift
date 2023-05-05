//
//  CategoryListView.swift
//  NamMoneyManager
//
//  Created by Admin on 5/1/23.
//

import SwiftUI

struct CategoryListView: View {

    @State var presentAlert = false
    @State var selectedCategory: String = ""
    @Binding var displayCategory: String

    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var categories: FetchedResults<PaymentCategory>

    private func delete(at offsets: IndexSet) {
        offsets.map { categories[$0] }.forEach(managedObjectContext.delete)
        DataController().save(context: managedObjectContext)
    }

    var body: some View {
        List {
            Section {
                ForEach(categories) { category in
                    HStack {
                        Text(category.name ?? "")
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        displayCategory = category.name ?? ""
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                .onDelete(perform: delete)
            }

            Section {
                HStack {
                    Spacer()
                    Button("Add Category") {
                        presentAlert = true
                    }
                    .alert("Add Category", isPresented: $presentAlert) {
                        TextField("Category", text: $selectedCategory)
                        Button("Submit", action: {
                            DataController().addCategory(categoryName: selectedCategory, context: managedObjectContext)
                            selectedCategory = ""
                        })
                    }
                    Spacer()
                }
            }
        }
    }
}

//struct CategoryListView_Previews: PreviewProvider {
//    static var previews: some View {
//        let categories = ["Gas", "Food", "Grocery"]
//        @State var selectedCategory: String = ""
//        CategoryListView(displayCategory: $selectedCategory)
//    }
//}
