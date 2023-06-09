//
//  ASLModel.swift
//  HandGestureASLRecognition
//
//  Created by Matthew Fisher on 24/09/2022.
//

import CoreML
import Foundation
import Vision

class ASLModel {
    private(set) var model: ASLHandPoseClassifier!

    init() {
        let modelURL = Bundle.main.url(forResource: "ASLHandPoseClassifier", withExtension: "mlmodelc")!
        do {
            model = try ASLHandPoseClassifier(model: MLModel(contentsOf: modelURL))
        } catch {
            fatalError("⛔️ Could not find MLModel")
        }
    }
}
