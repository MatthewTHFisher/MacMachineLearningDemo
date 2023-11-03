//
//  ASLModel.swift
//  HandGestureASLRecognition
//
//  Created by Matthew Fisher on 24/09/2022.
//

import CoreML
import Foundation

class ASLModel {
    private(set) var model: ASLHandPoseClassifier!

    init() throws {
        let modelURL = Bundle.main.url(forResource: "ASLHandPoseClassifier", withExtension: "mlmodelc")!
        model = try ASLHandPoseClassifier(model: MLModel(contentsOf: modelURL))
    }
}
