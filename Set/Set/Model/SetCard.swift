//
//  SetCard.swift
//  Set
//
//  Created by Tarlan Askaruly on 16.04.2021.
//

import Foundation

struct SetCard: Identifiable, Hashable {
    var id = UUID()
    
    var number: NumberOfCards
    var shaping: ShapingOfCards
    var color: ColoringOfCards
    
    var isSelected: Bool = false
    //var isMatched: Bool = false
    
    init(number: NumberOfCards, shaping: ShapingOfCards, color: ColoringOfCards) {
        self.number = number
        self.shaping = shaping
        self.color = color
    }
    
    static func generateSetCards() -> [Self] {
        var cards = [Self]()
        
        for number in NumberOfCards.allCases {
            for coloring in ColoringOfCards.allCases {
                for shaping in ShapingOfCards.allCases {
                    cards.append(Self.init(number: number, shaping: shaping, color: coloring))
                }
            }
        }
        
        return cards
        
    }
    
    enum NumberOfCards: CaseIterable {
        case one, two, three
    }
    
    enum ColoringOfCards: CaseIterable {
        case red, yellow, orange
    }
    
    enum ShapingOfCards: CaseIterable {
        case diamond, pyramid, circle
    }
    
}
