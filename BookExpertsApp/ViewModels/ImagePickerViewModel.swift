//
//  ImagePickerViewModel.swift
//  BookExpertsApp
//
//  Created by SubbaRao MV on 04/05/25.
//

import Foundation
import SwiftUI

class ImagePickerViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var isShowingImagePicker = false
    @Published var pickerSource: ImagePicker.SourceType = .photoLibrary

    func showCamera() {
        pickerSource = .camera
        isShowingImagePicker = true
    }

    func showGallery() {
        pickerSource = .photoLibrary
        isShowingImagePicker = true
    }
}
