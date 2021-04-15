//
//  MemoryGame.swift
//  Memorize
//
//  Created by Tarlan Askaruly on 07.04.2021.
//

import Foundation

struct MemoryGame<CardValue> where CardValue: Equatable {
    private(set) var cards: Array<Card>
    private(set) var points: Int = 0
    private(set) var failedCards: Set<Int> = Set<Int>()
    
    private var indexOfFaceUpCard: Int? {
        get {
            cards.indices.filter {cards[$0].isFaceUp}.only
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    mutating func choose(card: Card) {
        print(card)
        if let chosedIndex = cards.firstIndex(matching: card), !cards[chosedIndex].isFaceUp, !cards[chosedIndex].isMatched {
            if let potentialMatchIndex = indexOfFaceUpCard {
                if cards[chosedIndex].value == cards[potentialMatchIndex].value {
                    cards[chosedIndex].isMatched = true
                    cards[indexOfFaceUpCard!].isMatched = true
                    points += 2
                    if cards[chosedIndex].bonusRemaining > 0 || cards[potentialMatchIndex].bonusRemaining > 0 {
                        points += 1
                    }
                }
                else {
                    if failedCards.contains(chosedIndex) {
                        points -= 1
                    }
                    if failedCards.contains(potentialMatchIndex) {
                        points -= 1
                    }
                    failedCards.insert(chosedIndex)
                    failedCards.insert(potentialMatchIndex)
                }
                self.cards[chosedIndex].isFaceUp = true
            }
            else {
                indexOfFaceUpCard = chosedIndex
            }
        }
    }
    
    init(numberOfPairsOfCards: Int, cardValueFactory: (Int) -> CardValue) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardValueFactory(pairIndex)
            cards.append(Card(id: pairIndex * 2, value: content))
            cards.append(Card(id: pairIndex * 2 + 1, value: content))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var id: Int
        var value: CardValue // generic "don't care"type
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                }
                else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime()
                
            }
        }
        
        // MARK: - Bonus Time
        /// It gives bonus points if user matches the card before a certain amount of time during which the card is face up
                
        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
                
        // how long this card has even been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
                
        // the last time this card was turned up (and is still face up)
        var lastFaceUpDate: Date?
                
        // the accumulated time this card has been face up in the past
        /// not incuding the current time it's been face up if it is currently so
        var pastFaceUpTime: TimeInterval = 0
                
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        // % of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
        }
        
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
    }
    
    
    
}
