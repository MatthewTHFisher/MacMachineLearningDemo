//
//  CGImageFromURL.swift
//  CreateMLDemoTests
//
//  Created by Matthew Fisher on 03/11/2023.
//

import Foundation
import SwiftUI

func imageFromURL(url: URL) -> CGImage {
    (NSImage(contentsOf: url)?.cgImage(forProposedRect: nil, context: nil, hints: nil))!
}
