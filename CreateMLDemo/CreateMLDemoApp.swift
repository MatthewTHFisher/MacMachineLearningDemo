//
//  CreateMLDemoApp.swift
//
//  Created by Matthew Fisher on 27/04/2023.
//  Copyright © Jaguar Land Rover Ltd 2023 All rights reserved.
//  This software is confidential and proprietary information.
//  

import SwiftUI

@main
struct CreateMLDemoApp: App {

    @State var selectedTab: NavigationTab = .birdImage

    var body: some Scene {
        WindowGroup {
            AppTabView(selectedTab: $selectedTab)
        }.commands {
            SidebarCommands()
        }
    }
}


/// The available sidebar tabs used within the app
enum NavigationTab: Int, CaseIterable, Codable {
    case birdImage
    case handGesture

    var icon: Image {
        switch self {
        case .birdImage:
            return Image(systemName: "bird.fill")
        case .handGesture:
            return Image(systemName: "hand.raised.fill")
        }
    }

    var title: String {
        switch self {
        case .birdImage:
            return "Bird Image Classification"
        case .handGesture:
            return "Hand Pose Identification"
        }
    }
}
