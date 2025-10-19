//
//  BounceNeonModifier.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/02/11.
//

import SwiftUI

struct BounceModifier: ViewModifier {
    let delay: Double
    @State private var animateBounce = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(animateBounce ? 1.05 : 1.0)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.1).delay(delay)) {
                    animateBounce = true
                }
                withAnimation(.easeInOut(duration: 0.2).delay(delay + 0.16)) {
                    animateBounce = false
                }
            }
    }
}

extension View {
    func bounce(delay: Double) -> some View {
        self.modifier(BounceModifier(delay: delay))
    }
}
