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
    
    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if let user = viewModel.user {
                    HomeView(user: user)
                } else {
                    VStack {
                        Spacer()
                        
                        VStack(spacing: 20) {
                            Text("Welcome to BookExpert App")
                                .font(.largeTitle)
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            Button(action: {
                                viewModel.signIn()
                            }) {
                                HStack {
                                    Image(systemName: "person.crop.circle.badge.plus")
                                    Text("Sign in with Google")
                                }
                                .font(.headline)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                            }
                            
                            if viewModel.isLoading {
                                ProgressView()
                                    .padding(.top)
                            }
                            
                            if let error = viewModel.errorMessage {
                                Text(error)
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                                    .padding(.top)
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
        }
    }
}


