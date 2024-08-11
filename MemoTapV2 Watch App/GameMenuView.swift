//
//  GameMenuView.swift
//  MemoTapV2 Watch App
//
//  Created by Victor Reis on 11/08/2024.
//

import SwiftUI // Import the SwiftUI framework

// Define the GameMenuView struct conforming to the View protocol
struct GameMenuView: View {
    // State variable to keep track of the selected level (default is level 1)
    @State private var selectedLevel = 1

    // Body property that defines the view's content
    var body: some View {
        VStack { // Vertical stack to arrange elements
            // Title of the game menu
            Text("Memory Game")
                .font(.headline) // Title font style
                .padding() // Padding around the text

            // Level selection text
            Text("Select Level:")
                .font(.subheadline) // Subtitle font style

            // Picker for selecting the level
            Picker("", selection: $selectedLevel) {
                // Loop to create options for levels 1 to 5
                ForEach(1...5, id: \.self) { level in
                    Text("Level \(level)").tag(level) // Display level option with tag
                        .font(.caption2) // Font size for the Picker options
                }
            }
            .pickerStyle(WheelPickerStyle()) // Use wheel style for better appearance
            .frame(width: 75, height: 30) // Set size of the Picker
            .padding() // Padding around the Picker
            .background(Color.gray.opacity(0.1)) // Light gray background color
            .cornerRadius(10) // Rounded corners for aesthetics

            // Navigation Link to move to the GameView with the selected level
            NavigationLink(destination: GameView(selectedLevel: selectedLevel)) {
                // Start Game button
                Text("Start Game")
                    .font(.headline) // Font style for button text
                    .frame(maxWidth: .infinity) // Button takes full width
                    .padding() // Padding around button text
                    .background(Color.blue) // Blue background for the button
                    .foregroundColor(.white) // White text color
                    .cornerRadius(10) // Rounded corners for the button
            }
            .padding(.top) // Padding at the top of the button
        }
        .padding() // Padding for the entire view
    }
}
