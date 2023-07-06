//
//  Identifiable.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import Foundation

protocol Identifiable: Equatable {}
extension Identifiable {
    static func == (lhs: Self, rhs: Self) -> Bool { lhs.identifier == rhs.identifier }
    var identifier: String {
        guard let labeledIdentifier = Mirror(reflecting: self).children.first?.label else {
            return "\(self)"
        }
        return labeledIdentifier
    }
}
