//
//  PDFView.swift
//  BookExpertsApp
//
//  Created by SubbaRao MV on 04/05/25.
//

import SwiftUI

struct PDFViewScreen: View {
    @StateObject private var viewModel = PDFViewModel()
    let urlString: String

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading PDF...")
            } else if let url = viewModel.pdfURL {
                PDFKitView(url: url)
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            } else {
                Text("No PDF loaded.")
            }
        }
        .task {
            viewModel.loadPDF(from: urlString)
        }
        .navigationTitle("Balance Sheet")
        .navigationBarTitleDisplayMode(.inline)
    }
}


