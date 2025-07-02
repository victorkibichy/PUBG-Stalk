//
//  PUBGModels.swift
//  PUBG Stalk
//
//  Data models for PUBG API response
//

import Foundation

// MARK: - Main Response Model
struct PUBGPlayerResponse: Codable {
    let data: PlayerData
    let links: ResponseLinks
    let meta: ResponseMeta
}

// MARK: - Player Data
struct PlayerData: Codable {
    let type: String
    let id: String
    let attributes: PlayerAttributes
    let relationships: PlayerRelationships
    let links: PlayerLinks
}

// MARK: - Player Attributes
struct PlayerAttributes: Codable {
    let name: String
    let shardId: String
    let stats: PlayerStats
    let createdAt: String
    let updatedAt: String
    let patchVersion: String
    let banType: String
    let titleId: String
}

// MARK: - Player Stats
struct PlayerStats: Codable {
    // The stats object can contain various game mode statistics
    // Since the API documentation shows it as an empty object {},
    // we'll make it flexible to handle different stat types
    
    // Common stats that might be present (add as needed based on actual API response)
    let soloFPP: GameModeStats?
    let soloTPP: GameModeStats?
    let duoFPP: GameModeStats?
    let duoTPP: GameModeStats?
    let squadFPP: GameModeStats?
    let squadTPP: GameModeStats?
    
    // Handle unknown keys with a custom decoder if needed
    private enum CodingKeys: String, CodingKey {
        case soloFPP = "solo-fpp"
        case soloTPP = "solo"
        case duoFPP = "duo-fpp"
        case duoTPP = "duo"
        case squadFPP = "squad-fpp"
        case squadTPP = "squad"
    }
    
    // Custom initializer to handle empty stats object
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        
        soloFPP = try? container?.decodeIfPresent(GameModeStats.self, forKey: .soloFPP)
        soloTPP = try? container?.decodeIfPresent(GameModeStats.self, forKey: .soloTPP)
        duoFPP = try? container?.decodeIfPresent(GameModeStats.self, forKey: .duoFPP)
        duoTPP = try? container?.decodeIfPresent(GameModeStats.self, forKey: .duoTPP)
        squadFPP = try? container?.decodeIfPresent(GameModeStats.self, forKey: .squadFPP)
        squadTPP = try? container?.decodeIfPresent(GameModeStats.self, forKey: .squadTPP)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(soloFPP, forKey: .soloFPP)
        try container.encodeIfPresent(soloTPP, forKey: .soloTPP)
        try container.encodeIfPresent(duoFPP, forKey: .duoFPP)
        try container.encodeIfPresent(duoTPP, forKey: .duoTPP)
        try container.encodeIfPresent(squadFPP, forKey: .squadFPP)
        try container.encodeIfPresent(squadTPP, forKey: .squadTPP)
    }
}

// MARK: - Game Mode Stats
struct GameModeStats: Codable {
    let assists: Int?
    let boosts: Int?
    let dBNOs: Int?
    let dailyKills: Int?
    let dailyWins: Int?
    let damageDealt: Double?
    let days: Int?
    let headshotKills: Int?
    let heals: Int?
    let killPoints: Double?
    let kills: Int?
    let longestKill: Double?
    let longestTimeSurvived: Double?
    let losses: Int?
    let maxKillStreaks: Int?
    let mostSurvivalTime: Double?
    let rankPoints: Double?
    let rankPointsTitle: String?
    let revives: Int?
    let rideDistance: Double?
    let roadKills: Int?
    let roundMostKills: Int?
    let roundsPlayed: Int?
    let suicides: Int?
    let swimDistance: Double?
    let teamKills: Int?
    let timeSurvived: Double?
    let top10s: Int?
    let vehicleDestroys: Int?
    let walkDistance: Double?
    let weaponsAcquired: Int?
    let weeklyKills: Int?
    let weeklyWins: Int?
    let winPoints: Double?
    let wins: Int?
}

// MARK: - Player Relationships
struct PlayerRelationships: Codable {
    let assets: RelationshipData
    let matches: MatchesRelationship
}

struct RelationshipData: Codable {
    let data: AnyCodable // Flexible data type
}

