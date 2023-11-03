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
    @State private var imageUrl: URL?
    @State private var image: Image?
    var mlModel: BirdClassificationModel
    @State private var prediction: BirdImageClassifierOutput?

    init() {
        do {
            self.mlModel = try .init()
        } catch {
            fatalError("⛔️ Could not initialise BirdClassificationModel")
        }
    }

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
                        do {
                            if let image = try urlToNSImage(newImageUrl) {
                                self.image = Image(nsImage: image)
                            } else {
                                image = nil
                            }

                            prediction = try mlModel.model.prediction(
                                input: BirdImageClassifierInput(imageAt: newImageUrl)
                            )
                            print("✅ Successfully got predictions")
                        } catch {
                            print("⛔️ Failed to get prediction")
                        }
                    }

                imagePredictionView
            }
            .padding(.horizontal, 30)
        }
    }

    var imagePredictionView: some View {
        VStack {
            if let image {
                VStack {
                    image
                        .resizable()
                        .scaledToFit()

                    Spacer(minLength: 20)

                    if let prediction {
                        let data = BirdPrediction.fromDict(dictionary: prediction.classLabelProbs)
                        let filteredData = BirdPrediction.filterArray(data)
                        VStack(alignment: .leading) {
                            ForEach(filteredData) { prediction in
                                Text(String(format: "%.1f%@ - %@", prediction.value * 100, "%", prediction.name))
                            }
                        }
                    }
                }
                .background {
                    RoundedRectangle(cornerRadius: 10).fill(Color(nsColor: .textBackgroundColor))
                }
                .padding(.horizontal, 20)
            } else {
                Rectangle().fill(Color.gray.opacity(0.5))
                    .overlay {
                        Text("Image")
                    }
            }
        }
        .frame(maxWidth: 500, minHeight: 150)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10).fill(Color(nsColor: .textBackgroundColor))
        }
    }
}
