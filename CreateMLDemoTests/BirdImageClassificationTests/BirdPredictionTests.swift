//
//  CreateMLDemoTests.swift
//  CreateMLDemoTests
//
//  Created by Matthew Fisher on 03/11/2023.
//

@testable import CreateMLDemo
import XCTest

final class BirdPredictionTests: XCTestCase {
    func test_canConvertFromDict() {
        let testData: [String: Double] = ["Eagle": 0.5]

        let converted = BirdPrediction.fromDict(dictionary: testData)
        let item = converted.first!

        XCTAssertEqual(item.name, "Eagle")
        XCTAssertEqual(item.value, 0.5)
    }

    func test_filterIgnoresValuesWithLowPrediction() {
        let bird1 = BirdPrediction(name: "Eagle", value: 0.5)
        let bird2 = BirdPrediction(name: "Seagull", value: 0.2)
        let bird3 = BirdPrediction(name: "Swallow", value: 0.0000005)
        let testData: [BirdPrediction] = [bird1, bird2, bird3]

        let filteredData = BirdPrediction.filterArray(testData)

        XCTAssertTrue(filteredData.contains { $0 == bird1 }, "Filtered data should contain \(bird1)")
        XCTAssertTrue(filteredData.contains { $0 == bird2 }, "Filtered data should contain \(bird2)")
        XCTAssertFalse(filteredData.contains { $0 == bird3 }, "Filtered data should not contain \(bird3)")
    }

    func test_filterSortsArrayCorrectly() {
        let bird1 = BirdPrediction(name: "Eagle", value: 0.5)
        let bird2 = BirdPrediction(name: "Seagull", value: 0.2)
        let bird3 = BirdPrediction(name: "Moorhen", value: 0.1)

        let testData: [BirdPrediction] = [bird2, bird3, bird1]

        let filteredData = BirdPrediction.filterArray(testData)

        XCTAssertEqual(filteredData[0], bird1)
        XCTAssertEqual(filteredData[1], bird2)
        XCTAssertEqual(filteredData[2], bird3)
    }
}
