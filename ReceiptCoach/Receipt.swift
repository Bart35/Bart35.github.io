import Foundation

/// Simple model representing a scanned receipt
struct Receipt: Identifiable, Codable {
    let id: UUID = UUID()
    var storeName: String
    var items: [String]
    var totalCost: Double
}
