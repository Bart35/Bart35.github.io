import SwiftUI

/// View that displays the parsed receipt details
struct ReceiptDetailView: View {
    var receipt: Receipt

    var body: some View {
        List {
            Section("Store") {
                Text(receipt.storeName)
            }
            Section("Items") {
                ForEach(receipt.items, id: \.self) { item in
                    Text(item)
                }
            }
            Section("Total") {
                Text("$\(String(format: "%.2f", receipt.totalCost))")
            }
        }
        .navigationTitle("Receipt")
    }
}

#Preview {
    ReceiptDetailView(receipt: Receipt(storeName: "STORE", items: ["Item $1.00"], totalCost: 1.0))
}
