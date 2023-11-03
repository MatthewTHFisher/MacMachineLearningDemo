//
//  CreateMLDemoApp.swift
//
//  Created by Matthew Fisher on 27/04/2023.
//  

import SwiftUI

@main
struct CreateMLDemoApp: App {
    @AppStorage("sidebarTab")
    var selectedTab: SidebarTab = .introductionToML

    var body: some Scene {
        WindowGroup {
            NavigationView {
                SidebarView($selectedTab)

                Group {
                    switch selectedTab {
                    case .introductionToML:
                        EmptyView()

                    case .birdImage:
                        BirdImageClassification()

                    case .handGesture:
                        HandGestureView()
                    }
                }
            }
        }.commands {
            SidebarCommands()
        }
    }
}
