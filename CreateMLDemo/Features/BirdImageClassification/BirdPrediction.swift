//
//  BirdPrediction.swift
//  CreateMLDemo
//
//  Created by Matthew Fisher on 30/04/2023.
//

import Foundation

struct BirdPrediction: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var value: Double

    static func fromDict(dictionary: [String: Double]) -> [Self] {
        dictionary.compactMap { Self(name: $0.key, value: $0.value) }
    }

    static func filterArray(_ input: [Self]) -> [Self] {
        input
            .filter { $0.value > 0.0001 }
            .sorted { (lhs: Self, rhs: Self) -> Bool in
                lhs.value > rhs.value
            }
    }
}
