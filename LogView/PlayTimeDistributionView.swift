//
//  PlayTimeDistributionView.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/03/28.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct PlayTimeDistributionView: View {
    let logs: [GameLog]
    
    var distribution: [Int: Int] {
        var dist = [Int: Int]()
        for log in logs {
            let hour = Calendar.current.component(.hour, from: log.timestamp)
            dist[hour, default: 0] += 1
        }
        return dist
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Play Time Distribution (Hour of Day)")
                .font(.custom("American Typewriter", size: 20))
            ForEach(0..<24, id: \.self) { hour in
                HStack {
                    Text("\(hour):00")
                        .frame(width: 50, alignment: .leading)
                    let count = distribution[hour] ?? 0
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: CGFloat(count) * 10, height: 10)
                    Text("\(count)")
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.8)))
        .padding(.horizontal)
    }
}
