//
//  LoginViewModel.swift
//  BookExpertsApp
//
//  Created by SubbaRao MV on 04/05/25.
//

import Foundation
import UIKit

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
    }

    func signIn(presenting: UIViewController) {
        Task {
            isLoading = true
            do {
                let user = try await authService.signInWithGoogle(presenting: presenting)
                try userStore.save(user: user)
                self.user = user
                errorMessage = nil
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    func loadUser() {
        do {
            user = try userStore.fetchUser()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
