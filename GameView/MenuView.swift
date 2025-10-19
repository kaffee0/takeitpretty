//
//  MenuView.swift
//  ReKaffee
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var appState: AppState
    let continueAction: () -> Void
    let endAction: () -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .contentShape(Rectangle())
            VStack(spacing: 25) {
                Text("Menu")
                    .font(.custom("American Typewriter", size: 25))
                    .fontWeight(.semibold)
                BasicButton(
                    title:"Continue",
                    customFont: .custom("American Typewriter", size: 25),
                    foregroundColor: .white,
                    verticalPadding: 20,
                    horizontalPadding: 40,
                    gradientColors: [
                        Color(red: 125/255, green: 145/255, blue: 213/255),
                        Color(red: 108/255, green: 145/255, blue: 235/255).opacity(0.7)
                    ],
                    animateButton: true,
                    frameWidth: 200,
                    soundName: "monyon"
                ){
                    continueAction()
                }
                BasicButton(
                    title:"End",
                    customFont: .custom("American Typewriter", size: 25),
                    foregroundColor: .white,
                    verticalPadding: 20,
                    horizontalPadding: 40,
                    gradientColors: [Color(red: 235/255, green: 75/255, blue: 95/255), Color(red: 235/255, green: 75/255, blue: 95/255).opacity(0.7)],
                    animateButton: true,
                    frameWidth: 200,
                    soundName: "「神の裁きを！」"
                ){
                    endAction()
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
        }
    }
}

#Preview {
    MenuView(continueAction: {}, endAction: {})
}
