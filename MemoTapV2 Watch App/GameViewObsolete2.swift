////
////  GameView.swift
////  MemoTapV2 Watch App
////
////  Created by Victor Reis on 11/08/2024.
////
//
//import SwiftUI
//import UIKit
//
//struct GameViewObsolete2: View {
//    @State private var cards: [Card] = [] // Assume there is a Card struct defined elsewhere
//    @State private var firstSelectedCardIndex: Int?
//    @State private var secondSelectedCardIndex: Int?
//
//    var body: some View {
//        VStack {
//            Text("Match the Emojis!")
//                .font(.headline)
//                .padding()
//
//            let columns = Array(repeating: GridItem(.flexible()), count: getColumnCount())
//
//            LazyVGrid(columns: columns, spacing: 10) {
//                ForEach(cards.indices, id: \.self) { index in
//                    CardView(card: cards[index], cardBack: "cardBack")
//                        .onTapGesture {
//                            cardTapped(at: index)
//                        }
//                        .frame(width: 70, height: 100)
//                }
//            }
//            .padding()
//        }
//        .onAppear(perform: setupGame)
//    }
//
//    private func getColumnCount() -> Int {
//        let screenWidth = UIScreen.main.bounds.width // Get screen width
//        let cardWidth: CGFloat = 75
//        let spacing: CGFloat = 10
//        return Int(screenWidth / (cardWidth + spacing))
//    }
//
//    private func setupGame() {
//        // Insert logic to setup cards
//    }
//
//    private func cardTapped(at index: Int) {
//        // Insert logic for card tap
//    }
//}
