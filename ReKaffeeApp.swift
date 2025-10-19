//
//  ReKaffeeApp.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/02/07.
//

import SwiftUI
import FirebaseCore
import FirebaseAnalytics

@main
struct ReKaffeeApp: App {
    @StateObject var appState = AppState() 

    init(){
        FirebaseApp.configure()

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 229/255, green: 151/255, blue: 178/255, alpha: 1.0)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState) // 👈 これが必要！
                .onAppear {
                    Analytics.logEvent("app_open", parameters: nil)
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["inactivityNotification"])
                }
        }
    }
}
