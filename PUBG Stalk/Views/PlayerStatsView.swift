//
//  PlayerStatsView.swift
//  PUBG Stalk
//
//  Created by Bouncy Baby on 9/27/24.
//

import SwiftUI

struct PlayerStatsView: View {
    @StateObject private var viewModel = PlayerStatsViewModel()
    @State private var username: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar to enter username
                HStack {
                    TextField("Enter Player Username", text: $username)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        viewModel.fetchPlayerStats(for: username)
                    }) {
                        Image(systemName: "magnifyingglass")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
                
                // Loading Indicator
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }
                
                // Error Message
                if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                }
                
                // Display Player Stats
                if let stats = viewModel.playerStats {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            // Username and Player Profile
                            HStack {
                                Text(stats.name)
                                    .font(.largeTitle)
                                    .bold()
                                
                                Spacer()
                                
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(12)
                            
                            // Stats Overview Section
                            VStack(alignment: .leading, spacing: 15) {
                                // You can later map actual stats here once the API provides them
                                HStack {
                                    Text("Shard ID: \(stats.shardId)")
                                    // Add more player stats when available
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(12)
                            
                            // Relationships (Matches, Assets)
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Recent Matches")
                                    .font(.headline)
                                
//                                ForEach(viewModel.playerStats?.matches.data ?? [], id: \.id) { match in
//                                    Text("Match ID: \(match.id)")
//                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(12)
                        }
                        .padding()
                    }
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
