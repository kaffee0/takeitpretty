//
//  LogoView.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/10/17.
//


import SwiftUI
import FirebaseAuth

struct LogoView: View {
    @State private var animateHeart = false
    @State private var isLoading = true
    @State private var showTitleView = false
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0.0
    @State private var navigateToNextScreen = false
    @State private var isLoggedIn: Bool = false // 🔹 初期値を設定
    @Binding var showHomeView: Bool
    @Binding var showGameView: Bool
    @Binding var showLoginView: Bool
    @AppStorage("hasLoggedIn") private var hasLoggedIn: Bool = false

    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                if isLoading {
                    LoadingView()
                        .transition(.opacity)
                } else if showTitleView {
                    VStack {
                        Spacer()
                        VStack(spacing: 16) {
                            Image(systemName: "heart.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .foregroundColor(Color(red: 200/255, green: 151/255, blue: 225/255))
                                .shadow(color: Color(red: 108/255, green: 145/255, blue: 235/255),
                                        radius: 5, x: 0, y: 0)
                                .scaleEffect(animateHeart ? 1.05 : 0.95)
                                .rotationEffect(.degrees(animateHeart ? 5 : -5))
                                .animation(Animation.easeInOut(duration: 1.0)
                                            .repeatForever(autoreverses: true),
                                           value: animateHeart)
                                .onAppear { animateHeart = true }
                            
                            Text("Take It Easy")
                                .font(.custom("Avenir Next", size: 36))
                                .foregroundColor(.white)
                                .shadow(color: Color.black.opacity(0.3), radius: 2, x: 1, y: 1)
                                .padding(40)
                        }
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.5)) {
                                logoScale = 1.0
                                logoOpacity = 1.0
                            }
                        }
                        Spacer()
                    }
                    .transition(AnyTransition.opacity.combined(with: .scale))
                }
            }
            .onAppear {
                checkLoginStatus()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if showTitleView && !isLoading {
                    navigateToNextScreen = true // 🔹 タップで遷移を開始
                }
            }

            if navigateToNextScreen {
                if isLoggedIn || hasLoggedIn {
                    HomeView()
                        .transition(.opacity)
                        .zIndex(1)
                } else {
                    LoginView()
                }
            }
        }
    }

    /// 🔹 ログイン状態をチェックして、次の画面を決定
    private func checkLoginStatus() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // 🔹 3秒ロゴを表示
            withAnimation(.easeInOut(duration: 1.5)) {
                isLoading = false
                showTitleView = true
            }
            if Auth.auth().currentUser != nil {
                isLoggedIn = true
                hasLoggedIn = true
            } else {
                hasLoggedIn = false
            }
        }
    }
}

#Preview {
    LogoView(
        showHomeView: .constant(false),
        showGameView: .constant(false),
        showLoginView: .constant(false)
    )
}
