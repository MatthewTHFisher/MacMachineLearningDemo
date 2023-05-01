//
//  SidebarTabs.swift
//  CreateMLDemo
//
//  Created by Matthew Fisher on 28/04/2023.
//

import Foundation
import SwiftUI

/// The available sidebar tabs used within the app
enum SidebarTab: Int, CaseIterable, Codable {
    case introductionToML = 1
    case birdImage = 2
    case handGesture = 3

    var icon: Image {
        switch self {
        case .introductionToML:
            return Image(systemName: "brain.head.profile")

        case .birdImage:
            return Image(systemName: "bird.fill")

        case .handGesture:
            return Image(systemName: "hand.raised.fill")
        }
    }

    var title: String {
        switch self {
        case .introductionToML:
            return "Introduction to ML"
        case .birdImage:
            return "Bird Image Classification"
        case .handGesture:
            return "Hand Pose Identification"
        }
    }
}
