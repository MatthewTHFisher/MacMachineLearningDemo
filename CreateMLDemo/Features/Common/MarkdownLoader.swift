//
//  MarkdownLoader.swift
//  CreateMLDemo
//
//  Created by Matthew Fisher on 29/04/2023.
//

import SwiftUI

func loadMarkdownAsString(
    forResource filepath: String,
    withExtension fileExtension: String = "md"
) -> LocalizedStringKey? {
    let filepath = Bundle.main.url(forResource: filepath, withExtension: fileExtension)!
    do {
        return LocalizedStringKey(try String(contentsOf: filepath))
    } catch {
        return nil
    }
}
