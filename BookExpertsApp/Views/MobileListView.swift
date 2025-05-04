//
//  MobileListView.swift
//  BookExpertsApp
//
//  Created by SubbaRao MV on 04/05/25.
//

import SwiftUI
import FirebaseFunctions
import FirebaseMessaging

struct MobileListView: View {
    @StateObject private var viewModel: MobileListViewModel
    @State private var newName: String = ""
    @State private var selectedObjectId: String?
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    
    init(mobileStoreProtocol: MobileStoreProtocol) {
        _viewModel = StateObject(wrappedValue: MobileListViewModel(mobileStoreProtocol: mobileStoreProtocol))
    }
    
    var body: some View {
        VStack {
            Toggle("Enable Notifications", isOn: $notificationsEnabled)
                .padding(.horizontal)
            
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
                            deleteObject(id: mobile.id, name: mobile.name)
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
                        
                        let items = try JSONDecoder().decode([Mobile].self, from: data)
                        
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
    
    private func deleteObject(id: String, name: String) {
        viewModel.deleteObject(id: id)
        if notificationsEnabled {
            triggerFCMNotification(for: name, id: id)
        }
    }
    
    private func triggerFCMNotification(for name: String, id: String) {
        guard notificationsEnabled else { return }

        guard let fcmToken = NotificationManager.shared.fcmToken else {
            print("FCM token not available yet")
            return
        }

        let data: [String: Any] = [
            "itemName": name,
            "itemId": id,
            "fcmToken": fcmToken
        ]

        Functions.functions().httpsCallable("sendDeleteNotification").call(data) { result, error in
            if let error = error {
                print("FCM Error: \(error.localizedDescription)")
            } else {
                print("✅ FCM push notification sent successfully.")
            }
        }
    }


}
