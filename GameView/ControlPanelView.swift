//
//  ControlPanelView.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/02/07.
//

import SwiftUI

struct ControlPanelView: View {
    let showMenuView: () -> Void
    let showRestTileView: () -> Void
    let isSetComplete: Bool
    let animateButton: Bool
    let nextAction: () -> Void
    var size: CGFloat = 50
    var fontSize: CGFloat? = nil
    
    var body: some View {
        VStack {
            HStack {
                BasicButton(
                    title:"🧃",
                    fontSize: fontSize ?? size * 0.6,
                    foregroundColor: .white,
                    verticalPadding: 5,
                    horizontalPadding: 5,
                    gradientColors: [
                        Color(red: 125/255, green: 145/255, blue: 213/255),
                        Color(red: 108/255, green: 145/255, blue: 235/255).opacity(0.8)
                    ],
                    animateButton: true,
                    soundName: "monyon"
                ){
                    showMenuView()
                }
                .padding()
                Spacer()
            }
            Spacer()
            HStack {
                Spacer()
                Spacer()
                Spacer()
                BasicButton(
                    title: isSetComplete ? "Complete" : "Next",
                    customFont: .custom("American Typewriter", size: 20),
                    fontWeight: .medium,
                    foregroundColor: .white,
                    verticalPadding: 20,
                    horizontalPadding: 30,
                    gradientColors: isSetComplete ? [
                        Color(red: 229/255, green: 151/255, blue: 178/255),
                        Color(red: 229/255, green: 151/255, blue: 178/255).opacity(0.7)
                    ]:[
                        Color(red: 125/255, green: 145/255, blue: 213/255),
                        Color(red: 120/255, green: 145/255, blue: 213/255).opacity(0.7)
                    ],
                    animateButton: true,
                    soundName: "monyon",
                    action: nextAction
                )
                Spacer()
                BasicButton(
                    title:"💡",
                    fontSize: fontSize ?? size * 0.6,
                    foregroundColor: .white,
                    verticalPadding: 5,
                    horizontalPadding: 5,
                    gradientColors: [
                        Color(red: 125/255, green: 145/255, blue: 213/255),
                        Color(red: 108/255, green: 145/255, blue: 235/255).opacity(0.8)
                    ],
                    animateButton: true,
                    soundName: "monyon"
                ){
                    showRestTileView()
                }
                Spacer() // Push "💡" button to its correct position
            }
            .padding(.bottom, 20)
        }
        .padding()
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ControlPanelView(
        showMenuView: { print("Menu tapped!") },
        showRestTileView: { print("Tile tapped!") },
        isSetComplete: false,
        animateButton: true,
        nextAction: { print("Next tapped!") }
    )
}
