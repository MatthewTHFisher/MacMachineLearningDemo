//
//  HandPoseObservationTests.swift
//  CreateMLDemoTests
//
//  Created by Matthew Fisher on 03/11/2023.
//

@testable import CreateMLDemo
import XCTest

final class HandPoseObservationTests: XCTestCase {
    func test_getHandPoseSuccessful() throws {
        // An image that has a hand in it
        let image = imageFromURL(url: TestASLImages.cPose)
        let observations = try HandPoseObservation.getHandPoses(cgImage: image)

        XCTAssertNotNil(observations.first, "Test should get a successful hand pose")
    }

    func test_getHandPoseNoVisibleHand() throws {
        // An image without a hand in it
        let image = imageFromURL(url: TestBirdImage.osprey)
        let observations = try HandPoseObservation.getHandPoses(cgImage: image)

        XCTAssertNil(observations.first, "Test should not get a successful hand pose")
    }
}
