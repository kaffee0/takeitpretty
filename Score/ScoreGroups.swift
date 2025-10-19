//
//  ScoreGroups.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/02/11.
//
import Foundation

struct ScoreGroups {
    let line1Groups: [[HexCell]]
    let line2Groups: [[HexCell]]
    let line3Groups: [[HexCell]]
}

func calculateScoreGroups(from cells: [HexCell]) -> ScoreGroups {

    let groupsByQ = Dictionary(grouping: cells, by: { $0.q }).map { $0.value }
    let validLine1Groups = groupsByQ.filter { group in
        guard group.allSatisfy({ $0.tile != nil && $0.isFixed }) else { return false }
        let commonValue = group.first!.tile!.line1
        return group.allSatisfy({ $0.tile!.line1 == commonValue }) &&
               ([1, 5, 9].contains(commonValue))
    }
    
    let secondLineGroupNumbers: [[Int]] = [
        [19, 16, 12],
        [18, 15, 11, 7],
        [17, 14, 10, 6, 3],
        [13, 9, 5, 2],
        [8, 4, 1]
    ]
    let validLine2Groups = secondLineGroupNumbers.compactMap { groupNumbers -> [HexCell]? in
        let group = cells.filter { groupNumbers.contains($0.number) }
        guard !group.isEmpty,
              group.allSatisfy({ $0.tile != nil && $0.isFixed }),
              let commonValue = group.first?.tile?.line2,
              group.allSatisfy({ $0.tile!.line2 == commonValue }) else {
            return nil
        }
        return group
    }

    let groupsByR = Dictionary(grouping: cells, by: { $0.r }).map { $0.value }
    let validLine3Groups = groupsByR.filter { group in
        guard group.allSatisfy({ $0.tile != nil && $0.isFixed }) else { return false }
        let commonValue = group.first!.tile!.line3
        return group.allSatisfy({ $0.tile!.line3 == commonValue })
    }
    
    return ScoreGroups(line1Groups: validLine1Groups,
                       line2Groups: validLine2Groups,
                       line3Groups: validLine3Groups)
}
