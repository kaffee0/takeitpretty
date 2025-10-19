//
//  LoadingView.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/02/07.
//

import SwiftUI

struct LoadingView: View {
@State private var rotationAngle: Double = 0.0
    
    var body: some View {
        ZStack {
            HStack(spacing: 10) {
                Text("loading…")
                    .font(.system(size: 20, design: .rounded))
                    .foregroundColor(.white)
                FlatHexagonShape()
                    .fill(
                        Color(red: 108/255, green: 145/255, blue: 235/255)
                    )
                    .frame(width: 15, height: 15)
                    .rotationEffect(.degrees(rotationAngle))
                    .animation(Animation.linear(duration: 1.4).repeatForever(autoreverses: false), value: rotationAngle)
                    .onAppear {
                        startRotation()
                    }
            }
        }
    }
    
    private func startRotation() {
        rotationAngle = 360 
    }
}

#Preview {
    LoadingView()
}
