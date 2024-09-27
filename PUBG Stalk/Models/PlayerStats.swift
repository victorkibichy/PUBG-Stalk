//
//  PlayerStats.swift
//  PUBG Stalk
//
//  Created by  Bouncy Baby on 9/27/24.
//

import Foundation


// MARK: - Main Player Response
struct PlayerResponse: Codable {
    let data: [PlayerData]
    let links: Links
    let meta: Meta?
}

// MARK: - Player Data
struct PlayerData: Codable {
    let type: String
    let id: String
    let attributes: PlayerAttributes
    let relationships: PlayerRelationships
    let links: Links
}

// MARK: - Player Attributes
struct PlayerAttributes: Codable {
    let name: String
    let shardId: String
    let stats: Stats?
    let createdAt: String
    let updatedAt: String
    let patchVersion: String
    let banType: String
    let titleId: String
}

// MARK: - Player Relationships
struct PlayerRelationships: Codable {
    let assets: AssetData
    let matches: MatchData
}

// MARK: - Match Data
struct MatchData: Codable {
    let data: [Match]
}

// MARK: - Match
struct Match: Codable {
    let id: String
    let type: String
}

// MARK: - Asset Data
struct AssetData: Codable {
    let data: Asset
}

// MARK: - Asset
struct Asset: Codable {
    let id: String?
    let type: String?
}

// MARK: - Links
struct Links: Codable {
    let schema: String?
    let selfLink: String? // "self" is a reserved keyword in Swift, so renamed to "selfLink"
    
    enum CodingKeys: String, CodingKey {
        case schema
        case selfLink = "self"
    }
}

// MARK: - Meta
struct Meta: Codable {
    
    
}

// MARK: - Stats
// You can define the `Stats` struct based on additional data from the API for player stats
struct Stats: Codable {
    
}

