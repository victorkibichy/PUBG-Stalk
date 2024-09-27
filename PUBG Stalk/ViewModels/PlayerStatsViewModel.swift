//
//  PlayerStatsViewModel.swift
//  PUBG Stalk
//
//  Created by  Bouncy Baby on 9/27/24.
//

import Foundation
import Combine

class PlayerStatsViewModel: ObservableObject {
    @Published var playerStats: PlayerStats? // The stats data to be displayed
    @Published var isLoading: Bool = false   // Loading state
    @Published var errorMessage: String?     // Error message for any network issues
    
    private var cancellables = Set<AnyCancellable>()
    private let pubgService = PUBGService()  // Instance of the API service

    // Fetch stats for a given username
    func fetchPlayerStats(for username: String) {
        isLoading = true
        errorMessage = nil

        pubgService.fetchPlayerStats(for: username)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .finished:
                    break
                }
            } receiveValue: { stats in
                self.playerStats = stats
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
}
