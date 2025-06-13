import SwiftUI
import VisionKit
import Vision

/// A view that wraps VNDocumentCameraViewController to capture a receipt
struct ReceiptScanView: UIViewControllerRepresentable {
    typealias Completion = (Receipt) -> Void
    var completion: Completion

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var parent: ReceiptScanView

        init(parent: ReceiptScanView) {
            self.parent = parent
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            controller.dismiss(animated: true)
            guard scan.pageCount > 0 else { return }
            let image = scan.imageOfPage(at: 0)
            recognizeText(in: image) { text in
                let receipt = parseReceipt(from: text)
                self.parent.completion(receipt)
            }
        }

        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true)
        }
    }

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let controller = VNDocumentCameraViewController()
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}

// MARK: - OCR Helper
private func recognizeText(in image: UIImage, completion: @escaping (String) -> Void) {
    let request = VNRecognizeTextRequest { request, error in
        guard error == nil, let observations = request.results as? [VNRecognizedTextObservation] else {
            completion("")
            return
        }
        let text = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
        completion(text)
    }
    request.recognitionLevel = .accurate
    let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
    try? handler.perform([request])
}

// Simple parsing: first uppercase word as store name, lines ending with $amount as items
private func parseReceipt(from text: String) -> Receipt {
    let lines = text.components(separatedBy: "\n")
    let storeName = lines.first { $0 == $0.uppercased() } ?? "Unknown"
    var items: [String] = []
    var total: Double = 0

    let amountPattern = #"\$([0-9]+(?:\.[0-9]{2})?)"#
    let regex = try? NSRegularExpression(pattern: amountPattern, options: [])

    for line in lines {
        if let match = regex?.firstMatch(in: line, options: [], range: NSRange(location: 0, length: line.utf16.count)) {
            let nsString = line as NSString
            let amountString = nsString.substring(with: match.range(at: 1))
            if line.lowercased().contains("total") {
                total = Double(amountString) ?? 0
            } else {
                items.append(line)
            }
        }
    }

    return Receipt(storeName: storeName, items: items, totalCost: total)
}
