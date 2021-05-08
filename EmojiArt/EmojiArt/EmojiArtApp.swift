//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Tarlan Askaruly on 18.04.2021.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: EmojiArtDocument())
        }
    }
}
