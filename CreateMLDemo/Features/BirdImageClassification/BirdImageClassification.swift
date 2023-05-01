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
                    .onChange(of: imageUrl) { newImageUrl in
                        guard let newImageUrl else { return }
                        updateImage(for: newImageUrl)

                        prediction = try? mlModel.model.prediction(input: .init(imageAt: newImageUrl))
                    }

                imagePredictionView
            }
            .padding(.horizontal, 30)
        }
    }

    var imagePredictionView: some View {
        VStack {
            if let image = self.image {
                VStack {
                    image
                        .resizable()
                        .scaledToFit()

                    Spacer(minLength: 20)

                    if let prediction = self.prediction?.classLabelProbs {
                        let wow = prediction
                            .compactMap { BirdPrediction(name: $0.key, value: $0.value) }
                            .filter { $0.value > 0.0001 }
                            .sorted { (lhs: BirdPrediction, rhs: BirdPrediction) -> Bool in
                                // you can have additional code here
                                return lhs.value > rhs.value
                            }
                        Table(wow) {
                            TableColumn("Name", value: \.name)
                            TableColumn("Prediction") { prediction in
                                CapsuleFillBar(percentage: prediction.value)
                                    .frame(height: 13)
                                    .overlay {
                                        Text(String(format: "%.2f%%", prediction.value * 100))
                                            .font(.caption2)
                                    }
                            }
                        }
                        .frame(maxHeight: 500)
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
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10).fill(Color(nsColor: .textBackgroundColor))
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
