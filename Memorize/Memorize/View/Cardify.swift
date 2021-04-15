//
//  Cardify.swift
//  Memorize
//
//  Created by Tarlan Askaruly on 15.04.2021.
//

import Foundation
import SwiftUI

struct Cardify: AnimatableModifier {
    private var rotation: Double
    
    init(isFaceUp: Bool, cardColor: Color) {
        rotation = isFaceUp ? 0 : 180
        self.cardColor = cardColor
    }
    
    var isFaceUp: Bool {
        rotation < 90
    }
    var cardColor: Color
    
    var animatableData: Double {
        get {
            return rotation
        }
        set {
            rotation = newValue
        }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                content.transition(.scale)
            }
                .opacity(isFaceUp ? 1 : 0)
            RoundedRectangle(cornerRadius: cornerRadius).fill(cardColor).transition(.identity)
                .opacity(isFaceUp ? 0 : 1)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }
    
    // MARK: -Drawing Constants
    
    private let cornerRadius: CGFloat = 10
    private let edgeLineWidth: CGFloat = 3
}

extension View {
    func cardify(isFaceUp: Bool, cardColor: Color) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, cardColor: cardColor))
    }
}
