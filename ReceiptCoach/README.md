# ReceiptCoach

A minimal SwiftUI iOS 17+ project skeleton demonstrating how to scan receipts using `VNDocumentCameraViewController`, perform OCR with Vision, and display parsed results.

This project includes:

- A main view with a "Scan Receipt" button
- A wrapper around `VNDocumentCameraViewController` to capture receipt photos
- OCR logic using `VNRecognizeTextRequest`
- A simple `Receipt` model and placeholder data store
- A results view showing the parsed receipt

The parsing logic is intentionally simple: it takes the first uppercase line as the store name and looks for lines ending with a dollar amount to detect items and totals. You can enhance this logic to better suit real-world receipts.

`UserDefaults` is used as a placeholder for local storage. Replace it with a more robust solution as needed.
