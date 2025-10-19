//
//  SettingsView.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/02/07.
//

import SwiftUI
import FirebaseAuth

enum SettingsSubview {
    case main
    case logout
}

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentSubview: SettingsSubview = .main
    @AppStorage("hasLoggedIn") private var hasLoggedIn: Bool = true

    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 1) {
                Text("Settings")
                    .font(.custom("American Typewriter", size: 40))
                    .foregroundColor(.white)
                    .padding(20)
                List {
                    settingsLink("Profile", destination: ProfileView())
                    settingsLink("Notification", destination: NotificationView())
                    settingsLink("Privacy", destination: PrivacyView())
                    settingsLink("Language", destination: LanguageView())
                    settingsLink("Appearance", destination: AppearanceView())
                }
                .font(.custom("American Typewriter", size: 27))
                .foregroundStyle(Color(red: 108/255, green: 145/255, blue: 235/255))
                .listStyle(InsetGroupedListStyle())
                .scrollContentBackground(.hidden)
                .transaction { $0.animation = nil }
                .padding(.top, -30)

                BasicButton(
                    title: "Logout",
                    customFont: .custom("American Typewriter", size: 27),
                    fontWeight: .medium,
                    foregroundColor: .white,
                    gradientColors: [
                        Color(red: 108/255, green: 145/255, blue: 235/255),
                        Color(red: 108/255, green: 145/255, blue: 235/255).opacity(0.7)
                    ],
                    animateButton: true,
                    frameWidth: 200,
                    action: {
                        withAnimation {
                            currentSubview = .logout
                        }
                    }
                )
                .padding(.bottom, 50)
            }
            .background(Color(red: 229/255, green: 151/255, blue: 178/255).ignoresSafeArea())
            .navigationViewStyle(StackNavigationViewStyle())
            .transaction { $0.animation = nil }
        }
        .overlay(
            Group {
                if currentSubview == .logout {
                    LogoutView(
                        logoutAction: {
                            do {
                                try Auth.auth().signOut()
                                appState.currentState = .logo
                                hasLoggedIn = false
                            } catch let error as NSError {
                                print("Error signing out: \(error.localizedDescription)")
                            }
                            appState.currentState = .logo
                        },
                        cancelAction: {
                            withAnimation {
                                currentSubview = .main
                            }
                        }
                    )
                    .transition(.opacity)
                }
            }
        )
    }

    private func settingsLink<Destination: View>(_ title: String, destination: Destination) -> some View {
        NavigationLink(destination: destination) {
            Text(title)
                .padding(.vertical, 10)
        }
        .listRowSeparator(.hidden)
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
}
