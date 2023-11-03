//
//  ASLModelTests.swift
//  CreateMLDemoTests
//
//  Created by Matthew Fisher on 03/11/2023.
//

@testable import CreateMLDemo
import XCTest

final class ASLModelTests: XCTestCase {
    private var model: ASLModel!

    override func setUpWithError() throws {
        try model = .init()
    }

    override func tearDownWithError() throws {
        model = nil
    }

    func test_modelCanMakePrediction() throws {
        let image = imageFromURL(url: TestASLImages.wPose)
        let poses = try HandPoseObservation.getHandPoses(cgImage: image)

        guard let pose = poses.first else {
            XCTFail("No pose found from test image")
            return
        }

        let keypointsMultiArray = try pose.keypointsMultiArray()

        let prediction = try model.model.prediction(poses: keypointsMultiArray)

        XCTAssertNotNil(prediction.label)
        print("Prediction - \(prediction.label)")
        XCTAssertNotNil(prediction.labelProbabilities)
    }

    func test_endToEndPerformance() {
        let image = imageFromURL(url: TestASLImages.cPose)
        var prediction: ASLHandPoseClassifierOutput!
        self.measure {
            do {
                let poses = try HandPoseObservation.getHandPoses(cgImage: image)

                guard let pose = poses.first else {
                    XCTFail("No pose found from test image")
                    return
                }

                let keypointsMultiArray = try pose.keypointsMultiArray()

                prediction = try model.model.prediction(poses: keypointsMultiArray)
            } catch {
                XCTFail("End-2-end should not fail")
            }
        }
        XCTAssertNotNil(prediction.label)
        print("Prediction - \(prediction.label)")
        XCTAssertNotNil(prediction.labelProbabilities)
    }
}
