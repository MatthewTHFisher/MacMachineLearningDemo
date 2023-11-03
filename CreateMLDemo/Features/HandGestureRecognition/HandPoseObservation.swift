//
//  HandPoseObservation.swift
//  CreateMLDemo
//
//  Created by Matthew Fisher on 03/11/2023.
//

import Foundation
import Vision

enum HandPoseObservation {
    static let maximumHandCount: Int = 1

    static func getHandPoses(
        cgImage: CGImage,
        orientation: CGImagePropertyOrientation = .up
    ) throws -> [VNHumanHandPoseObservation] {
        let handler = VNImageRequestHandler(cgImage: cgImage, orientation: orientation)
        return try getHandPose(handler: handler)
    }

    static func getHandPoses(
        cmSampleBuffer: CMSampleBuffer,
        orientation: CGImagePropertyOrientation = .up
    ) throws -> [VNHumanHandPoseObservation] {
        let handler = VNImageRequestHandler(cmSampleBuffer: cmSampleBuffer, orientation: orientation)
        return try getHandPose(handler: handler)
    }

    private static func getHandPose(
        handler: VNImageRequestHandler
    ) throws -> [VNHumanHandPoseObservation] {
        let handPoseRequest = VNDetectHumanHandPoseRequest()
        handPoseRequest.maximumHandCount = Self.maximumHandCount

        try handler.perform([handPoseRequest])

        return handPoseRequest.results ?? []
    }
}
