//
//  BoardGridView.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/02/07.
//

import SwiftUI

struct BoardGridView: View {
    let cells: [HexCell]
    let hexSize: CGFloat
    let boardCenter: CGPoint
    let animationDelays: [UUID: Double] = [:]
    let neonActivations: [UUID: (line1: Bool, line2: Bool, line3: Bool)] = [:]

    var body: some View {
        ForEach(cells) { cell in
            FlatHexagonShape()
                .fill(Color(red: 1.00, green: 0.98, blue: 0.95))
                .frame(width: hexSize, height: hexSize)
                .overlay(
                    FlatHexagonShape()
                        .stroke(Color.black.opacity(0.3), lineWidth: 1)
                )
                .position(
                    x: boardCenter.x + cell.center.x,
                    y: boardCenter.y + cell.center.y
                )
            
            if let tile = cell.tile, cell.isFixed {
                let tileView = TileDesignView(
                    tile: tile,
                    size: hexSize,
                    fontScale: 0.25,
                    neonLine1: neonActivations[cell.id]?.line1 ?? false,
                    neonLine2: neonActivations[cell.id]?.line2 ?? false,
                    neonLine3: neonActivations[cell.id]?.line3 ?? false
                )
                .position(
                    x: boardCenter.x + cell.center.x,
                    y: boardCenter.y + cell.center.y
                )
                
                if let delay = animationDelays[cell.id] {
                    tileView.modifier(BounceModifier(delay: delay))
                } else {
                    tileView
                }
            }
        }
    }
}
