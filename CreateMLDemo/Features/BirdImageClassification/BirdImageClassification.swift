//
//  BirdImageClassification.swift
//
//  Created by Matthew Fisher on 27/04/2023.
//  Copyright © Jaguar Land Rover Ltd 2023 All rights reserved.
//  This software is confidential and proprietary information.
//  

import SwiftUI
import CoreML
import Photos
import PhotosUI
import CoreImage

struct BirdImageClassification: View {

    @State var imageUrl: URL?
    @State var image: Image?
    var mlModel: BirdClassificationmodel = .init()
    @State var prediction: BirdImageClassifierOutput?

    var body: some View {
        VStack {
            // PhotosPicker("Choose a photo to analyse", selection: $imageSelection, matching: .images)
            ImagePickerButton("Choose a photo to analyse", url: $imageUrl)

            if let image = self.image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 300, maxHeight: 300)
            }
            
            if let prediction = self.prediction?.classLabelProbs {
                let prediction = prediction.filter { $0.value > 0.0001 }
                ScrollView {
                    ForEach(Array(prediction.keys.enumerated()), id: \.element) { _, key in
                        HStack {
                            Text(key)
                            Text(String(format: "%.2f%%", (prediction[key] ?? 0)*100))
                        }
                    }
                }
            }
        }
        .onChange(of: imageUrl) { newImageUrl in
            guard let newImageUrl = newImageUrl else { return }
            updateImage(for: newImageUrl)
            
            self.prediction = try? mlModel.model.prediction(input: .init(imageAt: newImageUrl))
        }
    }
    
    func updateImage(for url: URL) {
        do {
            let imageData = try Data(contentsOf: url)
            guard let nsImage = NSImage(data: imageData) else {
                print("Image data could not be loaded")
                return
            }
            image = Image(nsImage: nsImage)
        } catch {
            print("Error loading image : \(error)")
        }
    }
}

class BirdClassificationmodel {
    private(set) var model: BirdImageClassifier!

    init() {
        let modelURL = Bundle.main.url(forResource: "BirdImageClassifier", withExtension: "mlmodelc")!
        do {
            model = try BirdImageClassifier(model: MLModel(contentsOf: modelURL))
        } catch {
            fatalError("⛔️ Could not find MLModel")
        }
    }
}
