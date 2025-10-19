//
//  AppState.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/10/17.
//

import Foundation

enum AppViewState {
    case logo
    case login
    case main
    case game
    case battle
}

class AppState: ObservableObject {
    @Published var currentState: AppViewState = .logo
    @Published var selectedTab: TabSelection = .home 
}
