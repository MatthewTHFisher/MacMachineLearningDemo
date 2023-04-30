//
//  Strings.swift
//  CreateMLDemo
//
//  Created by Matthew Fisher on 28/04/2023.
//

// swiftlint:disable line_length

import SwiftUI

enum BirdImageClassificationStrings {
    static let introduction: LocalizedStringKey = """

    """

    static let trainingSetup: LocalizedStringKey = """
    When training the model for this demonstartion a total of 47,332 images were used to train, 1,625 to validate, and 1,625 to test machine learning model over a total of 35 iterations. Below is a graph showing the accuracy improvement against the iteration number
    """

    static let useInstructions: LocalizedStringKey = """
    To use the following classification go online, find an image of a bird (preferably one from the list of labels the model can predict) and insert it into the analyser. After inserting the program should automatically analyse the image and report on the predictions it made.
    """
}

// swiftlint:enable line_length
