//
//  BirdClassificationModelTests.swift
//  CreateMLDemoTests
//
//  Created by Matthew Fisher on 03/11/2023.
//

@testable import CreateMLDemo
import XCTest

final class BirdClassificationModelTests: XCTestCase {
    private var model: BirdClassificationModel!

    override func setUpWithError() throws {
        model = try .init()
    }

    override func tearDownWithError() throws {
        model = nil
    }

    func test_modelCanMakePrediction() {
        self.measure {
            do {
                let prediction = try model.model.prediction(input: .init(imageAt: TestBirdImage.kakapo))
                XCTAssertNotNil(prediction.classLabel)
            } catch {
                XCTFail("Prediction should not fail")
            }
        }
    }

    func test_modelProducesUseableData() throws {
        let prediction = try model.model.prediction(input: .init(imageAt: TestBirdImage.eurasianJay))

        XCTAssertNotNil(prediction.classLabel)
        print("Prediction - \(prediction.classLabel)")

        XCTAssertNotNil(prediction.classLabelProbs)
    }
}
