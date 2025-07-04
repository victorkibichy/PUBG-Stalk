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
    
    // PUBG Color Palette
    private let pubgOrange = Color(red: 1.0, green: 0.6, blue: 0.0)
    private let pubgDarkBlue = Color(red: 0.1, green: 0.15, blue: 0.2)
    private let pubgMediumBlue = Color(red: 0.15, green: 0.2, blue: 0.3)
    private let pubgLightGray = Color(red: 0.9, green: 0.9, blue: 0.9)
    private let pubgDarkGray = Color(red: 0.2, green: 0.2, blue: 0.2)
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [pubgDarkBlue, Color.black]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header with PUBG styling
                    headerView
                    
                    // Main content
                    if viewModel.isLoading {
                        loadingView
                    } else if let errorMessage = viewModel.errorMessage {
                        errorView(errorMessage)
                    } else if let stats = viewModel.playerStats {
                        playerStatsContent(stats)
                    } else {
                        emptyStateView
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: 20) {
            // Title
            HStack {
                Image(systemName: "scope")
                    .font(.title2)
                    .foregroundColor(pubgOrange)
                
                Text("BATTLEGROUNDS")
                    .font(.title)
                    .fontWeight(.black)
                    .foregroundColor(pubgLightGray)
                    .tracking(2)
                
                Spacer()
                
                Image(systemName: "target")
                    .font(.title2)
                    .foregroundColor(pubgOrange)
            }
            
            // Search Section
            HStack(spacing: 15) {
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(pubgOrange)
                        .frame(width: 20)
                    
                    TextField("Enter Player Username", text: $username)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .accentColor(pubgOrange)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(pubgMediumBlue)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(pubgOrange.opacity(0.3), lineWidth: 1)
                        )
                )
                
                Button(action: {
                    viewModel.fetchPlayerStats(for: username)
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [pubgOrange, pubgOrange.opacity(0.8)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(color: pubgOrange.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .scaleEffect(viewModel.isLoading ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: viewModel.isLoading)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 30)
        .background(
            Rectangle()
                .fill(pubgDarkBlue.opacity(0.8))
                .blur(radius: 20)
        )
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .stroke(pubgOrange.opacity(0.3), lineWidth: 4)
                    .frame(width: 60, height: 60)
                
                Circle()
                    .trim(from: 0, to: 0.3)
                    .stroke(pubgOrange, lineWidth: 4)
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(-90))
                    .rotationEffect(.degrees(viewModel.isLoading ? 360 : 0))
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: viewModel.isLoading)
            }
            
            Text("Scanning the battlefield...")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(pubgLightGray.opacity(0.8))
            
            Spacer()
        }
    }
    
    // MARK: - Error View
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(Color.red.opacity(0.8))
            
            Text("Mission Failed")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(pubgLightGray)
            
            Text(message)
                .font(.body)
                .foregroundColor(pubgLightGray.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    // MARK: - Empty State View
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "binoculars.fill")
                .font(.system(size: 80))
                .foregroundColor(pubgOrange.opacity(0.6))
            
            VStack(spacing: 10) {
                Text("Ready to Drop")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(pubgLightGray)
                
                Text("Enter a player username to view their battle statistics")
                    .font(.body)
                    .foregroundColor(pubgLightGray.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
    
    // MARK: - Player Stats Content
    private func playerStatsContent(_ stats: Any) -> some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Player Profile Card
                playerProfileCard(stats)
                
                // Stats Grid
                statsGrid(stats as! PlayerAttributes)
                
                // Recent Matches Section
                recentMatchesSection()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
    }
    
    // MARK: - Player Profile Card
    private func playerProfileCard(_ stats: Any) -> some View {
        VStack(spacing: 20) {
            HStack {
                // Avatar
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [pubgOrange, pubgOrange.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 35))
                        .foregroundColor(.white)
                }
                .shadow(color: pubgOrange.opacity(0.3), radius: 10, x: 0, y: 5)
                
                VStack(alignment: .leading, spacing: 8) {
                    // Use the stats object properties if available, otherwise use placeholder
                    Text(getPlayerName(from: stats))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(pubgLightGray)
                    
                    HStack {
                        Image(systemName: "location.fill")
                            .font(.caption)
                            .foregroundColor(pubgOrange)
                        
                        Text("Region: \(getShardId(from: stats).uppercased())")
                            .font(.subheadline)
                            .foregroundColor(pubgLightGray.opacity(0.8))
                    }
                    
                    HStack {
                        Image(systemName: "clock.fill")
                            .font(.caption)
                            .foregroundColor(pubgOrange)
                        
                        Text("Last Updated: Now")
                            .font(.subheadline)
                            .foregroundColor(pubgLightGray.opacity(0.8))
                    }
                }
                
                Spacer()
                
                // Status Badge
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.green.opacity(0.2))
                        
                        Text("ONLINE")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                    }
                    
                    Spacer()
                }
            }
        }
        .padding(25)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(pubgMediumBlue.opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [pubgOrange.opacity(0.5), pubgOrange.opacity(0.1)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Helper Methods
    private func getPlayerName(from stats: Any) -> String {
        // Try to extract name using reflection or return username as fallback
        if let mirror = Mirror(reflecting: stats).children.first(where: { $0.label == "name" })?.value as? String {
            return mirror
        }
        return username.isEmpty ? "Unknown Player" : username
    }
    
    private func getShardId(from stats: Any) -> String {
        // Try to extract shardId using reflection or return default
        if let mirror = Mirror(reflecting: stats).children.first(where: { $0.label == "shardId" })?.value as? String {
            return mirror
        }
        return "global"
    }
    
    // MARK: - Stats Grid
    private func statsGrid(_ stats: PlayerAttributes) -> some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 15) {
            statCard(title: "MATCHES", value: "---", icon: "gamecontroller.fill")
            statCard(title: "WINS", value: "---", icon: "crown.fill")
            statCard(title: "K/D RATIO", value: "---", icon: "target")
            statCard(title: "RANK", value: "---", icon: "medal.fill")
        }
    }
    
    private func statCard(title: String, value: String, icon: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 25))
                .foregroundColor(pubgOrange)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(pubgLightGray)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(pubgLightGray.opacity(0.7))
                .tracking(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(pubgDarkGray.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(pubgOrange.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - Recent Matches Section
    private func recentMatchesSection() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "clock.arrow.circlepath")
                    .foregroundColor(pubgOrange)
                
                Text("RECENT MATCHES")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(pubgLightGray)
                    .tracking(1)
                
                Spacer()
                
                Text("VIEW ALL")
                    .font(.caption)
                    .foregroundColor(pubgOrange)
                    .fontWeight(.medium)
            }
            
            VStack(spacing: 12) {
                ForEach(0..<3, id: \.self) { index in
                    matchRow()
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(pubgMediumBlue.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(pubgOrange.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
    
    private func matchRow() -> some View {
        HStack {
            // Map icon
            Image(systemName: "map.fill")
                .font(.title3)
                .foregroundColor(pubgOrange)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Erangel - Squad")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(pubgLightGray)
                
                Text("2 minutes ago")
                    .font(.caption)
                    .foregroundColor(pubgLightGray.opacity(0.6))
            }
            
            Spacer()
            
            // Placement badge
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(pubgOrange.opacity(0.2))
                
                Text("#12")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(pubgOrange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(pubgDarkGray.opacity(0.4))
        )
    }
}

struct PlayerStatsView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerStatsView()
    }
}
