//
//  ContentView.swift
//  Set
//
//  Created by Tarlan Askaruly on 16.04.2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: SetGameViewModel = SetGameViewModel()
    @State var showAlert = false
    
    private var gridItems = [
        GridItem(.flexible(minimum: 60)),
        GridItem(.flexible(minimum: 60)),
        GridItem(.flexible(minimum: 60)),
        GridItem(.flexible(minimum: 60))
    ]
    
    init() {
        UINavigationBar.appearance().barTintColor = UIColor.white
     //   viewModel
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.gray, Color.blue.opacity(0.01)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.vertical)
                
                VStack {
                    GeometryReader { geometry in
                        ScrollView {
                            LazyVGrid(columns: gridItems, spacing: 20) {
                                ForEach(viewModel.cards, id: \.id) { card in
                                    CardView(card: card, size: geometry.size).aspectRatio(2/3, contentMode: .fit)
                                        .onTapGesture {
                                            withAnimation(.easeOut){
                                                viewModel.chooseCard(card: card)
                                            }
                                        }
                                        .scaleEffect(card.isSelected ? 1.00 : 0.95)
                                        .transition(.opacity)
                                }
                            }
                            .transition(.slide)
                        }
                    }
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .navigationBarTitle("Set", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Score: \(viewModel.points)")
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            if viewModel.allCardsUsed {
                                showAlert = true
                            }
                            else {
                                withAnimation(.easeInOut){
                                    viewModel.addCards()
                                }
                            }
                        }, label: {
                            Text("Add cards")
                        })
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            withAnimation(.easeOut){
                                viewModel.createGame()
                            }
                        }, label: {
                            Text("New Game")
                        })
                    }
                }
                .padding(20)
            }
        }
        .alert(isPresented: $showAlert, content: {
            Alert(
                title: Text("Warning"),
                message: Text("No more cards left in the deck")
            )
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return ContentView()
    }
}

