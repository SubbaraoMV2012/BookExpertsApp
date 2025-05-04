//
//  PDFViewModel.swift
//  BookExpertsApp
//
//  Created by SubbaRao MV on 04/05/25.
//

import Foundation
import Combine

@MainActor
class PDFViewModel: ObservableObject {
    @Published var pdfURL: URL?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadPDF(from urlString: String) {
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid PDF URL"
            return
        }

        isLoading = true
        Task {
            self.pdfURL = url
            self.errorMessage = nil
            isLoading = false
        }
    }
}

