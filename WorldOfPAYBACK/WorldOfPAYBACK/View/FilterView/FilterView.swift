//
//  FilterView.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 23/04/2024.
//

import SwiftUI

struct FilterView: View {
    // MARK: - Binding
    @Binding var isPresented: Bool

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
                    Button("Apply") { onSelection(selectedCategory)
                        isPresented.toggle()
                    }
                }
            }
            
            Section {
                Button("Clear", role: .destructive) {
                    selectedCategory = nil
                    onSelection(selectedCategory)
                    isPresented.toggle()
                }
            }
        }
    }
}

#Preview {
    FilterView(isPresented: .constant(false),
               selectedCategory: nil,
               categories: [
                Category(id: 1),
                Category(id: 2),
                Category(id: 3),
                Category(id: 4)],
               onSelection: { _ in }
    )
}
