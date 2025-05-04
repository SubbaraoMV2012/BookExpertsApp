//
//  LoginView.swift
//  BookExpertsApp
//
//  Created by SubbaRao MV on 04/05/25.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    @Environment(\.scenePhase) var scenePhase

    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            if let user = viewModel.user {
                VStack {
                    AsyncImage(url: URL(string: user.photoURL)) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    
                    Text("Welcome, \(user.name)")
                        .font(.title)
                }
            } else {
                Text("Welcome to Firebase App")
                                .font(.largeTitle)
                
                Button("Sign in with Google") {
                    if let root = UIApplication.shared.connectedScenes
                        .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                       let vc = root.windows.first?.rootViewController {
                        viewModel.signIn(presenting: vc)
                    }
                }
                .padding()
            }

            if viewModel.isLoading {
                ProgressView()
            }

            if let error = viewModel.errorMessage {
                Text(error).foregroundColor(.red)
            }
        }
        .onAppear {
            viewModel.loadUser()
        }
    }
}
