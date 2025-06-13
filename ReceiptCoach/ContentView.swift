import SwiftUI

struct ContentView: View {
    @State private var isShowingScanner = false
    @State private var scannedReceipt: Receipt?

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let receipt = scannedReceipt {
                    NavigationLink("View Result") {
                        ReceiptDetailView(receipt: receipt)
                    }
                }

                Button("Scan Receipt") {
                    isShowingScanner = true
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("ReceiptCoach")
            .sheet(isPresented: $isShowingScanner) {
                ReceiptScanView { result in
                    self.scannedReceipt = result
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
