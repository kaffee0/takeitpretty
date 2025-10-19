//
//  PersonalityAnalysisView.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/03/28.
//
import SwiftUI
import Firebase
import FirebaseFirestore

struct PersonalityAnalysisView: View {
    let logs: [GameLog]
    
    var averageScore: Double {
        guard !logs.isEmpty else { return 0 }
        return logs.map { Double($0.score) }.reduce(0, +) / Double(logs.count)
    }
    
    // 最頻出のプレイ時間（hour）
    var mostCommonHour: Int {
        let distribution = logs.reduce(into: [Int: Int]()) { result, log in
            let hour = Calendar.current.component(.hour, from: log.timestamp)
            result[hour, default: 0] += 1
        }
        return distribution.max { a, b in a.value < b.value }?.key ?? 0
    }
    
    var personalityText: String {
        if averageScore > 250 {
            return "Your high scores suggest you're highly competitive and driven."
        } else if averageScore > 150 {
            return "You have a balanced play style, enjoying both challenge and fun."
        } else {
            return "Your relaxed scores indicate a laid-back approach to gaming."
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Personality Analysis")
                .font(.custom("American Typewriter", size: 28))
                .padding(.bottom, 4)
            Text(personalityText)
                .font(.custom("American Typewriter", size: 18))
            Text("Most frequent play hour: \(mostCommonHour):00")
                .font(.custom("American Typewriter", size: 18))
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.8)))
        .padding(.horizontal)
    }
}


