//
//  PulsingStars.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/02/07.
//

import SwiftUI

struct PulsingStars: View {
    let count: Int

    var body: some View {
        GeometryReader { geo in
            ForEach(0..<count, id: \.self) { _ in
                PulsingStar(size: CGFloat.random(in: 2...4))
                    .position(
                        x: CGFloat.random(in: 0...geo.size.width),
                        y: CGFloat.random(in: 0...geo.size.height)
                    )
            }
        }
        .allowsHitTesting(false)
    }
}

struct PulsingStar: View {
    @State private var isVisible = false
    let size: CGFloat

    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: size, height: size)
            .opacity(isVisible ? 1.0 : 0.0)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: Double.random(in: 1.0...2.0))
                        .repeatForever(autoreverses: true)
                        .delay(Double.random(in: 0...1.0))
                ) {
                    isVisible = true
                }
            }
    }
}
