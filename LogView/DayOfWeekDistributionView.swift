//
//  DayOfWeekDistributionView.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/03/28.
//
import SwiftUI
import Firebase
import FirebaseFirestore

struct DayOfWeekDistributionView: View {
    let logs: [GameLog]
    
    var distribution: [Int: Int] {
        var dist = [Int: Int]()
        for log in logs {
            // 曜日は Calendar で Sunday=1, Monday=2, …, Saturday=7
            let weekday = Calendar.current.component(.weekday, from: log.timestamp)
            dist[weekday, default: 0] += 1
        }
        return dist
    }
    
    let dayNames: [Int: String] = [
        1: "Sun", 2: "Mon", 3: "Tue",
        4: "Wed", 5: "Thu", 6: "Fri",
        7: "Sat"
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Play Distribution by Day")
                .font(.custom("American Typewriter", size: 20))
            ForEach(1...7, id: \.self) { day in
                HStack {
                    Text(dayNames[day] ?? "")
                        .frame(width: 50, alignment: .leading)
                    let count = distribution[day] ?? 0
                    Rectangle()
                        .fill(Color.green)
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
