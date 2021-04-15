//
//  ContentView.swift
//  Memorize
//
//  Created by Tarlan Askaruly on 04.04.2021.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            Text("Theme: \(viewModel.themeType.name)")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.red)
                .padding(.top)
            
            Text("Score: \(viewModel.points)")
                .font(.callout)
                .foregroundColor(.red)
                
            
            Grid(viewModel.cards) { card in
                CardView(card: card, cardColor: viewModel.themeType.color).onTapGesture {
                    withAnimation(.linear){
                        self.viewModel.choose(card: card)
                    }
                }
                    .padding()
            }
            
            Button(action: {
                withAnimation(.easeInOut) {
                    self.viewModel.resetGame()
                }
            }) {
                HStack {
                    Image(systemName: "gobackward")
                    Text("New Game")
                        .fontWeight(.bold)
                }
                    .padding()
                    .font(.title)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(40)
            }
            
        }
    }
    
    var large: Font = Font.largeTitle
    var small: Font = Font.caption
     
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let theme = Theme.clothes
        let game = EmojiMemoryGame(theme: theme)
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
        //EmojiMemoryGame(theme: theme)
    }
}

