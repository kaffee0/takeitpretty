//
//  RankingView.swift
//  ReKaffee
//

import SwiftUI
import Foundation
import FirebaseFirestore

struct RankingView: View {
    @EnvironmentObject var appState: AppState
    @State private var rankings: [Ranking] = []
    
    var body: some View {
        ZStack{
            BackgroundView()
            VStack {
                HStack {
                    Image(systemName: "trophy.fill")
                    Text(" Ranking ")
                    Image(systemName: "trophy.fill")
                }
                .font(.custom("American Typewriter", size: 40))
                .foregroundColor(.white)
                .padding(20)
                
                ScrollView {
                    if rankings.isEmpty {
                        VStack {
                            Spacer()
                            Text("Loading…")
                                .font(.custom("American Typewriter", size: 20))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, minHeight: 200)
                    } else {
                        VStack(spacing: 10) {
                            ForEach(rankings.indices, id: \.self) { index in
                                let ranking = rankings[index]
                                RankingCellView(rank: index + 1,
                                                username: ranking.username,
                                                score: ranking.highestScore)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                fetchRankings()
            }
        }
    }
    
    private func fetchRankings() {
        RankingService().fetchRankings { result in
            switch result {
            case .success(let fetchedRankings):
                DispatchQueue.main.async {
                    self.rankings = fetchedRankings
                }
            case .failure(let error):
                print("ランキング取得失敗: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    RankingView()
}
