//===--- ToastWithActionsExample.swift -----------------------------------------===//

import SwiftUI

struct ToastWithActionsExample: View {
    @State private var toastStatus = ToastStatus.dismissed
    @State private var items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
    @State private var deletedItem: (String, Int)?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(items.enumerated()), id: \.element) { index, item in
                    HStack {
                        Text(item)
                        Spacer()
                        Button {
                            deleteItem(at: index)
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(.borderless)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Swipe to Delete")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Delete All") {
                        deleteAll()
                    }
                    .disabled(items.isEmpty)
                }
            }
        }
        .toast(status: $toastStatus)
    }
    
    private func deleteItem(at index: Int) {
        let item = items[index]
        deletedItem = (item, index)
        items.remove(at: index)
        
        toastStatus = .init(
            toast: .warning(
                "'\(item)' deleted",
                duration: 5.0,
                buttons: [
                    ToastButton("Undo") {
                        if let (deletedItem, index) = deletedItem {
                            items.insert(deletedItem, at: index)
                            toastStatus = .dismissed
                        }
                    }
                ]
            )
        )
    }
    
    private func deleteAll() {
        let count = items.count
        let backup = items
        items.removeAll()
        
        toastStatus = .init(
            toast: .error(
                "Deleted \(count) items",
                buttons: [
                    ToastButton("Undo") {
                        items = backup
                        toastStatus = .init(success: "Items restored")
                    }
                ]
            )
        )
    }
}

#Preview {
    ToastWithActionsExample()
}
