//
//  DocumenationText.swift
//  CreateMLDemo
//
//  Created by Matthew Fisher on 28/04/2023.
//

import SwiftUI

struct DocumenationText: View {
    let text: LocalizedStringKey

    init(_ text: LocalizedStringKey) {
        self.text = text
    }

    init?(markdown filepath: String, withExtension: String = "md") {
        guard let text = loadMarkdownAsString(forResource: filepath, withExtension: withExtension) else {
            return nil
        }
        self.text = text
    }

    var body: some View {
        Text(text)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 10).fill(Color(nsColor: .textBackgroundColor))
            )
            .padding(20)
    }
}

struct DocumenationText_Previews: PreviewProvider {
    static var previews: some View {
        // swiftlint:disable:next line_length
        DocumenationText("A really long sentence that might explain something or show something off. It is so long that swiftlint needs to disable the line_length rule just to allow this to compile.")
    }
}
