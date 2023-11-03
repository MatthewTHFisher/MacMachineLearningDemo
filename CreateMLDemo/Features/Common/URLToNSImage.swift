//
//  URLToNSImage.swift
//  CreateMLDemo
//
//  Created by Matthew Fisher on 03/11/2023.
//

import SwiftUI

func urlToNSImage(
    _ url: URL
) throws -> NSImage? {
    let imageData = try Data(contentsOf: url)
    guard let nsImage = NSImage(data: imageData) else {
        print("Image data could not be loaded")
        return nil
    }
    return nsImage
}
