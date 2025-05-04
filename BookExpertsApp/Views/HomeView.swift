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

    var body: some View {
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

            Button("Logout") {
                viewModel.signOut()
            }
            .foregroundColor(.red)
            .padding()
        }
        .padding()
    }
}
