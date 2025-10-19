//
//  StrokeBackground.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/02/07.
//

import SwiftUI

struct StrokeBackground: ViewModifier {
    private let id = UUID()
    private var strokeWidth: CGFloat
    private var strokeColor: Color

    init(strokeWidth: CGFloat, strokeColor: Color) {
        self.strokeWidth = strokeWidth
        self.strokeColor = strokeColor
    }

    func body(content: Content) -> some View {
        if strokeWidth > 0 {
            content
                .padding(strokeWidth * 2)
                .background(
                    Rectangle()
                        .foregroundColor(strokeColor)
                        .mask(
                            Canvas { context, size in
                                context.addFilter(.alphaThreshold(min: 0.01))
                                context.drawLayer { ctx in
                                    if let resolvedView = context.resolveSymbol(id: id) {
                                        ctx.draw(resolvedView, at: CGPoint(x: size.width/2, y: size.height/2))
                                    }
                                }
                            } symbols: {
                                content
                                    .tag(id)
                                    .blur(radius: strokeWidth)
                            }
                        )
                )
        } else {
            content
        }
    }
}

extension View {
    func stroke(color: Color, width: CGFloat) -> some View {
        self.modifier(StrokeBackground(strokeWidth: width, strokeColor: color))
    }
}
