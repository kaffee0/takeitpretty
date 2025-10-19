//
//  GameResultView.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/02/09.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct GameResultView: View {
    @ObservedObject var viewModel: GameBoardViewModel
    @EnvironmentObject var appState: AppState
    let retryAction: () -> Void
    let endAction: () -> Void
    @State private var isSaving = false

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .contentShape(Rectangle())

            VStack(spacing: 15) {
                Text("Game Complete!")
                    .font(.custom("Avenir Next", size: 22))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(18)

                Text("\(ScoreCalculator(cells: viewModel.cells).calculateScore())")
                    .font(.custom("Avenir Next", size: 90))
                    .foregroundColor(Color(red: 230/255, green: 151/255, blue: 190/255))

                if isSaving {
                    LoadingView()
                        .frame(width: 250, height: 120)
                }

                VStack(spacing: 12) {
                    BasicButton(
                        title:"Retry",
                        customFont: .custom("Avenir Next", size: 25),
                        foregroundColor: .white,
                        verticalPadding: 20,
                        horizontalPadding: 40,
                        gradientColors: [Color(red: 108/255, green: 145/255, blue: 235/255), Color(red: 108/255, green: 145/255, blue: 235/255).opacity(0.7)],
                        animateButton: true,
                        frameWidth: 200,
                        soundName: "monyon",
                        action: retryAction
                    )
                    .padding(10)
                    BasicButton(
                        title:"End",
                        customFont: .custom("Avenir Next", size: 18),
                        foregroundColor: .white,
                        verticalPadding: 20,
                        horizontalPadding: 40,
                        gradientColors: [Color(red: 230/255, green: 151/255, blue: 190/255), Color(red: 230/255, green: 151/255, blue: 190/255).opacity(0.7)],
                        animateButton: true,
                        frameWidth: 140,
                        soundName: "monyon",
                        action: endAction
                    )
                    .padding(10)
                }
            }
            .padding(45)
            .frame(maxWidth: 400)
            .background(Color.white)
            .cornerRadius(30)
            .shadow(radius: 12)
            .padding()
            .scaleEffect(1)
            .opacity(1)
            .animation(.easeInOut(duration: 0.4), value:1)
        }
        .onAppear {
            recordScore()
        }
    }

    private func recordScore() {
        guard let user = Auth.auth().currentUser else { return }

        let userId = user.uid
        let score = ScoreCalculator(cells: viewModel.cells).calculateScore()

        isSaving = true

        ScoreManager.shared.saveGameData(
            userId: userId,
            username: nil,
            score: score,
            tiles: viewModel.tilesForSaving(),
            placements: viewModel.placementsForSaving()
        ) { success in
            isSaving = false
            if success {
                print("スコアとリプレイ保存成功！")
            } else {
                print("保存に失敗しました")
            }
            
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(userId)

            userRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let currentTopScore = document.data()?["highestScore"] as? Int ?? 0
                    if score > currentTopScore {
                        userRef.updateData(["highestScore": score]) { error in
                            if error == nil {
                                print("最高スコア更新！")
                            }
                        }
                    }
                } else {
                    userRef.setData([
                        "highestScore": score
                    ]) { error in
                        if error == nil {
                            print("初回スコア登録完了！")
                        }
                    }
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                let soundName = score <= 100 ? "duck" : (score <= 180 ? "pachi1" : "pachi2")
                SoundManager.shared.playSound(named: soundName)
            }
        }
    }
}


#Preview {
    GameResultView(
        viewModel: GameBoardViewModel(),
        retryAction: {},
        endAction: {}
    )
    .environmentObject(AppState())
}
