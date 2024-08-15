//
//  GameMenuView.swift
//  MemoTapV2 Watch App
//
//  Created by Victor Reis on 11/08/2024.
//

import SwiftUI // Import the SwiftUI framework

// Define the GameMenuView struct conforming to the View protocol
struct GameMenuView: View {
    // Body property that defines the view's content
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.white.opacity(0.5)]),
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all) // Make gradient fill the entire screen

            VStack { // Vertical stack to arrange elements
                // Title of the game menu
                Text("MEMORY TIME\n     😜👩‍🎤🎮🏆 ")
                    .font(.system(size: 20))
                    // Title font style
                    .foregroundColor(.primary) // Use primary color for better readability
                    .padding() // Padding around the text

                // Navigation Link to LevelSelectionView
                NavigationLink(destination: LevelSelectionView()) {
                    // Play button
                    HStack {
                        Image(systemName: "play.fill") // Add the play icon
                            .font(.caption) // Icon size
                        Text("Play") // Button label
                            .font(.caption) // Font style for button text
                    }
                    .font(.headline) // Button font style
                    .padding(20) // Padding for button icon
                    .background(Color.blue) // Blue background for the button
                    .foregroundColor(.white) // White icon color
                    .clipShape(Capsule()) // Make the button circular
                }
                .buttonBorderShape(.roundedRectangle(radius: 6))
                .buttonStyle(PlainButtonStyle())
                
                .padding(.top) // Padding at the top of the button
            }
            .padding() // Padding for the entire view
        }
    }
}

struct GameMenuView_Previews: PreviewProvider {
    static var previews: some View {
        GameMenuView()
    }
}
