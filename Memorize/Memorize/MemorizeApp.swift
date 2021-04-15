//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Tarlan Askaruly on 04.04.2021.
//

import SwiftUI

@main
struct MemorizeApp: App {
    var body: some Scene {
        WindowGroup {
            let theme = Theme.clothes
            let game = EmojiMemoryGame(theme: theme)
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
