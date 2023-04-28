//
//  SidebarView.swift
//
//  Created by Matthew Fisher on 27/04/2023.
//  Copyright © Jaguar Land Rover Ltd 2023 All rights reserved.
//  This software is confidential and proprietary information.
//

import SwiftUI

struct SidebarView: View {

    /// The tab being hovered over by the cursor
    @State var hoveredTab: NavigationTab?
    /// The current selected tab for the app
    @Binding var selectedTab: NavigationTab

    /// The foreground color for a tab
    private func tabForegroundColor(_ tab: NavigationTab) -> Color {
        return selectedTab == tab ? Color(NSColor.windowBackgroundColor) : (hoveredTab == tab ? Color.primary : Color.primary )
    }

    init(_ selectedTab: Binding<NavigationTab>) {
        self._selectedTab = selectedTab
    }

    var body: some View {
        VStack {
            List {
                ForEach(NavigationTab.allCases, id: \.self) { tab in
                    HStack(alignment: .center, spacing: 0) {
                        tab.icon
                            .frame(width: 24)
                            .foregroundColor(tabForegroundColor(tab))
                            .padding(.trailing, 10)

                        Text(tab.title)
                            .foregroundColor(tabForegroundColor(tab))

                        Spacer()
                    }
                    .padding(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
                    .background(
                        // Rectangle to display around the selected tab
                        RoundedRectangle(cornerRadius: 10)
                            .fill(selectedTab == tab ? Color.accentColor : Color.clear)
                    )
                    .onTapGesture {
                        // When a tab is selected update the selectedTab binding
                        self.selectedTab = tab
                    }
                    .onHover { hover in
                        // When a tab is hovered store it
                        self.hoveredTab = hover ? tab : nil
                    }
                }
            }
            .listStyle(SidebarListStyle())

            Spacer()

            // Add a credits view to the bottom of the Sidebar
            CreditsView()
        }
        .padding(.vertical, 15)
        .frame(minWidth: 250)
    }

    struct CreditsView: View {
        var body: some View {
            HStack {
                Spacer()
                VStack {
                    Text("Create ML Demo \nby Matthew Fisher")
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .font(.caption)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .foregroundColor(Color.secondary)
                Spacer()
            }
        }
    }
}
