//
//  BirdTestImages.swift
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

enum TestBirdImage {
    static var eurasianJay: URL {
        BundleClass().bundle.url(forResource: "eurasian_jay", withExtension: "jpg")!
    }

    static var kakapo: URL {
        BundleClass().bundle.url(forResource: "kakapo", withExtension: "jpg")!
    }

    static var osprey: URL {
        BundleClass().bundle.url(forResource: "osprey", withExtension: "jpg")!
    }
}
