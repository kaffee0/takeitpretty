//
//  RestTileView.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/03/13.
//

import SwiftUI

struct RestTileView: View {
    
    let allTiles: [Tile] = generateAllTiles()
    let usedTiles: [Tile]
    let tileSize: CGFloat = 68

    var remainingTiles: [Tile] {
        allTiles.filter { tile in
            !usedTiles.contains(where: { $0.line1 == tile.line1 && $0.line2 == tile.line2 && $0.line3 == tile.line3 })
        }
    }
    
    var body: some View {
        ZStack {
            Color.clear 
                .edgesIgnoringSafeArea(.all)
            VStack {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 8) {
                        ForEach(remainingTiles, id: \.self) { tile in
                            TileDesignView(tile: tile, size: tileSize, fontScale: 0.25)
                        }
                    }
                    .padding()
                }
            }
            .padding(10)
            .background(Color(red: 229/255, green: 151/255, blue: 178/255))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 8)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

func generateAllTiles() -> [Tile] {
    var tiles: [Tile] = []
    
    for l1 in [1, 5, 9] {
        for l2 in [2, 6, 7] {
            for l3 in [3, 4, 8] {
                tiles.append(Tile(line1: l1, line2: l2, line3: l3))
            }
        }
    }
    return tiles
}
