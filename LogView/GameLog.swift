//
//  GameLog.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/03/28.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct GameLog: Identifiable {
    let id = UUID()
    let score: Int
    let timestamp: Date
    let userId: String
    let placements: [[String: String]]
    let tiles: [[String: Int]]
}

extension GameLog {
    init?(dict: [String: Any]) {
        guard let score = dict["score"] as? Int,
              let timestamp = (dict["timestamp"] as? Timestamp)?.dateValue(),
              let userId = dict["userId"] as? String else {
            return nil
        }
        
        self.score = score
        self.timestamp = timestamp
        self.userId = userId
        self.placements = dict["placements"] as? [[String: String]] ?? []
        self.tiles = dict["tiles"] as? [[String: Int]] ?? []
    }
}
