//
//  CardView.swift
//  Memorize
//
//  Created by Tarlan Askaruly on 14.04.2021.
//

import SwiftUI

struct CardView: View {
    var card: MemoryGame<String>.Card
    var cardColor: Color
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle.degrees(0 - 90), endAngle: Angle.degrees(-animatedBonusRemaining * 360 - 90), clockwise: true)
                            .onAppear() {
                                startBonusTimeAnimation()
                            }
                    }
                    else {
                        Pie(startAngle: Angle.degrees(0 - 90), endAngle: Angle.degrees(-card.bonusRemaining * 360 - 90), clockwise: true)
                    }
                }
                    .padding(5)
                    .opacity(0.4)
                Text(card.value)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
            }
                .cardify(isFaceUp: card.isFaceUp, cardColor: cardColor)
                .foregroundColor(cardColor)
                .transition(.scale)
        }
    }
    
    // MARK: -Drawing Constants
    
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.6
    }

        
}
