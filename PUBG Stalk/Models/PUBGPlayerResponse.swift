//
//  PUBGPlayerResponse.swift
//  PUBG Stalk
//
//  Created by Kibichy on 02/07/2025.
//


import Foundation

// MARK: - Sample Data for Testing/Previews
extension PUBGPlayerResponse {
    static var sampleData: PUBGPlayerResponse {
        return PUBGPlayerResponse(
            data: PlayerData(
                type: "player",
                id: "account.sample123",
                attributes: PlayerAttributes(
                    name: "SamplePlayer",
                    shardId: "steam",
                    stats: try! JSONDecoder().decode(PlayerStats.self, from: "{}".data(using: .utf8)!),
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
}
