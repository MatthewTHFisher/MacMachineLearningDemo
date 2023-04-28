//
//  BirdImageClassification.swift
//
//  Created by Matthew Fisher on 27/04/2023.
//  

import CoreImage
import CoreML
import Photos
import PhotosUI
import SwiftUI

struct BirdImageClassification: View {
    @State var imageUrl: URL?
    @State var image: Image?
    var mlModel: BirdClassificationmodel = .init()
    @State var prediction: BirdImageClassifierOutput?

    var body: some View {
        ScrollView {
            VStack {
                DocumenationText(BirdImageClassificationStrings.trainingSetup)

                Image("BirdTrainingIterationGraph")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 600)

                DocumenationText(BirdImageClassificationStrings.useInstructions)

                ImagePickerButton("Choose a photo to analyse", url: $imageUrl)

                VStack {
                    if let image = self.image {
                        VStack {
                            image
                                .resizable()
                                .scaledToFit()

                            Spacer(minLength: 20)

                            if let prediction = self.prediction?.classLabelProbs {
                                let prediction = prediction.filter { $0.value > 0.0001 }
                                ScrollView {
                                    LazyVStack {
                                        ForEach(Array(prediction.keys.enumerated()), id: \.element) { _, key in
                                            HStack {
                                                Text(key)
                                                    .lineLimit(1)
                                                    .frame(width: 120)
                                                Spacer()
                                                let predictionValue = prediction[key] ?? 0
                                                CapsuleFillBar(percentage: predictionValue)
                                                    .frame(height: 12)
                                                    .overlay {
                                                        Text(String(format: "%.2f%%", predictionValue * 100))
                                                            .font(.caption2)
                                                    }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 10).fill(Color(nsColor: .textBackgroundColor))
                        }
                        .padding(.horizontal, 20)
                        .frame(maxWidth: 500)
                    } else {
                        Rectangle().fill(Color.gray.opacity(0.5))
                            .overlay {
                                Text("Image")
                            }
                    }
                }
                .frame(minWidth: 100, maxWidth: 500, minHeight: 100, maxHeight: 300)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10).fill(Color(nsColor: .textBackgroundColor))
                }
            }
            .onChange(of: imageUrl) { newImageUrl in
                guard let newImageUrl else { return }
                updateImage(for: newImageUrl)

                self.prediction = try? mlModel.model.prediction(input: .init(imageAt: newImageUrl))
            }
            .padding(.horizontal, 30)
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
