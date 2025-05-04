//
//  BookExpertsAppApp.swift
//  BookExpertsApp
//
//  Created by SubbaRao MV on 04/05/25.
//

import SwiftUI

@main
struct MyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let persistence = PersistenceController.shared
    private let authService = FirebaseAuthService()
    private let userStore = CoreDataUserStore(context: PersistenceController.shared.container.viewContext)
    @StateObject private var viewModel: LoginViewModel

    init() {
        let loginViewModel = LoginViewModel(authService: authService, userStore: userStore)
        _viewModel = StateObject(wrappedValue: loginViewModel)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let user = viewModel.user {
                    NavigationView {
                        HomeView(user: user)
                            .environmentObject(viewModel)
                    }
                } else {
                    LoginView(viewModel: viewModel)
                        .environmentObject(viewModel)
                }
            }
        }
    }
}
