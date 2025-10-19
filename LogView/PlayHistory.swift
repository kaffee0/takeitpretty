//
//  PlayHistorySummaryView.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/03/28.
//
import SwiftUI
import Firebase
import FirebaseFirestore

struct PlayHistoryView: View {
    
    let logs: [GameLog]
    
    var playCount: Int { logs.count }
    var averageScore: Double {
        guard !logs.isEmpty else { return 0 }
        return logs.map { Double($0.score) }.reduce(0, +) / Double(logs.count)
    }
    
    var body: some View {
        HStack {
            Text("Total Plays:")
                .foregroundStyle(Color.white)
            Spacer()
            Text("\(playCount)")
                .foregroundColor(Color(red: 108/255, green: 145/255, blue: 235/255))
//                .fontWeight(.semibold)
        }
        .font(.custom("American Typewriter", size: 27))
        HStack {
            Text("Average Score:")
                .foregroundStyle(Color.white)
            Spacer()
            Text(String(format: "%.1f", averageScore))
                .foregroundColor(Color(red: 108/255, green: 145/255, blue: 235/255))
//                .fontWeight(.semibold)
        }
        .font(.custom("American Typewriter", size: 27))
    }
}
