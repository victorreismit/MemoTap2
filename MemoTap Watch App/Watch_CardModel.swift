//
//  Watch_CardModel.swift
//  MemoTap Watch App
//
//  Created by Victor Reis on 07/08/2024.
//

import Foundation

// Represents a single card in the game
struct Card: Identifiable {
    let id: UUID // Unique identifier for the card
    let image: String // Image name associated with the card
    var isMatched: Bool // Indicates if the card has been matched
    var isFaceUp: Bool // Indicates if the card is face up
}

// Manages the game state and card logic
class GameModel: ObservableObject {
    @Published var cards: [Card] = [] // Array to hold all cards
    private var indexOfOneAndOnlyFaceUpCard: Int? // Index of the currently face-up card, if any
    
    // List of available card front images
    private let frontImages = ["cardFront1", "cardFront2", "cardFront3", "cardFront4", "cardFront5"]
    
    // Initializes the game model with card images
    init() {
        // Create pairs of cards with front images and a card back image
        let cardImages = generateCardImages() // Generate a shuffled list of card images
        // Create a Card instance for each image, with unique IDs
        self.cards = cardImages.map { Card(id: UUID(), image: $0, isMatched: false, isFaceUp: false) }
    }
    
    // Generates a shuffled list of card images
    private func generateCardImages() -> [String] {
        // Create a list of card front images (2 pairs per image)
        var images: [String] = []
        let numberOfPairs = 10 / 2 // For 10 cards, we need 5 pairs
        for i in 0..<numberOfPairs {
            images.append(frontImages[i % frontImages.count])
            images.append(frontImages[i % frontImages.count])
        }
        // Shuffle the images
        return images.shuffled()
    }
    
    // Flip a card by its unique ID
    func flipCard(_ cardId: UUID) {
        // Find the index of the card with the given ID
        if let index = cards.firstIndex(where: { $0.id == cardId }) {
            // Check if the card is already face up or matched
            if cards[index].isFaceUp || cards[index].isMatched {
                return // Card is already face up or matched, do nothing
            }
            
            // Flip the card
            cards[index].isFaceUp = true
            
            // Compare with the previously flipped card
            if let matchIndex = indexOfOneAndOnlyFaceUpCard {
                // Check for a match
                if cards[matchIndex].image == cards[index].image {
                    // Found a match, mark cards as matched
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                } else {
                    // No match, flip both cards back after a short delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.cards[matchIndex].isFaceUp = false
                        self.cards[index].isFaceUp = false
                    }
                }
                // Reset the index of the face-up card
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                // No previously flipped card, save the current card index
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    // Reset all cards to face down and unmatched
    func reset() {
        // Iterate over the indices of the cards array
        for index in cards.indices {
            // Access each card by its index and update its properties
            cards[index].isFaceUp = false
            cards[index].isMatched = false
        }
        // Clear the index of the face-up card
        indexOfOneAndOnlyFaceUpCard = nil
    }
}
