//
//  LogoutView.swift
//  ReKaffee
//

import SwiftUI
import FirebaseAuth

struct LogoutView: View {
    @EnvironmentObject var appState: AppState
    @State private var isLoggingOut = false
    @AppStorage("hasLoggedIn") private var hasLoggedIn: Bool = true
    let logoutAction: () -> Void
    let cancelAction: () -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                VStack(alignment: .center, spacing: 20) {
                    Text("Are you sure you want to log out?")
                        .font(.custom("American Typewriter", size: 20))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)

                    if isLoggingOut {
                        ProgressView("Logging out...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .padding()
                    } else {
                        VStack(spacing: 20) {
                            BasicButton(
                                title: "Logout",
                                customFont: .custom("American Typewriter", size: 25),
                                foregroundColor: .white,
                                gradientColors: [
                                    Color(red: 125/255, green: 145/255, blue: 213/255),
                                    Color(red: 108/255, green: 145/255, blue: 235/255).opacity(0.7)
                                ],
                                animateButton: true,
                                frameWidth: 200,
                                action: {
                                    logoutAction()
                                }
                            )
                            BasicButton(
                                title: "Cancel",
                                customFont: .custom("American Typewriter", size: 25),
                                foregroundColor: .white,
                                gradientColors: [
                                    Color(red: 235/255, green: 75/255, blue: 95/255), Color(red: 235/255, green: 75/255, blue: 95/255).opacity(0.7)
                                ],
                                animateButton: true,
                                frameWidth: 200,
                                action: {
                                    cancelAction()
                                }
                            )
                            .transition(.opacity)
                        }
                    }
                }
                .padding(30)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .frame(maxWidth: 350)
            }
            .padding()
            .ignoresSafeArea()
        }
    }
}
#Preview {
    LogoutView(logoutAction: {}, cancelAction: {})
        .environmentObject(AppState())
}
