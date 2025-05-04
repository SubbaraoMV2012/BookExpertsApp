//
//  ImagePickerView.swift
//  BookExpertsApp
//
//  Created by SubbaRao MV on 04/05/25.
//

import Foundation
import SwiftUI

struct ImagePickerView: View {
    @StateObject private var viewModel = ImagePickerViewModel()
    @State private var showActionSheet = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Tap the image to update")
                .font(.headline)

            Group {
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                        .opacity(0.5)
                }
            }
            .frame(width: 200, height: 200)
            .clipShape(Circle())
            .onTapGesture {
                showActionSheet = true
            }

            Spacer()
        }
        .padding()
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: Text("Select Image"), buttons: [
                .default(Text("Camera")) { viewModel.showCamera() },
                .default(Text("Gallery")) { viewModel.showGallery() },
                .cancel()
            ])
        }
        .sheet(isPresented: $viewModel.isShowingImagePicker) {
            ImagePicker(
                sourceType: viewModel.pickerSource,
                selectedImage: $viewModel.selectedImage
            )
        }
        .navigationTitle("Image Selection")
    }
}
