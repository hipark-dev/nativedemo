//
//  Array+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import Foundation

extension Array where Element: Equatable {
    func isExist(_ value: Element) -> Bool {
        firstIndex(of: value) != nil
    }
}

extension Array where Element: Hashable {
    func nextElement(of element: Element?) -> Element? {
        guard let element = element else { return nil }
        if let index = self.firstIndex(of: element), index + 1 < self.count {
            return self[index + 1]
        }
        return nil
    }
    
    func hasNext(of index: Int) -> Bool {
        (index + 1) < self.count
    }
    
    func previousElement(of element: Element?) -> Element? {
        guard let element = element else { return nil }
        if let index = self.firstIndex(of: element), index - 1 >= 0 {
            return self[index - 1]
        }
        return element
    }
    
    func hasPrevious(of index: Int) -> Bool {
        if index > count {
            return false
        }
        return (index - 1) >= 0
    }
    
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}

extension Array where Element: Equatable {
    func indexes(of element: Element) -> [Int] {
        self.enumerated().filter({ element == $0.element }).map({ $0.offset })
    }
}

extension Array {
    subscript(safe index: Int) -> Element? { indices ~= index ? self[index] : nil }
}
