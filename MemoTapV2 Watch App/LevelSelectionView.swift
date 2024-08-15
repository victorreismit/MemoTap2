//
//  LevelSelectionView.swift
//  MemoTapV2 Watch App
//
//  Created by Victor Reis on 11/08/2024.
//

import SwiftUI // Import the SwiftUI framework

// Define the LevelSelectionView struct conforming to the View protocol
struct LevelSelectionView: View {
    // State variable to keep track of the selected level (default is level 1)
    @State private var selectedLevel = 1

    // Body property that defines the view's content
    var body: some View {
        ZStack {
            // Common gradient background
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.white.opacity(0.5)]),
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all) // Make gradient fill the entire screen

            VStack { // Vertical stack for layout

                // Title of the level selection screen
                Text("Select Level") // Optional title
                    .font(.system(size: 20)) // Title font style
                    .foregroundColor(.primary) // Use primary color
                    .padding() // Padding around the title

                // Spacer for added space between title and Picker
                Spacer(minLength: 0.5) // Adjust the spacing as needed

                // Picker for selecting the level
                Picker("", selection: $selectedLevel) {
                    // Loop to create options for levels 1 to 5
                    ForEach(1...5, id: \.self) { level in
                        HStack { // Horizontal stack for level text and arrow
                            Text("Level \(level)") // Display level option
                                .font(.caption) // Smaller font size for Picker options
                                .foregroundColor(.white) // White text color for Picker options

                            // Show arrow down icon for all levels except the last one
                            if level < 5 {
                                Image(systemName: "arrow.down") // Down arrow icon
                                    .font(.system(size: 10)) // Icon size
                                    .foregroundColor(.white) // Icon color
                            }
                        }
                        .tag(level) // Tag for the Picker option
                    }
                }
                .pickerStyle(WheelPickerStyle()) // Use wheel style for better appearance
                .frame(width: 110, height: 50) // Set size of the Picker
                .padding() // Padding around the Picker
                .background(Color.clear) // Clear background for seamless merge with screen background
                .cornerRadius(10) // Rounded corners for aesthetics

                // Navigation Link to start the game
                NavigationLink(destination: GameView(selectedLevel: selectedLevel)) {
                    // Start Game button with play icon
                    Image(systemName: "play.fill") // Play icon
                        .font(.headline) // Button font style
                        .padding(10) // Padding for button icon
                        .background(Color.blue) // Blue background for the button
                        .foregroundColor(.white) // White icon color
                        .clipShape(Circle()) // Make the button circular
                }
                .padding(.top) // Padding at the top of the button
                .buttonStyle(PlainButtonStyle()) // Ensure the button background fits the icon
            }
            .padding() // Padding for the entire view
        }
    }
}

struct LevelSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LevelSelectionView()
    }
}
