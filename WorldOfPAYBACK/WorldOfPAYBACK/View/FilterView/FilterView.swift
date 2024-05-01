//
//  FilterView.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 23/04/2024.
//

import SwiftUI

struct FilterView: View {
    // MARK: - Environment
    @Environment(\.dismiss) var dismissAction

    // MARK: - States
    @State var selectedCategory: Category?

    let categories: [Category]
    let onSelection: (Category?) -> Void

    var body: some View {
        Form {
            Section {
                Picker("Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) {
                        Text($0.name).tag(Optional($0))
                    }
                }
                .pickerStyle(.inline)
            }
            
            if selectedCategory != nil {
                Section {
                    Button("Apply") {
                        onSelection(selectedCategory)
                        dismissAction.callAsFunction()
                    }
                }
            }
            
            Section {
                Button("Clear", role: .destructive) {
                    selectedCategory = nil
                    onSelection(selectedCategory)
                    dismissAction.callAsFunction()
                }
            }
        }
    }
}

#Preview {
    FilterView(selectedCategory: nil,
               categories: [
                Category(id: 1),
                Category(id: 2),
                Category(id: 3),
                Category(id: 4)],
               onSelection: { _ in }
    )
}
