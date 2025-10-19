//
//  Ranking.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/02/09.
//

import Foundation
import FirebaseFirestore

// ランキングデータを表すモデル
struct Ranking: Identifiable {
    var id: String = UUID().uuidString
    let username: String
    let highestScore: Int
}

struct RankingService {
    func fetchRankings(completion: @escaping (Result<[Ranking], Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("users")
            .order(by: "highestScore", descending: true)
            .limit(to: 10)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                var rankings: [Ranking] = []
                for document in snapshot?.documents ?? [] {
                    let data = document.data()
                    let username = data["username"] as? String ?? "???"
                    let highestScore = data["highestScore"] as? Int ?? 0
                    rankings.append(Ranking(username: username, highestScore: highestScore))
                }
                completion(.success(rankings))
            }
    }
}
