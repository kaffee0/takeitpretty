//
//  GameBoardViewModel.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/02/07.
//

import SwiftUI
import GameplayKit

struct SeededGenerator: RandomNumberGenerator {
    private var rng: GKMersenneTwisterRandomSource

    init(seed: UInt64) {
        self.rng = GKMersenneTwisterRandomSource(seed: seed)
    }

    mutating func next() -> UInt64 {
        return UInt64(bitPattern: Int64(rng.nextInt()))
    }
}

class GameBoardViewModel: ObservableObject {
    @Published var cells: [HexCell] = []
    @Published var currentTile: Tile = Tile(line1: 9, line2: 7, line3: 8)
    @Published var deck: [Tile] = []
    @Published var isBattleMode: Bool = false
    @Published var opponentScore: Int? = nil
    
    var hexRadius: CGFloat = 40
    var hexSize: CGFloat { hexRadius * 2 }
    var maxSnapDistance: CGFloat { hexSize * 0.8 }
    
    
    var score: Int {
        ScoreCalculator(cells: cells).calculateScore()
    }
    
    init() {
        resetBoard()
    }
    
    init(commonSeed: Int) {
        resetBoardWithSeed(commonSeed)
    }
    
    func resetBoard() {
        print("🔥 resetBoard() 実行！")
        resetDeck()
        generateCells()
        drawNextTile()
        print("🟢 resetBoard() 完了！")
    }

    func resetDeck() {
        var allTiles: [Tile] = []
        let line1Choices = [1,5,9]
        let line2Choices = [7,6,2]
        let line3Choices = [8,3,4]
        for l1 in line1Choices {
            for l2 in line2Choices {
                for l3 in line3Choices {
                    allTiles.append(Tile(line1: l1, line2: l2, line3: l3))
                }
            }
        }
        deck = allTiles.shuffled()
    }
    
    /// 🎲 次のタイルを引く
    func drawNextTile() {
        if let next = deck.first {
            currentTile = next
            deck.removeFirst()
        } else {
            resetDeck()
            drawNextTile()
        }
    }

    func generateCells() {
        cells = []
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
        guard let minX = xs.min(), let maxX = xs.max(),
              let minY = ys.min(), let maxY = ys.max() else { return }
        let boardWidth = maxX - minX
        let boardHeight = maxY - minY
        let offsetX = -(minX + boardWidth/2)
        let offsetY = -(minY + boardHeight/2)
        
        for i in 0..<cells.count {
            cells[i].center.x += offsetX
            cells[i].center.y += offsetY
        }
    }

    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2))
    }


    func cellForDrop(at dropPoint: CGPoint) -> HexCell? {
        let candidates = cells.filter { !$0.isFixed }
        let sorted = candidates.sorted { distance($0.center, dropPoint) < distance($1.center, dropPoint) }
        if let cell = sorted.first, distance(cell.center, dropPoint) <= maxSnapDistance {
            return cell
        }
        return nil
    }

    func placeTile(_ tile: Tile, at cellID: UUID) {
        if let index = cells.firstIndex(where: { $0.id == cellID }) {
            if !cells[index].isFixed {
                cells[index].tile = tile
            }
        }
    }

    func fixTile(at cellID: UUID) {
        if let index = cells.firstIndex(where: { $0.id == cellID }) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                cells[index].isFixed = true
            }
        }
    }

    private func generateHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    func isGameComplete() -> Bool {
        return cells.filter { $0.tile != nil && $0.isFixed }.count == cells.count
    }
    
    func tilesForSaving() -> [[String: Int]] {
        return cells.compactMap { cell in
            guard let tile = cell.tile else { return nil }
            return [
                "line1": tile.line1,
                "line2": tile.line2,
                "line3": tile.line3
            ]
        }
    }

    func placementsForSaving() -> [[String: String]] {
        return cells.compactMap { cell in
            guard cell.tile != nil else { return nil }
            return [
                "position": "\(cell.q),\(cell.r)"
            ]
        }
    }

    func resetBoardWithSeed(_ seed: Int) {
        print("🔥 resetBoardWithSeed(\(seed)) 実行！")
        isBattleMode = true
        var allTiles: [Tile] = []
        let line1Choices = [1,5,9]
        let line2Choices = [7,6,2]
        let line3Choices = [8,3,4]
        for l1 in line1Choices {
            for l2 in line2Choices {
                for l3 in line3Choices {
                    allTiles.append(Tile(line1: l1, line2: l2, line3: l3))
                }
            }
        }
        var generator = SeededGenerator(seed: UInt64(seed))
        deck = allTiles.shuffled(using: &generator)
        generateCells()
        drawNextTile()
        print("🟢 resetBoardWithSeed() 完了！")
    }
}
