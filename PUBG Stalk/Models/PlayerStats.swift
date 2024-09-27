//
//  PlayerStats.swift
//  PUBG Stalk
//
//  Created by  Bouncy Baby on 9/27/24.
//

import Foundation

struct PlayerStats: Codable {
    let id: String
    let name: String
    let matchesPlayed: Int
    let wins: Int
    let kills: Int
    let kdRatio: Double
}
