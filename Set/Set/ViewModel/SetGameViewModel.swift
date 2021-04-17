//
//  SetGameViewModel.swift
//  Set
//
//  Created by Tarlan Askaruly on 16.04.2021.
//

import Foundation
import SwiftUI

class SetGameViewModel: ObservableObject {
    @Published private var model: SetGame
    
    private static func createSetGame() -> SetGame {
        return SetGame()
    }
    
    init() {
        model = SetGameViewModel.createSetGame()
    }
    
    var cards: [SetCard] {
        model.cards
    }
    
    var allCardsUsed: Bool {
        model.allCardsUsed
    }
    
    var points: Int {
        model.points
    }
    
    func addCards() {
        model.addCards()
    }
    
    func chooseCard(card: SetCard) {
        model.chooseCard(card: card)
    }
    
    func createGame() {
        model = SetGameViewModel.createSetGame()
    }
    
}
