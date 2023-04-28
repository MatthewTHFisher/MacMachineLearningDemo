//
//  ImagePickerButton.swift
//  CreateMLDemo
//
//  Created by Matthew Fisher on 28/04/2023.
//

import SwiftUI

struct ImagePickerButton: View {
    
    let text: String
    @Binding var imageUrl: URL?
    
    init(_ text: String, url: Binding<URL?>) {
        self.text = text
        self._imageUrl = url
    }
    
    var body: some View {
        Button(text) {
            let openPanel = NSOpenPanel()
            openPanel.prompt = "Select Image"
            openPanel.allowsMultipleSelection = false
            openPanel.canChooseDirectories = false
            openPanel.canCreateDirectories = false
            openPanel.canChooseFiles = true
            openPanel.allowedContentTypes = [.png,.jpeg]
            openPanel.begin { (result) -> Void in
                if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                    imageUrl = URL(fileURLWithPath: openPanel.url!.path)
                }
            }
        }
    }
}
