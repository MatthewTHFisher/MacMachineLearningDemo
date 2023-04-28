//
//  BirdImageClassification.swift
//
//  Created by Matthew Fisher on 27/04/2023.
//  Copyright © Jaguar Land Rover Ltd 2023 All rights reserved.
//  This software is confidential and proprietary information.
//  

import SwiftUI
import Photos
import PhotosUI

struct BirdImageClassification: View {

    @State var imageSelection: PhotosPickerItem?
    @State var image: Image? = nil
    @State var imageLoadErrorMessage: String?

    var body: some View {
        VStack {
            PhotosPicker("Choose a photo to analyse", selection: $imageSelection, matching: .images)

            if let image = self.image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 300, maxHeight: 300)
            }
        }
        .onChange(of: imageSelection) { _ in
            Task {
                guard (imageSelection != nil) else { return }
                _ = loadTransferable(from: imageSelection!)
            }
        }
    }

    func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: Image.self) { result in
            DispatchQueue.main.async {
                // guard imageSelection == self.imageSelection else { return }
                switch result {
                case .success(let image?):
                    self.image = image
                    self.imageLoadErrorMessage = nil
                    // Handle the success case with the image.
                case .success(nil):
                    self.image = nil
                    self.imageLoadErrorMessage = nil
                    // Handle the success case with an empty value.
                case .failure(let error):
                    self.imageLoadErrorMessage = error.localizedDescription
                    // Handle the failure case with the provided error.
                }
            }
        }
    }
}
