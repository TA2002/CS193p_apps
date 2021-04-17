//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Tarlan Askaruly on 07.04.2021.
//

import Foundation
import SwiftUI

func createCardContent(pairIndex: Int) -> String {
    return ""
}

class EmojiMemoryGame: ObservableObject {
    private var theme: Theme
    @Published private var model: MemoryGame<String> // only view model can view and change the model
    
    private static func createMemoryGame(_ theme: Theme) -> MemoryGame<String> { //
        let emojis: Array<String> = theme.emojis //
        return MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairs, cardValueFactory: { pairIndex in
            emojis[pairIndex]
        })
    }
    
    init(theme: Theme) {
        self.theme = Theme.all.randomElement() ?? Theme.clothes
        model = EmojiMemoryGame.createMemoryGame(theme)
    }
    
    // MARK: - View's access to the model
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    var themeType: Theme {
        return theme
    }
    
    var points: Int {
        return model.points
    }
    
    // MARK: -Intent(s) // user expresses intent to change the model
    
    func choose(card: MemoryGame<String>.Card) {
        //objectWillChange.send()
        model.choose(card: card)
    }
    
    func resetGame() {
        self.theme = Theme.all.randomElement() ?? Theme.clothes
        model = EmojiMemoryGame.createMemoryGame(theme)
    }
    
}
