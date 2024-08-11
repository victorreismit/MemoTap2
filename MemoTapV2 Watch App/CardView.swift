//
//  CardView.swift
//  MemoTapV2 Watch App
//
//  Created by Victor Reis on 11/08/2024.
//

import SwiftUI // Import the SwiftUI framework

// Define the CardView struct conforming to the View protocol
struct CardView: View {
    let card: Card // The card object being represented
    let cardBack: String // Image name for the card back
    let isMatched: Bool // Flag to indicate if the card is matched

    // Body property that defines how the card is displayed
    var body: some View {
        ZStack { // Layer cards on top of each other
            // Display card back image when the card is not face up
            if !card.isFaceUp {
                Image(cardBack) // Show the card back image
                    .resizable() // Allow the image to resize
                    .aspectRatio(contentMode: .fit) // Maintain aspect ratio
                    .cornerRadius(10) // Rounded corners for the card back
                    .shadow(radius: 5) // Add shadow for depth
            } else {
                // Display emoji when the card is face up
                Text(card.emoji) // Show the emoji text
                    .font(.system(size: 30)) // Set font size of the emoji
                    .frame(width: 45, height: 65) // Use these smaller dimensions for cards in GameView
                    .background(Color.gray) // White background for the emoji
                    .cornerRadius(10) // Rounded corners for the card face
                    .shadow(radius: 5) // Add shadow for depth
                    .overlay(isMatched ? shineEffect() : nil) // Apply shine effect if card is matched
            }
        }
        .frame(width: 45, height: 65) // Set smaller frame size for the card
        .animation(.interactiveSpring) // Add an animation for smoother transitions
    }
    
    // Function to create a shine effect
    private func shineEffect() -> some View {
        LinearGradient(gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.5), Color.clear]), startPoint: .top, endPoint: .bottom)
            .mask(RoundedRectangle(cornerRadius: 10)) // Apply mask for rounded corners
            .rotationEffect(.degrees(30)) // Set the angle of the shine
            .animation(Animation.linear(duration: 1).repeatForever()) // Shine animation
    }
}
