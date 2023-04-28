//
//  ContentView.swift
//  HandGestureASLRecognition
//
//  Created by Matthew Fisher on 24/09/2022.
//

import AVFoundation
import SwiftUI
import Vision

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    @ObservedObject var poseViewModel = PlayerViewController()

    private var handPoseRequest = VNDetectHumanHandPoseRequest()

    @State var handPoints: [CGPoint] = []

    @State var showPredictions = false
    @State var showAugmentation = false

    let rows = [
        GridItem(.adaptive(minimum: 40), alignment: .trailing)
    ]

    init() {
        viewModel.checkAuthorization()
    }

    var body: some View {
        VStack {
            HStack {
                Toggle(isOn: $showPredictions) {
                    Text("Predictions")
                }
                Toggle(isOn: $showAugmentation) {
                    Text("Augmentation")
                }
            }
            HStack {
                GeometryReader { geo in
                    ZStack {
                        PlayerContainerView(captureSession: viewModel.captureSession, viewModel: poseViewModel)
                            .onChange(of: poseViewModel.handPoseObservation) { observation in
                                if showAugmentation {
                                    guard let observation else { return }
                                    processObservation(observation, imageSize: geo.size)
                                }
                            }
                        if showAugmentation {
                            HandAugmentation(handPoints: self.handPoints, imageSize: geo.size)
                        }
                    }
                }

                if let predictions = poseViewModel.prediction?.labelProbabilities, showPredictions {
                    let highestPrediction = predictions.values.max()
                    LazyHGrid(rows: self.rows, alignment: .firstTextBaseline) {
                        ForEach(Array(predictions.keys.sorted().enumerated()), id: \.element) { _, key in
                            LetterPredictionView(
                                letter: key,
                                prediction: CGFloat(predictions[key] ?? 0),
                                isActive: (predictions[key] ?? 0) == highestPrediction
                            )
                                .fixedSize()
                        }
                    }
                    .padding(5)
                }
            }
        }
    }

    func processObservation(_ observation: VNHumanHandPoseObservation, imageSize: CGSize) {
        guard let recognizedPoints = try? observation.recognizedPoints(.all) else { return }

        guard let previewLayer = poseViewModel.previewLayer else { return }

        let imagePointsNew: [CGPoint] = recognizedPoints.map { _, value in
            // guard value.confidence > 0 else { return nil }

            // let point = VNImagePointForNormalizedPoint(value.location, Int(imageSize.width), Int(imageSize.height))

            let point = CGPoint(x: value.location.x, y: 1 - value.location.y)

            return previewLayer.layerPointConverted(fromCaptureDevicePoint: point)
        }

        // Draw the points onscreen.
        self.handPoints = imagePointsNew
    }

    struct HandAugmentation: View {
        var handPoints: [CGPoint]
        var imageSize: CGSize

        var body: some View {
            ZStack {
                ForEach(self.handPoints, id: \.self) { point in
                    Circle()
                        .fill(Color.green.opacity(0.7))
                        .position(x: point.x - imageSize.width / 2, y: point.y - imageSize.height / 2)
                        .frame(width: 9, height: 9)
                }
            }
            .frame(width: imageSize.width, height: imageSize.height)
        }
    }
}

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
