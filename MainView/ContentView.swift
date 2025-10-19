//
//  ContentView.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/02/09.
//

import SwiftUI

struct ContentView: View {
    @StateObject var appState = AppState()
    @State private var showHomeView = false
    @State private var showGameView = false
    @State private var showLoginView = false

    var body: some View {
        Group {
            switch appState.currentState {
            case .logo:
                LogoView(
                    showHomeView: $showHomeView,
                    showGameView: $showGameView,
                    showLoginView: $showLoginView
                )
                .environmentObject(appState)
            case .login:
                LoginView {
                    appState.currentState = .main
                }
                .environmentObject(appState)
            case .main:
                MainTabView().environmentObject(appState)
            case .game:
                GameView().environmentObject(appState)
//            case .battle:
//                BattleGameView().environmentObject(appState)
            default:
                EmptyView()
            }
        }
    }
}

#Preview {
    ContentView()
}
