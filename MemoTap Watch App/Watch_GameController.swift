//
//  Watch_GameController.swift
//  MemoTap Watch App
//
//  Created by Victor Reis on 07/08/2024.
//

import SwiftUI

// Controller to manage game logic and state
class GameController: ObservableObject {
    @Published var model: GameModel // Game model to manage cards and game state
    @Published var score: Int = 0 // Score to track game progress
    
    // Initialize the game controller with a game model
    init(model: GameModel) {
        self.model = model
    }
    
    // Handle card flip action
    func flipCard(_ cardId: UUID) {
        model.flipCard(cardId) // Flip the card in the model
    }
    
    // Reset the game to initial state
    func resetGame() {
        model.reset() // Reset the model
        score = 0 // Reset the score
    }
}

