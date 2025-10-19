//
//  ScoreManager.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/02/07.
//

import FirebaseFirestore

class ScoreManager: ObservableObject {
    static let shared = ScoreManager() 

    private let db = Firestore.firestore()

    func saveGameData(
        userId: String,
        username: String?,
        score: Int,
        tiles: [[String:Int]]? = nil,
        placements: [[String:String]]? = nil,
        completion: ((Bool) -> Void)? = nil
    ) {
        var data: [String: Any] = [
            "userId": userId,
            "score": score,
            "timestamp": Timestamp(date: Date())
        ]
        
        if let username = username {
            data["username"] = username
        }
        
        if let tiles = tiles {
            data["tiles"] = tiles
        }
        
        if let placements = placements {
            data["placements"] = placements
        }

        let collectionName = "scores"
        
        db.collection(collectionName).addDocument(data: data) { error in
            if let error = error {
                print("❌ データ保存失敗: \(error.localizedDescription)")
                completion?(false)
            } else {
                print("✅ \(collectionName) 保存完了！")
                completion?(true)
            }
        }
    }
    
    func fetchTopScores(limit: Int = 10, completion: @escaping ([[String: Any]]) -> Void) {
        db.collection("scores")
            .order(by: "score", descending: true)
            .limit(to: limit)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching scores: \(error.localizedDescription)")
                    completion([])
                    return
                }
                
                let scores = snapshot?.documents.map { $0.data() } ?? []
                completion(scores)
            }
    }
    
    func fetchUserLogs(userId: String, completion: @escaping ([[String: Any]]) -> Void) {
            db.collection("scores")
                .whereField("userId", isEqualTo: userId)
                .order(by: "timestamp", descending: true)
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Error fetching user logs: \(error.localizedDescription)")
                        completion([])
                        return
                    }
                    let logs = snapshot?.documents.map { $0.data() } ?? []
                    completion(logs)
                }
        }
}
