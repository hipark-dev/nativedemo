//
//  HasLet.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import Foundation

protocol HasLet { }

extension HasLet {
    func lets(closure: (Self) -> Void) {
        closure(self)
    }
    
    @discardableResult func modify(_ closure: (inout Self) throws -> Void) rethrows -> Self {
        var copy = self
        try closure(&copy)
        return copy
    }
}

extension NSObject: HasLet { }

typealias ReferenceLets<T> = (inout T) -> Void
