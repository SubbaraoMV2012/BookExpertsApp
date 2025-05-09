//
//  HomeView.swift
//  BookExpertsApp
//
//  Created by SubbaRao MV on 04/05/25.
//

import SwiftUI

struct HomeView: View {
    let user: User
    @EnvironmentObject var viewModel: LoginViewModel
    @StateObject private var pdfViewModel = PDFViewModel()
    @StateObject private var imagePickerViewModel = ImagePickerViewModel()
    
    private var mobileStoreProtocol: MobileStoreProtocol {
        CoreDataMobileStore(context: PersistenceController.shared.container.viewContext)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                AsyncImage(url: URL(string: user.photoURL)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())

                Text("Welcome, \(user.name)")
                    .font(.title)

                Text("Email: \(user.email)")
                    .foregroundColor(.secondary)
            }
            .padding()
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        NavigationLink(destination: PDFViewScreen(
                            urlString: "https://fssservices.bookxpert.co/GeneratedPDF/Companies/nadc/2024-2025/BalanceSheet.pdf"
                        )) {
                            Text("View Balance PDF")
                        }
                        NavigationLink(destination: ImagePickerView()) {
                            Text("Image Selection")
                        }
                        NavigationLink(destination: MobileListView(mobileStoreProtocol: mobileStoreProtocol)) {
                            Text("Mobile List")
                        }
                        Button("Signout") {
                            viewModel.signOut()
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(.blue)
                            .font(.title)
                    }

                }
            }
        }
    }
}
