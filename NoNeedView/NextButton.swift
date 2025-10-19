////
////  NextButton.swift
////  ReKaffee
////
////  Created by Kae Feuring on 2025/02/07.
////
//
//import SwiftUI
//
//struct NextButton: View {
//    let isSetComplete: Bool
//    let animateButton: Bool
//    let action: () -> Void
//
//    var body: some View {
//        Button(action: {
//            action()
//        }) {
//            Text(isSetComplete ? "Set Complete !" : "Next")
//                .font(.system(size: 18, weight: .bold, design: .rounded))
//                .foregroundColor(.white)
//                .padding(.vertical, 12)
//                .padding(.horizontal, 24)
//                .background(
//                    LinearGradient(
//                        gradient: Gradient(colors: isSetComplete ? [Color.pink, Color.red.opacity(0.8)] : [Color.blue, Color.cyan]),
//                        startPoint: .topLeading,
//                        endPoint: .bottomTrailing
//                    )
//                )
//                .clipShape(Capsule())
//                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
//                .scaleEffect(animateButton ? 1.1 : 1.0)
//                .animation(.spring(response: 0.3, dampingFraction: 0.4), value: animateButton)
//        }
//    }
//}
//
//
//
//#Preview {
//    NextButton(isSetComplete: false, animateButton: false) {
//        print("Next tapped")
//    }
//}
