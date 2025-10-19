//
//  PlayLogView.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/03/28.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct PlayLogView: View {
    @State private var logs: [GameLog] = []
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                Text("Your Play Logs")
                    .font(.custom("American Typewriter", size: 40))
                    .foregroundColor(.white)
                    .padding(20)
                List {
                    Section {
                        PlayHistoryView(logs: logs)
                            .padding(10)
                    }
                    .listRowBackground(Color(red: 229/255, green: 151/255, blue: 178/255))
                    ForEach(logs) { log in
                        PlayLogCell(log: log)
                    }
                    .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                    .listRowBackground(Color(red: 229/255, green: 151/255, blue: 178/255))
                }
                .listStyle(PlainListStyle())
            }
        }
        .onAppear {
            fetchLogs()
        }
    }
    
    func fetchLogs() {
        guard let user = Auth.auth().currentUser else {
            print("No user is logged in.")
            return
        }
        
        ScoreManager.shared.fetchUserLogs(userId: user.uid) { data in
            var tempLogs: [GameLog] = []
            for dict in data {
                if let log = GameLog(dict: dict) {
                    tempLogs.append(log)
                }
            }
            tempLogs.sort { $0.timestamp > $1.timestamp }
            
            DispatchQueue.main.async {
                self.logs = tempLogs
            }
        }
    }
}

#Preview {
    PlayLogView()
}
