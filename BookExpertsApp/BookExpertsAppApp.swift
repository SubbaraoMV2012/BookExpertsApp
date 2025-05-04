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

    var body: some Scene {
        WindowGroup {
            LoginView(
                viewModel: LoginViewModel(
                    authService: FirebaseAuthService(),
                    userStore: CoreDataUserStore(context: persistence.container.viewContext)
                )
            )
        }
    }
}
