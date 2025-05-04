//
//  LoginViewModel.swift
//  BookExpertsApp
//
//  Created by SubbaRao MV on 04/05/25.
//

import Foundation
import FirebaseAuth
import UIKit
import CoreData

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let authService: AuthServiceProtocol
    private let userStore: UserStoreProtocol

    init(authService: AuthServiceProtocol, userStore: UserStoreProtocol) {
        self.authService = authService
        self.userStore = userStore
        loadUser()
    }
    
    func signIn() {
        Task {
            isLoading = true

            do {
                let rootVC: UIViewController = try await MainActor.run {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let rootVC = windowScene.windows.first?.rootViewController else {
                        throw NSError(domain: "UI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Cannot access root view controller"])
                    }
                    return rootVC
                }

                let user = try await authService.signInWithGoogle(presenting: rootVC)
                try userStore.save(user: user)
                self.user = user
                errorMessage = nil
                requestNotificationPermission()
            } catch {
                errorMessage = error.localizedDescription
            }

            isLoading = false
        }
    }
    
    private func loadUser() {
        do {
            self.user = try userStore.fetchUser()
        } catch {
            print("Failed to load user: \(error.localizedDescription)")
            self.user = nil
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            try deleteStoredUser()
            self.user = nil
        } catch {
            errorMessage = "Failed to sign out: \(error.localizedDescription)"
        }
    }

    private func deleteStoredUser() throws {
        let request: NSFetchRequest<NSFetchRequestResult> = CDUser.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        try (userStore as? CoreDataUserStore)?.context.execute(deleteRequest)
        try (userStore as? CoreDataUserStore)?.context.save()
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }
}

