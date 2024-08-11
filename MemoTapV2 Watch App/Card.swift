//
//  Card.swift
//  MemoTapV2 Watch App
//
//  Created by Victor Reis on 11/08/2024.
//

import Foundation

struct Card: Identifiable {
    let id = UUID() // Unique identifier for each card
    var emoji: String // The emoji represented by the card
    var isFaceUp: Bool = false // State to check if the card is face up
}
