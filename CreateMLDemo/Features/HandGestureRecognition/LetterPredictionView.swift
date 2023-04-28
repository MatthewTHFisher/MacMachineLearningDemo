//
//  LetterPredictionView.swift
//  HandGestureASLRecognition
//
//  Created by Matthew Fisher on 27/04/2023.
//

import SwiftUI

struct LetterPredictionView: View {
    let letter: String
    var prediction: CGFloat
    var isActive: Bool
    var showPredictionText = true
    static let height: CGFloat = 22

    var visualBarPrediction: CGFloat {
        guard prediction > 0.05 else { return 0 }
        return prediction
    }

    init(
        letter: String,
        prediction: CGFloat,
        isActive: Bool = false
    ) {
        self.letter = letter
        self.prediction = prediction
        self.isActive = isActive
    }

    var body: some View {
        HStack(spacing: 0) {
            Text(letter)
                .lineLimit(1)
                .font(.system(size: Self.height))
                .padding(.trailing, 5)
                .fixedSize()
            CapsuleFillBar(percentage: visualBarPrediction)
                .frame(width: 8, height: Self.height)
            if showPredictionText {
                Text(String(format: "%.1f%%", prediction * 100))
                    .font(.system(size: 8))
                    .lineLimit(1)
                    .rotationEffect(Angle(degrees: 90))
                    .padding(.trailing, -3)
                    .frame(width: 25)
                    .fixedSize()
            }
        }
        .padding(8)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isActive ? .green : .clear, lineWidth: 2)
        )
    }
}

struct LetterPredictionView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            LetterPredictionView(letter: "A", prediction: 0.0)
            LetterPredictionView(letter: "B", prediction: 0.3)
            LetterPredictionView(letter: "C", prediction: 0.5)
            LetterPredictionView(letter: "D", prediction: 0.9, isActive: true)
            LetterPredictionView(letter: "E", prediction: 1.0, isActive: true)
        }
    }
}
