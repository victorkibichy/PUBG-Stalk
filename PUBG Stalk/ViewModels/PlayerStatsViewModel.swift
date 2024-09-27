//
//  PlayerStatsViewModel.swift
//  PUBG Stalk
//
//  Created by  Bouncy Baby on 9/27/24.
//

import Foundation
import Combine

class PlayerStatsViewModel: ObservableObject {
    @Published var playerStats: PlayerAttributes?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    
    func fetchPlayerStats(for username: String) {
        guard !username.isEmpty else {
            self.errorMessage = "Please enter a username."
            return
        }
        
        self.isLoading = true
        self.errorMessage = nil
        
        let urlString = "https://api.pubg.com/shards/pc/players?filter[playerNames]=\(username)" // Adjust the URL based on the API
        guard let url = URL(string: urlString) else {
            self.isLoading = false
            self.errorMessage = "Invalid URL."
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer YOUR_API_KEY", forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.api+json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: PlayerResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = "Failed to fetch player stats: \(error.localizedDescription)"
                case .finished:
                    break
                }
                self.isLoading = false
            }, receiveValue: { [weak self] response in
                self?.playerStats = response.data.first?.attributes
            })
            .store(in: &cancellables)
    }
}
