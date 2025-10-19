//
//  PuniButton.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/02/07.
//

import SwiftUI

struct PuniButton: View {
    var emoji: String
    var size: CGFloat = 50
    var fontSize: CGFloat? = nil
    var strokeWidth: CGFloat = 1.0
    var onTapAction: () -> Void
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    onTapAction()
                }
            }) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.cyan]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: size, height: size)
//                        .overlay(
//                            Circle()
//                                .stroke(Color.white.opacity(0.8), lineWidth: strokeWidth)
//                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    
                    Text(emoji)
                        .foregroundStyle(Color.white)
                        .font(.system(size: fontSize ?? size * 0.6))
                        .shadow(color: Color.white.opacity(0.6), radius: 2)
                }
            }
            .buttonStyle(ShrinkOnPressButtonStyle())
            .padding(8)
        }
    }
}

struct ShrinkOnPressButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.85 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

#Preview {
    PuniButton(emoji: "🎟️", size: 200, strokeWidth: 3.0) {
        print("Button tapped!")
    }
}
