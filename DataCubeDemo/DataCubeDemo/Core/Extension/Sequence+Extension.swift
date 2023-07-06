//
//  Sequence+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import Foundation

extension Sequence {
    var anySequence: [Any]? {
        self as? [Any]
    }
}

func zip(_ anySequences: [Any]... ) -> [[Any]] {
    let count = anySequences.map { $0.count }.min() ?? 0
    return (0..<count).map { index in anySequences.map { $0[index] } }
}

struct IntervalAppliedSequence: Sequence, IteratorProtocol {
    typealias Element = Int
    var current: Int
    var interval: Int
    var max: Int
    
    mutating func next() -> Int? {
        guard current <= max else { return nil }
        defer { current += interval }
        return current
    }
}
