//
//  SetGame.swift
//  Set
//
//  Created by Tarlan Askaruly on 16.04.2021.
//

import Foundation

struct SetGame {
    
    private var allCards: [SetCard]
    private(set) var cards: [SetCard]
    private var currentIndex: Int = 0
    
    private var chosedCards: Set<Int>
    private(set) var lastCard: SetCard?
    private(set) var allCardsUsed: Bool
    private(set) var points = 0
    
    init() {
        allCardsUsed = false
        allCards = Array<SetCard>()
        allCards = SetCard.generateSetCards()
        allCards.shuffle()
        cards = []
        for index in currentIndex...currentIndex+11 {
            cards.append(allCards[index])
        }
        currentIndex += 12
        chosedCards = []
    }
    
    mutating func addCards() {
        for index in currentIndex...currentIndex+2 {
            cards.append(allCards[index])
        }
        currentIndex += 3
        if currentIndex == allCards.count {
            allCardsUsed = true
        }
    }

    mutating func chooseCard(card: SetCard) {
        let index: Int? = cards.firstIndex(matching: card)
        cards[index!].isSelected = !cards[index!].isSelected
        if chosedCards.contains(index!) {
            chosedCards.remove(index!)
        }
        else {
            chosedCards.insert(index!)
        }
        checkForCorrectSet()
    }
    
    mutating func checkForCorrectSet() {
        if chosedCards.count == 3 {
            var shapings = Set<SetCard.ShapingOfCards>()
            var colorings = Set<SetCard.ColoringOfCards>()
            chosedCards.forEach { chosedCard in
                cards[chosedCard].isSelected = false
                shapings.insert(cards[chosedCard].shaping)
                colorings.insert(cards[chosedCard].color)
            }
            if shapings.count == 1 && colorings.count == 1 {
                lastCard = cards[chosedCards.first!]
                addPoints(cards.count <= maxCardsForBonus)
                chosedCards.forEach { chosedCard in
                    cards.remove(at: chosedCard)
                }
            }
            else {
                subtractPoints()
            }
            chosedCards = Set<Int>()
        }
    }
    
    mutating func addPoints(_ withBonus: Bool) {
        points += withBonus ? maxPoints : minPoints
    }
    
    mutating func subtractPoints() {
        points -= maxPoints
        points = max(points, 0)
    }
    
    private let maxCardsForBonus = 15
    private let maxPoints = 5
    private let minPoints = 1
    
}
