//
//  BirdClassificationModel.swift
//  CreateMLDemo
//
//  Created by Matthew Fisher on 28/04/2023.
//

import CoreML

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
