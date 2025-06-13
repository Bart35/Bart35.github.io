import Foundation

/// Simple data store placeholder using UserDefaults
class ReceiptDataStore {
    private let receiptsKey = "receipts"

    func loadReceipts() -> [Receipt] {
        guard let data = UserDefaults.standard.data(forKey: receiptsKey),
              let receipts = try? JSONDecoder().decode([Receipt].self, from: data) else {
            return []
        }
        return receipts
    }

    func saveReceipts(_ receipts: [Receipt]) {
        if let data = try? JSONEncoder().encode(receipts) {
            UserDefaults.standard.set(data, forKey: receiptsKey)
        }
    }
}
