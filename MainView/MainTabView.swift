//
//  MainTabView.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/02/08.
//

import SwiftUI

enum TabSelection: Hashable {
    case home, ranking, Logs, settings
}

struct MainTabView: View {
    @EnvironmentObject var appState: AppState

    init() {
        let appearance = UITabBarAppearance()

        appearance.backgroundColor = UIColor(red: 229/255, green: 151/255, blue: 178/255, alpha: 1.0)
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(red: 108/255, green: 145/255, blue: 235/255, alpha: 1.0)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(red: 108/255, green: 145/255, blue: 235/255, alpha: 1.0)]
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(TabSelection.home)
            
            PlayLogView()
                .tabItem {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("Log")
                }
                .tag(TabSelection.Logs)
            
            RankingView()
                .tabItem {
                    Image(systemName: "trophy.fill")
                    Text("Ranking")
                }
                .tag(TabSelection.ranking)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Setting")
                }
                .tag(TabSelection.settings)
        }
        .environmentObject(appState)
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error {
                    print("通知の許可リクエストエラー: \(error.localizedDescription)")
                } else {
                    print("通知の許可: \(granted)")
                }
            }
        }
    }
}

#Preview {
    MainTabView()
}
