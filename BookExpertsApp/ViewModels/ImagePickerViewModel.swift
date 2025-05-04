//
//  ImagePickerViewModel.swift
//  BookExpertsApp
//
//  Created by SubbaRao MV on 04/05/25.
//

import Foundation
import SwiftUI
import AVFoundation
import Photos

class ImagePickerViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var isShowingImagePicker = false
    @Published var pickerSource: ImagePicker.SourceType = .photoLibrary
    @Published var showAlert = false
    @Published var alertMessage = ""

    func showCamera() {
        checkCameraPermission { granted in
            if granted {
                self.pickerSource = .camera
                self.isShowingImagePicker = true
            } else {
                self.alertMessage = "Camera access is required to take a photo."
                self.showAlert = true
            }
        }
       
    }

    func showGallery() {
        checkPhotoLibraryPermission { granted in
            if granted {
                self.pickerSource = .photoLibrary
                self.isShowingImagePicker = true
            } else {
                self.alertMessage = "Photo library access is required to select a photo."
                self.showAlert = true
            }
        }
    }
    
    private func checkCameraPermission(completion: @escaping (Bool) -> Void) {
           switch AVCaptureDevice.authorizationStatus(for: .video) {
           case .authorized:
               completion(true)
           case .notDetermined:
               AVCaptureDevice.requestAccess(for: .video) { response in
                   completion(response)
               }
           default:
               completion(false)
           }
       }

       private func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
           switch PHPhotoLibrary.authorizationStatus() {
           case .authorized:
               completion(true)
           case .notDetermined:
               PHPhotoLibrary.requestAuthorization { status in
                   completion(status == .authorized)
               }
           default:
               completion(false)
           }
       }
}
