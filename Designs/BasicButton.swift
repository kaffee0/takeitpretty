//
//  NextButton 2.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/02/09.
//

import SwiftUI

struct BasicButton: View {
    var title: String = ""
    var customFont: Font? = nil
    var fontSize: CGFloat = 18
    var fontWeight: Font.Weight = .regular
    var fontDesign: Font.Design = .rounded
    var foregroundColor: Color = .white
    var verticalPadding: CGFloat = 12
    var horizontalPadding: CGFloat = 24
    var gradientColors: [Color] = [Color.blue, Color.cyan]
    var gradientStartPoint: UnitPoint = .topLeading
    var gradientEndPoint: UnitPoint = .bottomTrailing
    var shadowColor: Color = Color.black.opacity(0.2)
    var shadowRadius: CGFloat = 4
    var shadowX: CGFloat = 0
    var shadowY: CGFloat = 2
    var scaleEffectValue: CGFloat = 1.0
    var animateButton: Bool = false
    var animation: Animation = .spring(response: 0.3, dampingFraction: 0.4)
    var frameWidth: CGFloat? = nil
    var soundName: String? = nil
    
    var action: () -> Void

    var body: some View {
        Button(action: {
            if let soundName = soundName {
                SoundManager.shared.playSound(named: soundName)
            }
            action()
        }) {
            Text(title)
                .font(customFont ?? .system(size: fontSize, weight: fontWeight, design: fontDesign))
                .fontWeight(fontWeight)
                .foregroundColor(foregroundColor)
                .padding(.vertical, verticalPadding)
                .padding(.horizontal, horizontalPadding)
                .frame(width: frameWidth)  
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors),
                        startPoint: gradientStartPoint,
                        endPoint: gradientEndPoint
                    )
                )
                .clipShape(Capsule())
                .shadow(color: shadowColor, radius: shadowRadius, x: shadowX, y: shadowY)
                .scaleEffect(animateButton ? scaleEffectValue * 1.1 : scaleEffectValue)
                .animation(animation, value: animateButton)
        }
        .buttonStyle(ShrinkOnPressButtonStyle())
    }
    
    struct ShrinkOnPressButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.85 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
        }
    }
}
