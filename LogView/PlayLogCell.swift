//
//  PlayLogCell.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/03/28.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct PlayLogCell: View {
    let log: GameLog
    
    @State private var isBoardVisible: Bool = false
    let previewSize: CGFloat = UIScreen.main.bounds.width / 2 * 0.9
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            HStack {
                Text(formattedDate(log.timestamp))
                    .font(.custom("American Typewriter", size: 27))
                    .foregroundStyle(Color.white)
                Spacer()
                Text("\(log.score)pt")
                    .font(.custom("American Typewriter", size: 27))
                    .foregroundColor(Color(red: 108/255, green: 145/255, blue: 235/255))
            }
            
            if !log.placements.isEmpty && !log.tiles.isEmpty {
                if isBoardVisible {
                    MiniBoardView(
                        placements: log.placements,
                        tiles: log.tiles,
                        previewSize: previewSize
                    )
                }
            }
            
        }
        .padding(10)
//        .background(Color(.secondarySystemBackground))
//        .cornerRadius(16)
//        .shadow(radius: 3)
        .onTapGesture {
            if !log.placements.isEmpty && !log.tiles.isEmpty {
                isBoardVisible.toggle()
            }
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        return formatter.string(from: date)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    let dummyLog = GameLog(
        score: 200,
        timestamp: Date(),
        userId: "dummyUser",
        placements: [
            ["position": "0,0"],
            ["position": "1,-1"],
            ["position": "-1,1"],
            ["position": "0,1"],
            ["position": "1,0"]
        ],
        tiles: [
            ["line1": 9, "line2": 7, "line3": 8],
            ["line1": 5, "line2": 6, "line3": 2],
            ["line1": 1, "line2": 7, "line3": 9],
            ["line1": 2, "line2": 4, "line3": 6],
            ["line1": 3, "line2": 5, "line3": 7]
        ]
    )
    PlayLogCell(log: dummyLog)
        .padding()
}
