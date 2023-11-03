//
//  TestASLImages.swift
//  CreateMLDemoTests
//
//  Created by Matthew Fisher on 03/11/2023.
//

import Foundation

private class BundleClass {
    var bundle: Bundle {
        Bundle(for: type(of: self))
    }
}

enum TestASLImages {
    static var cPose: URL {
        BundleClass().bundle.url(forResource: "c_test", withExtension: "jpg")!
    }

    static var wPose: URL {
        BundleClass().bundle.url(forResource: "w_test", withExtension: "jpg")!
    }
}
