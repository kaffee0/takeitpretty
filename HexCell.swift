//
//  HexCell.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/02/07.
//

import SwiftUI

struct HexCell: Identifiable {
    let id = UUID()
    let q: Int
    let r: Int
    var center: CGPoint = .zero
    var tile: Tile? = nil
    var isFixed: Bool = false
    var number: Int = 0
}

struct Tile: Identifiable, Equatable, Hashable {
    let id = UUID()
    let line1: Int
    let line2: Int
    let line3: Int
}

func colorForDigit(_ digit: Int) -> Color {
    switch digit {
    case 1: return Color(red: 0.70, green: 0.70, blue: 0.70)
    case 2: return Color(red: 1.00, green: 0.80, blue: 0.85)
    case 3: return Color(red: 0.95, green: 0.75, blue: 0.80)
    case 4: return Color(red: 0.70, green: 0.80, blue: 0.90)
    case 5: return Color(red: 0.60, green: 0.80, blue: 0.75)
    case 6: return Color(red: 1.00, green: 0.60, blue: 0.65)
    case 7: return Color(red: 0.70, green: 0.85, blue: 0.70)
    case 8: return Color(red: 1.00, green: 0.70, blue: 0.40)
    case 9: return Color(red: 1.00, green: 1.00, blue: 0.80)
    default: return .black
    }
}

func neonStrokeColor(for digit: Int) -> Color {
    let base: (red: Double, green: Double, blue: Double)
    switch digit {
    case 1: base = (0.70, 0.70, 0.70)
    case 2: base = (1.00, 0.80, 0.85)
    case 3: base = (1.00, 0.85, 0.87)
    case 4: base = (0.70, 0.80, 0.90)
    case 5: base = (0.60, 0.80, 0.75)
    case 6: base = (1.00, 0.60, 0.65)
    case 7: base = (0.70, 0.85, 0.70)
    case 8: base = (1.00, 0.85, 0.70)
    case 9: base = (1.00, 1.00, 0.80)
    default: base = (0, 0, 0)
    }
    return Color(
        red: min(base.red + 0.05, 1.0),
        green: min(base.green + 0.05, 1.0),
        blue: min(base.blue + 0.05, 1.0)
    )
}
