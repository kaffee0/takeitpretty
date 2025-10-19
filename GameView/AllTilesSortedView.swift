//
//  AllTilesSortedView.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/02/07.
//

import SwiftUI

struct AllTilesSortedView: View {
    let tiles: [Tile] = {
        let line1Choices = [1, 5, 9]
        let line2Choices = [7, 6, 2]
        let line3Choices = [8, 3, 4]
        var result: [Tile] = []
        for a in line1Choices {
            for b in line2Choices {
                for c in line3Choices {
                    result.append(Tile(line1: a, line2: b, line3: c))
                }
            }
        }
        return result
    }()
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ForEach([1, 5, 9], id: \.self) { group in
                VStack(spacing: 10) {
                    ForEach(tiles.filter { $0.line1 == group }
                                .sorted {
                                    if $0.line2 != $1.line2 {
                                        return $0.line2 > $1.line2
                                    } else {
                                        return $0.line3 > $1.line3
                                    }
                                },
                            id: \.id) { tile in
                        TileDesignView(tile: tile, size: 80, fontScale: 0.25)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    AllTilesSortedView()
}
