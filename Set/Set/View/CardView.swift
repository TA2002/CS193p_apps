//
//  CardView.swift
//  Set
//
//  Created by Tarlan Askaruly on 17.04.2021.
//

import Foundation
import SwiftUI

struct CardView: View {
    var card: SetCard
    var color: Color
    var shape: String = "d"
    var number = 2
    var size: CGSize
    
    init(card: SetCard, size: CGSize) {
        self.card = card
        self.size = size
        switch card.number {
            case .one:
                number = 1
            case .two:
                number = 2
            default:
                number = 3
        }
        switch card.color {
            case .red:
                color = Color.red
            case .yellow:
                color = Color.yellow
            default:
                color = Color.orange
        }
        switch card.shaping {
            case .circle:
                shape = "⊙"
            case .diamond:
                shape = "⟐"
            default:
                shape = "⟁"
        }
    }
    
    var body: some View {
        ZStack {
            Rectangle()
            Text("\(String(repeating: shape + "\n", count: number - 1) + shape)")
                .foregroundColor(color)
                .fontWeight(.bold)
                .font(Font.system(size: fontSize(size: self.size)))
        }
        .foregroundColor(card_bg_color)
        .border((card.isSelected ? border_color : border_color.opacity(0)), width: border_width)
        .shadow(radius: shadow_radius)
    }
    
    // MARK: -Drawing Constants
    
    func fontSize(size: CGSize) -> CGFloat {
        let fontSizeFactor: CGFloat
        switch number {
        case 1:
            fontSizeFactor = 0.15
        case 3:
            fontSizeFactor = 0.075
        default:
            fontSizeFactor = 0.1
        }
        return min(size.height, size.width) * fontSizeFactor
    }
    
    let shadow_radius: CGFloat = 2
    let border_width: CGFloat = 2
    let border_color = Color.blue.opacity(0.7)
    let card_bg_color = Color.white
    
}

