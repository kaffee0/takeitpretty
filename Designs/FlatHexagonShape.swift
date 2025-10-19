//
//  FlatHexagonShape.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/02/07.
//

import SwiftUI

struct FlatHexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        let s = min(rect.width / 2, rect.height / sqrt(3))
        let hexHeight = sqrt(3) * s
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let p1 = CGPoint(x: center.x - s/2, y: center.y - hexHeight/2)
        let p2 = CGPoint(x: center.x + s/2, y: center.y - hexHeight/2)
        let p3 = CGPoint(x: center.x + s,   y: center.y)
        let p4 = CGPoint(x: center.x + s/2, y: center.y + hexHeight/2)
        let p5 = CGPoint(x: center.x - s/2, y: center.y + hexHeight/2)
        let p6 = CGPoint(x: center.x - s,   y: center.y)
        
        var path = Path()
        path.move(to: p1)
        path.addLine(to: p2)
        path.addLine(to: p3)
        path.addLine(to: p4)
        path.addLine(to: p5)
        path.addLine(to: p6)
        path.closeSubpath()
        return path
    }
}

func flatHexagonVertices(size: CGFloat) -> [CGPoint] {
    let s = min(size / 2, size / sqrt(3))
    let hexHeight = sqrt(3) * s
    let center = CGPoint(x: size/2, y: size/2)
    let p1 = CGPoint(x: center.x - s/2, y: center.y - hexHeight/2)
    let p2 = CGPoint(x: center.x + s/2, y: center.y - hexHeight/2)
    let p3 = CGPoint(x: center.x + s,   y: center.y)
    let p4 = CGPoint(x: center.x + s/2, y: center.y + hexHeight/2)
    let p5 = CGPoint(x: center.x - s/2, y: center.y + hexHeight/2)
    let p6 = CGPoint(x: center.x - s,   y: center.y)
    return [p1, p2, p3, p4, p5, p6]
}
