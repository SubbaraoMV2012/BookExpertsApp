//
//  MobileListView.swift
//  BookExpertsApp
//
//  Created by SubbaRao MV on 04/05/25.
//

import SwiftUI

struct MobileListView: View {
    @StateObject private var viewModel: MobileListViewModel
    @State private var newName: String = ""
    @State private var selectedObjectId: String?

    init(mobileStoreProtocol: MobileStoreProtocol) {
        _viewModel = StateObject(wrappedValue: MobileListViewModel(mobileStoreProtocol: mobileStoreProtocol))
    }

    var body: some View {
            VStack {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                List {
                    ForEach(viewModel.mobiles, id: \.id) { mobile in
                        HStack {
                            Text(mobile.name)
                            Spacer()

                            Button("Delete") {
                                viewModel.deleteObject(id: mobile.id)
                            }
                            .buttonStyle(.bordered)
                            .foregroundColor(.red)
                            .padding(5)

                            Button("Update") {
                                selectedObjectId = mobile.id
                            }
                            .buttonStyle(.bordered)
                            .padding(5)
                        }
                    }
                }

                if let selectedObjectId = selectedObjectId {
                    TextField("Enter new name", text: $newName)
                        .padding()
                        .textFieldStyle(.roundedBorder)

                    Button("Update Object") {
                        viewModel.updateObject(id: selectedObjectId, newName: newName)
                        self.selectedObjectId = nil
                        self.newName = ""
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }

                Button("Fetch from API") {
                    Task {
                        do {
                            let url = URL(string: "https://api.restful-api.dev/objects")!
                            let (data, _) = try await URLSession.shared.data(from: url)
                            
                            // Try decoding the API response into Mobile objects
                            let items = try JSONDecoder().decode([Mobile].self, from: data)
                            
                            // Add the decoded items to your view model or wherever needed
                            viewModel.addMobiles(from: items)
                            
                        } catch {
                            viewModel.errorMessage = "Failed to fetch API data: \(error.localizedDescription)"
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .navigationTitle("Mobiles")
            .navigationBarTitleDisplayMode(.inline)
    }
}
