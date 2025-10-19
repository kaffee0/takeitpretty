
//
//  TileDesignView.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/02/07.
//

import SwiftUI

struct TileDesignView: View {
    let tile: Tile
    let size: CGFloat
    let fontScale: CGFloat  // 数字のサイズ比率を指定（例: 0.25）
    
    var neonLine1: Bool = false
    var neonLine2: Bool = false
    var neonLine3: Bool = false
    
    @AppStorage("selectedFont") private var selectedFont = "American Typewriter"
    
    private var computedFontSize: CGFloat {
        return max(10, size * fontScale)
    }

    private var computedLineWidth: CGFloat {
        return max(2, size * 0.15)
    }

    var body: some View {
        ZStack {
            FlatHexagonShape()
                .fill(Color(red: 162/255, green: 87/255, blue: 104/255))
                .overlay(
                    FlatHexagonShape()
                        .stroke((neonLine1 || neonLine2 || neonLine3) ? Color.white : Color.black, lineWidth: 0.4)
                )
                .frame(width: size, height: size)
            
            let vertices = flatHexagonVertices(size: size)
            let m12 = CGPoint(x: (vertices[0].x + vertices[1].x) / 2,
                              y: (vertices[0].y + vertices[1].y) / 2)
            let m45 = CGPoint(x: (vertices[3].x + vertices[4].x) / 2,
                              y: (vertices[3].y + vertices[4].y) / 2)
            let m23 = CGPoint(x: (vertices[1].x + vertices[2].x) / 2,
                              y: (vertices[1].y + vertices[2].y) / 2)
            let m56 = CGPoint(x: (vertices[4].x + vertices[5].x) / 2,
                              y: (vertices[4].y + vertices[5].y) / 2)
            let m61 = CGPoint(x: (vertices[5].x + vertices[0].x) / 2,
                              y: (vertices[5].y + vertices[0].y) / 2)
            let m34 = CGPoint(x: (vertices[2].x + vertices[3].x) / 2,
                              y: (vertices[2].y + vertices[3].y) / 2)
            
            Path { path in
                path.move(to: m61)
                path.addLine(to: m34)
            }
            .stroke(neonLine3 ? neonStrokeColor(for: tile.line3) : colorForDigit(tile.line3), lineWidth: computedLineWidth)
            .shadow(color: neonLine3 ? colorForDigit(tile.line3) : .clear, radius: neonLine3 ? 10 : 0)
            
            Path { path in
                path.move(to: m23)
                path.addLine(to: m56)
            }
            .stroke(neonLine2 ? neonStrokeColor(for: tile.line2) : colorForDigit(tile.line2), lineWidth: computedLineWidth)
            .shadow(color: neonLine2 ? colorForDigit(tile.line2) : .clear, radius: neonLine2 ? 10 : 0)
            
            Path { path in
                path.move(to: m12)
                path.addLine(to: m45)
            }
            .stroke(neonLine1 ? neonStrokeColor(for: tile.line1) : colorForDigit(tile.line1), lineWidth: computedLineWidth)
            .shadow(color: neonLine1 ? colorForDigit(tile.line1) : .clear, radius: neonLine1 ? 10 : 0)

            let centerA = CGPoint(x: size / 2, y: size / 2)
            let textOffset: CGFloat = size * 0.05
            
            let textPos1 = CGPoint(x: (centerA.x + m12.x) / 2, y: (centerA.y + m12.y) / 2 - textOffset)
            let textPos2 = CGPoint(x: (centerA.x + m56.x) / 2 - textOffset * 1.5, y: (centerA.y + m56.y) / 2 + textOffset)
            let textPos3 = CGPoint(x: (centerA.x + m34.x) / 2 + textOffset * 1.5, y: (centerA.y + m34.y) / 2 + textOffset)
            
            Text("\(tile.line1)")
                .font(.custom(selectedFont, size: computedFontSize))
                .stroke(color: .white, width: 0.6)
                .foregroundColor(.black)
                .position(textPos1)
            Text("\(tile.line2)")
                .font(.custom(selectedFont, size: computedFontSize))
                .stroke(color: .white, width: 0.6)
                .foregroundColor(.black)
                .position(textPos2)
            Text("\(tile.line3)")
                .font(.custom(selectedFont, size: computedFontSize))
                .stroke(color: .white, width: 0.6)
                .foregroundColor(.black)
                .position(textPos3)
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    TileDesignView(tile: Tile(line1: 9, line2: 7, line3: 8), size: 250, fontScale: 0.2, neonLine1: false, neonLine2: false, neonLine3: false)
}
