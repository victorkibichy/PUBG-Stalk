//
//  PlayerStatsView.swift
//  PUBG Stalk
//
//  Created by  Bouncy Baby on 9/27/24.
//

import SwiftUI

struct PlayerStatsView: View {
    @StateObject private var viewModel = PlayerStatsViewModel() // Initialize the ViewModel
    @State private var username: String = ""                    // The username to search for
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar to enter username
                TextField("Enter Player Username", text: $username)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Fetch Button
                Button(action: {
                    viewModel.fetchPlayerStats(for: username)
                }) {
                    Text("Fetch Stats")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                // Loading Indicator
                if viewModel.isLoading {
                    ProgressView()
                }
                
                // Error Message
                if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                }
                
                // Display Player Stats
                if let stats = viewModel.playerStats {
                    VStack(alignment: .leading) {
                        Text("Username: \(stats.username)")
                        Text("Kills: \(stats.kills)")
                        Text("Wins: \(stats.wins)")
                        Text("Matches Played: \(stats.matchesPlayed)")
                        Text("K/D Ratio: \(stats.kdRatio)")
                    }
                    .padding()
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("PUBG Player Stats")
        }
    }
}


struct PlayerStatsView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerStatsView()
    }
}
