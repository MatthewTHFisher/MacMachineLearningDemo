//
//  BirdClassificationModel.swift
//  CreateMLDemo
//
//  Created by Matthew Fisher on 28/04/2023.
//

import CoreML

class BirdClassificationModel {
    private(set) var model: BirdImageClassifier!

    init() throws {
        let modelURL = Bundle.main.url(forResource: "BirdImageClassifier", withExtension: "mlmodelc")!
        model = try BirdImageClassifier(model: MLModel(contentsOf: modelURL))
    }
}
