//
//  CapsuleFillBar.swift
//  CreateMLDemo
//
//  Created by Matthew Fisher on 28/04/2023.
//

import SwiftUI

struct CapsuleFillBar: View {
    var percentage: CGFloat
    static let minimumPixelsToPlot: CGFloat = 5
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: geo.size.width < geo.size.height ? .bottom : .leading) {
                Capsule().fill(Color.gray.opacity(0.7))

                if geo.size.width < geo.size.height, geo.size.height * percentage > Self.minimumPixelsToPlot {
                    Capsule().fill(Color.green)
                        .frame(height: geo.size.height * percentage)
                } else if geo.size.width * percentage > Self.minimumPixelsToPlot {
                    Capsule().fill(Color.green)
                        .frame(width: geo.size.width * percentage)
                }
            }
        }
    }
}

struct CapsuleFillBar_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 10) {
            CapsuleFillBar(percentage: 0.0)
            CapsuleFillBar(percentage: 0.25)
            CapsuleFillBar(percentage: 0.5)
            CapsuleFillBar(percentage: 0.75)
            CapsuleFillBar(percentage: 1.0)
        }
        .padding()
    }
}
