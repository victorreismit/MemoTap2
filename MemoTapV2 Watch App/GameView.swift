import SwiftUI

// Main game view
struct GameView: View {
    @State private var cards: [Card] = [] // Array holding the cards
    @State private var firstSelectedCardIndex: Int? // Index of the first selected card
    @State private var secondSelectedCardIndex: Int? // Index of the second selected card
    @State private var matchedCardIndices: Set<Int> = [] // Set of matched card indices
    @State private var currentLevel: Int // Tracks the current level
    @State private var isTransitioning = false // Prevents interaction during transitions
    @State private var showCongratsMessage = false // Flag to control visibility of "Congrats!" message
    @State private var nextLevel: Int? // Holds next level information

    // Level configuration for number of cards per level
    let selectedLevel: Int
    let cardCounts: [Int: Int] = [
        1: 10, // Level 1 includes 10 cards
        2: 12,
        3: 14,
        4: 16,
        5: 20 // Level 5 includes 20 cards
    ]

    // Initializing the GameView with a selected level
    init(selectedLevel: Int) {
        self.selectedLevel = selectedLevel
        self.currentLevel = selectedLevel // Start at selected level
    }

    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.white.opacity(0.5)]),
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all) // Extend the gradient to cover the full screen
            
            GeometryReader { geometry in
                VStack(spacing: 0) { // Minimize spacing to eliminate gaps
                    // Display the current level and instruction
                    HStack {
                        Text("Level: \(currentLevel)")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                        Spacer() // Separate contents
                        Text("Match the Emojis!")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 5) // Optional: small padding at the top

                    // Cards displayed in a scroll view
                    ScrollView {
                        // Determine number of columns based on screen width
                        let columns = Array(repeating: GridItem(.flexible()), count: getColumnCount(screenWidth: geometry.size.width))

                        LazyVGrid(columns: columns, spacing: 5) {
                            ForEach(cards.indices, id: \.self) { index in
                                let card = cards[index]
                                let isMatchedCard = matchedCardIndices.contains(index)

                                // CardView to display cards
                                CardView(card: card, cardBack: "cardBack", isMatched: isMatchedCard)
                                    .onTapGesture {
                                        cardTapped(at: index)
                                    }
                            }
                        }
                        .padding(.horizontal) // Add padding around the grid
                    }
                    .frame(maxHeight: .infinity) // Allow ScrollView to take up all available height

                    // Display congratulations message when all cards matched
                    if showCongratsMessage {
                        VStack {
                            Text("Congrats!")
                                .font(.title3) // Larger font for message
                                .bold() // Bold text
                                .transition(.opacity) // Transition effect for fading in
                                .animation(.easeInOut(duration: 0.3)) // Smooth animation
                                .padding(.vertical, 0)

                            if let nextLevel = nextLevel {
                                Text("Next Level: \(nextLevel)") // Show next level
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                    .padding(.top, 0) // Ensure no extra top padding
                            }
                        }
                        .padding(.horizontal)
                        .background(Color.black.opacity(0.8)) // Background for emphasis
                        .cornerRadius(10) // Rounded corners
                        .shadow(radius: 5) // Shadow for depth
                    }
                }
            }
        }
        .onAppear(perform: setupGame) // Set up the game when the view appears
    }

    // Function to determine the number of columns based on screen width
    private func getColumnCount(screenWidth: CGFloat) -> Int {
        let cardWidth: CGFloat = 35 // Fixed width of the card
        let spacing: CGFloat = 5 // Spacing between cards
        return Int(screenWidth / (cardWidth + spacing)) // Calculate number of columns
    }

    // Function to setup the game
    private func setupGame() {
        loadCardsForCurrentLevel() // Load cards based on level
        resetSelections() // Reset selections for new game
        flipAllCards() // Show all cards face up for a moment
    }

    // Load cards based on the current level
    private func loadCardsForCurrentLevel() {
        let numberOfCards = cardCounts[currentLevel, default: 10] // Get count for level
        let emojiCount = numberOfCards / 2 // Duplicate each emoji
        let shuffledEmojis = emojiPool.shuffled().prefix(emojiCount) // Shuffle and select unique emojis
        var cardEmojis = Array(shuffledEmojis + shuffledEmojis).shuffled() // Create the cards
        cards = cardEmojis.map { Card(emoji: String($0)) } // Map to Card model

        // Reset all cards to face down
        for index in cards.indices {
            cards[index].isFaceUp = false
        }
        matchedCardIndices.removeAll() // Clear matched indices
    }

    // Flip all cards face up for 2 seconds, then wait for another 2 seconds before flipping them back down
    private func flipAllCards() {
        // Flip all cards face up
        withAnimation(.easeInOut(duration: 0.7)) {
            for index in cards.indices {
                cards[index].isFaceUp = true // Show all cards face up
            }
        }

        // Wait for 2 seconds and then flip back down
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut(duration: 0.7)) {
                for index in cards.indices {
                    cards[index].isFaceUp = false // Return to face down
                }
            }
        }
    }

    // Function handling card taps
    private func cardTapped(at index: Int) {
        guard !isTransitioning, !cards[index].isFaceUp, !matchedCardIndices.contains(index) else { return }

        if firstSelectedCardIndex == nil {
            // First card tapped
            firstSelectedCardIndex = index // Save index of the first tapped card
            cards[index].isFaceUp = true // Show the card face up
        } else if secondSelectedCardIndex == nil {
            // Second card tapped
            secondSelectedCardIndex = index // Save index of the second tapped card
            cards[index].isFaceUp = true // Show the card face up
            
            // Check if the cards match
            if cards[firstSelectedCardIndex!].emoji == cards[secondSelectedCardIndex!].emoji {
                handleMatchedCards() // Handle matched cards
            } else {
                handleMismatchedCards() // Handle unmatched cards
            }
        }
    }

    // Handle if two cards match
    private func handleMatchedCards() {
        matchedCardIndices.insert(firstSelectedCardIndex!) // Add first index
        matchedCardIndices.insert(secondSelectedCardIndex!) // Add second index

        // Check if all cards are matched
        if matchedCardIndices.count == cards.count {
            showCongratsMessage = true // Show congrats message
            nextLevel = (currentLevel < 5) ? currentLevel + 1 : 1 // Determine the next level
            
            // Delay to show the congrats message before transitioning
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                transitionToNextLevel() // Transition to next level
            }
        } else {
            resetSelections() // Reset selections
        }
    }

    // Handle if cards do not match
    private func handleMismatchedCards() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Corrected usage here
            cards[firstSelectedCardIndex!].isFaceUp = false // Flip first card back
            cards[secondSelectedCardIndex!].isFaceUp = false // Flip second card back
            resetSelections() // Reset selections
        }
    }

    // Reset selection indices
    private func resetSelections() {
        firstSelectedCardIndex = nil // Clear index for first selection
        secondSelectedCardIndex = nil // Clear index for second selection
    }

    // Transition to the next level
    private func transitionToNextLevel() {
        isTransitioning = true // Set transitioning flag

        // Load new cards for the next level
        loadCardsForCurrentLevel() // Load new cards

        // Show all cards face up for 2 seconds
        flipAllCards() // Show all cards face up

        // After cards are displayed, allow interactions again
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Wait until the flipping back animation is done
            showCongratsMessage = false // Hide Congrats message
            nextLevel = nil // Reset next level information
            isTransitioning = false // Allow interactions again
            resetSelections() // Reset selections
        }
    }

    // Pool of emojis available for game
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