struct MatchesRelationship: Codable {
    let data: [MatchReference]
}

struct MatchReference: Codable {
    let id: String
    let type: String
}

// MARK: - Links
struct PlayerLinks: Codable {
    let schema: String
    let `self`: String
}

struct ResponseLinks: Codable {
    let `self`: String
}

// MARK: - Meta
struct ResponseMeta: Codable {
    // Meta can contain additional information
    // Making it flexible since it's shown as empty object {}
}

// MARK: - Flexible Codable Type
struct AnyCodable: Codable {
    let value: Any
    
    init<T>(_ value: T?) {
        self.value = value ?? ()
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if container.decodeNil() {
            value = ()
        } else if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let string = try? container.decode(String.self) {
            value = string
        } else if let array = try? container.decode([AnyCodable].self) {
            value = array.map { $0.value }
        } else if let dictionary = try? container.decode([String: AnyCodable].self) {
            value = dictionary.mapValues { $0.value }
        } else {
            value = ()
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch value {
        case is Void:
            try container.encodeNil()
        case let bool as Bool:
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        case let array as [Any]:
            try container.encode(array.map { AnyCodable($0) })
        case let dictionary as [String: Any]:
            try container.encode(dictionary.mapValues { AnyCodable($0) })
        default:
            try container.encodeNil()
        }
    }
}

// MARK: - Computed Properties for Easy Access
extension PlayerAttributes {
    var displayName: String {
        return name
    }
    
    var region: String {
        return shardId.uppercased()
    }
    
    var isBanned: Bool {
        return banType != "clean" && !banType.isEmpty
    }
    
    var formattedCreatedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        
        if let date = formatter.date(from: createdAt) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .none
            return displayFormatter.string(from: date)
        }
        return createdAt
    }
}

// MARK: - Aggregated Stats Helper
extension PlayerStats {
    var totalKills: Int {
        let stats = [soloFPP, soloTPP, duoFPP, duoTPP, squadFPP, squadTPP]
        return stats.compactMap { $0?.kills }.reduce(0, +)
    }
    
    var totalWins: Int {
        let stats = [soloFPP, soloTPP, duoFPP, duoTPP, squadFPP, squadTPP]
        return stats.compactMap { $0?.wins }.reduce(0, +)
    }
    
    var totalMatches: Int {
        let stats = [soloFPP, soloTPP, duoFPP, duoTPP, squadFPP, squadTPP]
        return stats.compactMap { $0?.roundsPlayed }.reduce(0, +)
    }
    
    var kdRatio: Double {
        let totalDeaths = totalMatches - totalWins
        guard totalDeaths > 0 else { return Double(totalKills) }
        return Double(totalKills) / Double(totalDeaths)
    }
    
    var winRate: Double {
        guard totalMatches > 0 else { return 0.0 }
        return Double(totalWins) / Double(totalMatches) * 100
    }
}

// MARK: - Sample Data for Testing/Previews
extension PUBGPlayerResponse {
    static let sampleData = PUBGPlayerResponse(
        data: PlayerData(
            type: "player",
            id: "account.sample123",
            attributes: PlayerAttributes(
                name: "SamplePlayer",
                shardId: "steam",
                stats: PlayerStats(from: try! JSONDecoder().decode(PlayerStats.self, from: "{}".data(using: .utf8)!)),
                createdAt: "2023-01-01T00:00:00.000000Z",
                updatedAt: "2024-01-01T00:00:00.000000Z",
                patchVersion: "23.2.1",
                banType: "clean",
                titleId: "bluehole-pubg"
            ),
            relationships: PlayerRelationships(
                assets: RelationshipData(data: AnyCodable(())),
                matches: MatchesRelationship(data: [
                    MatchReference(id: "match1", type: "match"),
                    MatchReference(id: "match2", type: "match")
                ])
            ),
            links: PlayerLinks(
                schema: "https://schema.pubg.com/player.json",
                self: "https://api.pubg.com/shards/steam/players/account.sample123"
            )
        ),
        links: ResponseLinks(self: "https://api.pubg.com/shards/steam/players"),
        meta: ResponseMeta()
    )
}