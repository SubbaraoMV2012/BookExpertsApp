//
//  PDKKitView.swift
//  BookExpertsApp
//
//  Created by SubbaRao MV on 04/05/25.
//

import SwiftUI
import PDFKit

struct PDFKitView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.backgroundColor = UIColor.systemBackground

        if let document = PDFDocument(url: url) {
            pdfView.document = document
        } else {
            print("⚠️ Failed to load PDF from: \(url)")
        }

        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        // No-op for now
    }
}


