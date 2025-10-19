//
//  BestScoreService.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/02/09.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct HighestScoreService {
    // 現在ログイン中のユーザーの「highestScore」フィールドを取得します
    func fetchBestScore(completion: @escaping (Result<Int, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            let error = NSError(domain: "AuthError", code: -1,
                                userInfo: [NSLocalizedDescriptionKey: "ユーザーが認証されておりません。"])
            completion(.failure(error))
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let document = document, document.exists,
               let highestScore = document.get("highestScore") as? Int {
                completion(.success(highestScore))
            } else {
                completion(.success(0))
            }
        }
    }
}
