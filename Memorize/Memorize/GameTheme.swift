//
//  GameTheme.swift
//  Memorize
//
//  Created by Tarlan Askaruly on 14.04.2021.
//

import Foundation
import SwiftUI

struct Theme: Identifiable {
    var id = UUID()
    
    var name: String
    var emojis: Array<String>
    var numberOfPairs: Int = 3
    var color: Color
    
    init(name: String, emojis: Array<String>, numberOfPairs: Int, color: Color) {
        self.name = name
        self.emojis = emojis
        self.numberOfPairs = numberOfPairs
        self.color = color
    }
    
    static let halloween = Theme(name: "Halloween", emojis: ["🎃", "👻", "💀", "😈", "🤡"], numberOfPairs: 5, color: .orange)
    static let sports = Theme(name: "Sports", emojis: ["🏈", "🏀", "⚽️", "🥎", "🏓"], numberOfPairs: 3, color: .blue)
    static let clothes = Theme(name: "Clothes", emojis: ["🩳", "👓", "👔", "👕", "👠", "🥾", "🧥"], numberOfPairs: 7, color: .pink)
    static let animals = Theme(name: "Animals", emojis: ["🐶", "🐱", "🐷", "🐻", "🐼"], numberOfPairs: 4, color: .green)
    static let fruits = Theme(name: "Fruits", emojis: ["🍏", "🍋", "🍌", "🍉", "🍇"], numberOfPairs: 4, color: .yellow)
    
    static var all = [halloween, sports, clothes, animals, fruits]
}
