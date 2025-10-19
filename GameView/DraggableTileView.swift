//
//  DraggableTileView.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/02/07.
//

import SwiftUI

struct DraggableTileView: View {
    let tile: Tile
    let size: CGFloat
    let boardCenter: CGPoint
    @Binding var position: CGPoint
    @Binding var dragOffset: CGSize
    var onDrop: (CGPoint) -> Void

    var body: some View {
        TileDesignView(tile: tile, size: size, fontScale: 0.25)
            .position(position)
            .offset(dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                    }
                    .onEnded { value in
                        let finalPos = CGPoint(
                            x: position.x + value.translation.width,
                            y: position.y + value.translation.height
                        )
                        let dropPoint = CGPoint(
                            x: finalPos.x - boardCenter.x,
                            y: finalPos.y - boardCenter.y
                        )
                        onDrop(dropPoint)
                    }
            )
    }
}


