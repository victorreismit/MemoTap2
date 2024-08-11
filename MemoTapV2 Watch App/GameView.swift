import SwiftUI

struct GameView: View {
    @State private var cards: [Card] = [] // Array to hold card instances
    @State private var firstSelectedCardIndex: Int? // Store first selected card index
    @State private var secondSelectedCardIndex: Int? // Store second selected card index
    @State private var matchedCardIndices: Set<Int> = [] // Track matched card indices
    @State private var showNextLevelAnimation = false // Track next level animation
    @State private var currentLevel: Int // Track the current level (start with the selected level)
    @State private var isAnimatingTransition = false // State to control UI interactions

    let selectedLevel: Int // Initial level selected by the user
    let cardCounts: [Int: Int] = [
        1: 10,
        2: 12,
        3: 14,
        4: 16,
        5: 20
    ]

    // Initializer for GameView
    init(selectedLevel: Int) {
        self.selectedLevel = selectedLevel
        self.currentLevel = selectedLevel // Start at the user-selected level
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    // Current level display
                    HStack {
                        Text("Level: \(currentLevel)")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                        Text("Match the Emojis!")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }

                    ScrollView {
                        let columns = Array(repeating: GridItem(.flexible()), count: getColumnCount(screenWidth: geometry.size.width))

                        LazyVGrid(columns: columns, spacing: 5) {
                            ForEach(cards.indices, id: \.self) { index in
                                let card = cards[index]
                                let isMatchedCard = matchedCardIndices.contains(index)

                                CardView(card: card, cardBack: "cardBack", isMatched: isMatchedCard)
                                    .onTapGesture {
                                        // Only allow tapping if not animating a transition
                                        if !isAnimatingTransition {
                                            cardTapped(at: index)
                                        }
                                    }
                            }
                        }
                        .padding()
                    }
                }

                // Overlay for next level animation
                if showNextLevelAnimation {
                    Color.black.opacity(0.7)
                        .edgesIgnoringSafeArea(.all)
                        .overlay(
                            VStack {
                                Text("Level \(currentLevel)") // Show the correct current level
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()

                                Text("Cards: \(cardCounts[currentLevel] ?? 0)") // Show cards for the current level
                                    .font(.title3)
                                    .foregroundColor(.white)
                            }
                            .opacity(showNextLevelAnimation ? 1 : 0)
                            .transition(.scale) // Choose any other transition
                            .animation(.easeInOut(duration: 0.5), value: showNextLevelAnimation)
                    )
                }
            }
        }
        .onAppear(perform: setupGame) // Call setupGame when the view appears
    }

    private func getColumnCount(screenWidth: CGFloat) -> Int {
        let cardWidth: CGFloat = 35 // Width of each card
        let spacing: CGFloat = 5 // Space between cards
        return Int(screenWidth / (cardWidth + spacing)) // Calculate the column count based on screen width
    }

    private func setupGame() {
        loadCardsForCurrentLevel() // Load cards based on the current level

        // Reset game state
        firstSelectedCardIndex = nil
        secondSelectedCardIndex = nil
        matchedCardIndices.removeAll()
        showNextLevelAnimation = false // Hide the overlay initially
        isAnimatingTransition = false // Ensure interaction is allowed at start
    }

    private func loadCardsForCurrentLevel() {
        let numberOfCards = cardCounts[currentLevel, default: 10]
        let emojiCount = numberOfCards / 2 // Calculate number of pairs of emojis

        let shuffledEmojis = emojiPool.shuffled().prefix(emojiCount)
        var cardEmojis = Array(shuffledEmojis + shuffledEmojis).shuffled()
        cards = cardEmojis.map { Card(emoji: String($0)) } // Create Card instances from emojis
    }

    private func cardTapped(at index: Int) {
        guard !cards[index].isFaceUp, !matchedCardIndices.contains(index) else { return }

        if firstSelectedCardIndex == nil {
            firstSelectedCardIndex = index
            cards[index].isFaceUp = true
        } else if secondSelectedCardIndex == nil {
            secondSelectedCardIndex = index
            cards[index].isFaceUp = true
            
            // Check for a match
            if cards[firstSelectedCardIndex!].emoji == cards[secondSelectedCardIndex!].emoji {
                handleMatchedCards()
            } else {
                handleMismatchedCards()
            }
        }
    }
    
    private func handleMatchedCards() {
        matchedCardIndices.insert(firstSelectedCardIndex!)
        matchedCardIndices.insert(secondSelectedCardIndex!)

        // Check for game completion
        if matchedCardIndices.count == cards.count {
            transitionToNextLevel() // Automatically transition to the next level
        } else {
            resetSelections() // Reset selections if not all cards matched
        }
    }

    private func handleMismatchedCards() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                cards[firstSelectedCardIndex!].isFaceUp = false
                cards[secondSelectedCardIndex!].isFaceUp = false
            }
            resetSelections() // Reset selections after a delay
        }
    }

    private func resetSelections() {
        firstSelectedCardIndex = nil
        secondSelectedCardIndex = nil
    }

    private func transitionToNextLevel() {
        isAnimatingTransition = true // Prevent any card interactions during this transition animation

        // Increase level up to the maximum
        if currentLevel < 5 {
            currentLevel += 1
        } else {
            currentLevel = 1 // Reset to level 1 if max reached
        }

        showNextLevelAnimation = true; // Trigger the overlay animation

        // Setup new game after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            loadCardsForCurrentLevel() // Load new cards for the new level
            resetSelections() // Reset selections for the new game
            showNextLevelAnimation = false; // Hide the overlay
            isAnimatingTransition = false // Re-enable card interactions
        }
    }

    private let emojiPool: [String] = [
        "🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐸",
        "🍏", "🍎", "🍐", "🍊", "🍋", "🍉", "🍇", "🍓", "🍈", "🍌",
        "😀", "😃", "😄", "😁", "😆", "😅", "😂", "🤣", "😜", "😝",
        "👶", "👦", "👧", "👨", "👩", "👴", "👵", "👨‍🎤", "👩‍🎤", "👨‍🏫",
        "🎉", "🏆", "⚽", "🎮", "🎨", "🎭", "🎪", "🐵", "🐧", "🦓",
        "🌼", "🌻", "🌸", "🌹", "🌈", "🍄", "🌮", "🍔", "🍕", "🍣",
        "🍩", "🍪", "🍫", "🥑", "🍉", "🥭", "🍍", "🍓", "🧁", "🍰",
        "🥨", "🍧", "🍦", "🍵", "☕", "🧃", "🍺", "🍕", "🥗", "🥘",
        "🎂", "🎆", "🎇", "💡", "🔥", "💣", "🎈", "🎊", "🎃", "🍭",
        "😍", "😘", "😗", "🤣", "😌", "😒", "😔", "😢", "😤", "😱",
        "🙌", "👏", "👀", "🧡", "💖", "❤️", "💛", "💚", "💙", "💜"
    ]
}
