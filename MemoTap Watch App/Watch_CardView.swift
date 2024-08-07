//
//  Watch_CardView.swift
//  MemoTap Watch App
//
//  Created by Victor Reis on 07/08/2024.
//

import SwiftUI

// View to display a single card
struct CardView: View {
    var card: Card // Card data to display
    
    var body: some View {
        ZStack {
            // Display card face if it is face up
            if card.isFaceUp {
                Image(card.image) // Load image based on card's image property
                    .resizable() // Make the image resizable
                    .scaledToFit() // Scale image to fit within the view
            } else {
                // Display the back of the card if it is face down
                Image("cardBack") // Use the cardBack image for the card back
                    .resizable() // Make the image resizable
                    .scaledToFit() // Scale image to fit within the view
            }
        }
        .frame(width: 50, height: 70) // Set the frame size of the card
        .border(Color.black, width: 1) // Add a black border around the card
    }
}
