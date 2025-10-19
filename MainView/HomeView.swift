//
//  HomeView.swift
//  ReKaffee
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Foundation

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var highestScore: Int = 0
    @State private var highestScoreService = HighestScoreService()
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(alignment: .center) {
                VStack(spacing: 8) {
                    HStack(spacing: 10) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                            .shadow(color: Color(red: 108/255, green: 145/255, blue: 235/255), radius: 2)
                        Text("Best Score")
                            .font(.custom("American Typewriter", size: 40))
                            .foregroundColor(.white)
                            .shadow(color: Color(red: 108/255, green: 145/255, blue: 235/255), radius: 2)
                        Image(systemName: "star.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .shadow(color: Color(red: 108/255, green: 145/255, blue: 235/255), radius: 2)
                    }
                    .padding(.bottom, 10)
                    
                    VStack(spacing: 20) {
                        Text("\(highestScore)")
                            .font(.custom("American Typewriter", size: 120))
                            .foregroundColor(.white)
                            .shadow(color: Color(red: 108/255, green: 145/255, blue: 235/255), radius: 5)
                        Text("pts")
                            .font(.custom("American Typewriter", size: 50))
                            .foregroundColor(.white)
                            .shadow(color: Color(red: 108/255, green: 145/255, blue: 235/255), radius: 2)
                    }
                    .padding(20)
                }
                .onAppear {
                    highestScoreService.fetchBestScore { result in
                        switch result {
                        case .success(let score):
                            highestScore = score
                        case .failure(let error):
                            print("Error fetching highest score: \(error.localizedDescription)")
                        }
                    }
                }
                
                Spacer()
                
                BasicButton(
                    title: "PLAY",
                    customFont: .custom("American Typewriter", size: 40),
                    foregroundColor: .white,
                    verticalPadding: 20,
                    horizontalPadding: 20,
                    gradientColors: [Color(red: 108/255, green: 145/255, blue: 235/255), Color(red: 108/255, green: 145/255, blue: 235/255).opacity(0.7)],
                    animateButton: true,
                    frameWidth: 250,
                    soundName: "monyon"
                ) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        appState.currentState = .game
                    }
                }
                .padding(.bottom, 40)
                
                Spacer()
            }
            .padding(.top, 80)
        }
    }
}

#Preview {
    HomeView()
}
