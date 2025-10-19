//
//  MiniBoardView.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/03/28.
//

import SwiftUI
import FirebaseFirestore

struct MiniBoardView: View {
    let placements: [[String: String]]
    let tiles: [[String: Int]]
    let previewSize: CGFloat

    var body: some View {
        GeometryReader { geo in
            let hexRadius = previewSize / 7
            let hexSize = hexRadius * 2
            let baseCells = buildBoardCells(hexRadius: hexRadius)
            let boardCenter = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            
            BoardGridView(
                cells: baseCells,
                hexSize: hexSize,
                boardCenter: boardCenter
//                animationDelays: [:],
//                neonActivations: [:]
            )
        }
        .frame(width: previewSize, height: previewSize)
        .padding(20)
    }

    func buildBoardCells(hexRadius: CGFloat) -> [HexCell] {
        var baseCells = generateCells(hexRadius: hexRadius)
        for i in placements.indices {
            if let posString = placements[i]["position"] {
                let comps = posString.split(separator: ",")
                if comps.count == 2,
                   let q = Int(comps[0]),
                   let r = Int(comps[1]),
                   let cellIndex = baseCells.firstIndex(where: { $0.q == q && $0.r == r }) {
                    let tileDict = tiles[i]
                    let tile = Tile(
                        line1: tileDict["line1"] ?? 0,
                        line2: tileDict["line2"] ?? 0,
                        line3: tileDict["line3"] ?? 0
                    )
                    baseCells[cellIndex].tile = tile
                    baseCells[cellIndex].isFixed = true
                }
            }
        }
        return baseCells
    }

    func generateCells(hexRadius: CGFloat) -> [HexCell] {
        var cells: [HexCell] = []
        var index = 1
        for q in -2...2 {
            
            let rMin = max(-2, -q - 2)
            let rMax = min(2, -q + 2)
            for r in rMin...rMax {
                var cell = HexCell(q: q, r: r, number: index)
                let x = hexRadius * (3/2 * CGFloat(q))
                let y = hexRadius * (sqrt(3) * (CGFloat(r) + CGFloat(q)/2))
                cell.center = CGPoint(x: x, y: y)
                cells.append(cell)
                index += 1
            }
        }
        
        let xs = cells.map { $0.center.x }
        let ys = cells.map { $0.center.y }
        if let minX = xs.min(), let maxX = xs.max(),
           let minY = ys.min(), let maxY = ys.max() {
            let boardWidth = maxX - minX
            let boardHeight = maxY - minY
            let offsetX = -(minX + boardWidth/2)
            let offsetY = -(minY + boardHeight/2)
            for i in 0..<cells.count {
                cells[i].center.x += offsetX
                cells[i].center.y += offsetY
            }
        }
        return cells
    }
}

#Preview {
    MiniBoardView(
        placements: [
            ["position": "0,0"],
            ["position": "1,-1"],
            ["position": "-1,1"],
            ["position": "0,1"],
            ["position": "1,0"],
            ["position": "-2,0"]
        ],
        tiles: [
            ["line1": 9, "line2": 7, "line3": 8],
            ["line1": 5, "line2": 6, "line3": 2],
            ["line1": 1, "line2": 7, "line3": 9],
            ["line1": 2, "line2": 4, "line3": 6],
            ["line1": 3, "line2": 5, "line3": 7],
            ["line1": 2, "line2": 8, "line3": 9]
        ],
        previewSize: 400
    )
}
