//
//  ScoreCalculator.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/02/07.
//

import FirebaseFirestore
import FirebaseAuth
import Foundation

struct ScoreCalculator {
    let cells: [HexCell]

    func calculateScore() -> Int {
        var total = 0
        // 共通グループ分け関数を利用
        let groups = calculateScoreGroups(from: cells)
        
        // line1 の各グループ
        for group in groups.line1Groups {
            let commonValue = group.first!.tile!.line1
            total += group.count * commonValue
        }
        
        // line2 の各グループ
        for group in groups.line2Groups {
            let commonValue = group.first!.tile!.line2
            total += group.count * commonValue
        }
        
        // line3 の各グループ
        for group in groups.line3Groups {
            let commonValue = group.first!.tile!.line3
            total += group.count * commonValue
        }
        return total
    }

    func saveScoreToFirebase(username: String, boardImageURL: String? = nil, completion: @escaping (Bool) -> Void) {
        let score = calculateScore()
        let db = Firestore.firestore()
        
        let scoreData: [String: Any] = [
            "username": username,
            "score": score,
            "timestamp": Timestamp(date: Date()),
            "userId": Auth.auth().currentUser?.uid ?? ""
        ]
        
        db.collection("scores").addDocument(data: scoreData) { error in
            if let error = error {
                print("Error saving score: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Score saved successfully!")
                completion(true)
            }
        }
    }
}
