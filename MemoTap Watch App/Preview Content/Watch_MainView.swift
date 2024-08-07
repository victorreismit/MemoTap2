//
//  Watch_MainView.swift
//  MemoTap Watch App
//
//  Created by Victor Reis on 07/08/2024.
//

import SwiftUI

// Main view to display the game interface
struct MainView: View {
    @StateObject private var gameModel = GameModel() // Initialize game model
    
    var body: some View {
        VStack {
            Text("MemoTap") // Display the game title
                .font(.headline) // Set the font size
                .padding() // Add padding around the title
            
            // Grid view to display all cards
            GridView(cards: gameModel.cards, onCardTap: { cardId in
                gameModel.flipCard(cardId) // Flip the card when tapped
            })
            
            // Reset button to restart the game
            Button(action: {
                gameModel.reset() // Reset the game when button is pressed
            }) {
                Image(systemName: "arrow.clockwise.circle.fill") // Use a system image for the reset button
                    .font(.title) // Set the font size for the button
            }
            .padding() // Add padding around the reset button
        }
    }
}

// Grid view to display a grid of cards
struct GridView: View {
    var cards: [Card] // Array of cards to display
    var onCardTap: (UUID) -> Void // Callback for card tap events
    
    var body: some View {
        // Create a grid layout for displaying cards
        LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
            ForEach(cards) { card in
                CardView(card: card) // Display the card view
                    .onTapGesture {
                        onCardTap(card.id) // Call the tap callback with the card's ID
                    }
            }
        }
        .padding() // Add padding around the grid
    }
}
