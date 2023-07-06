//
//  HasSort.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import Foundation

protocol HasSort {
    var sort: Int? { get }
}

extension Array where Element: HasSort {
    func getSortItems(isDescending: Bool) -> [Element] {
        let sortingValue = self.sorted { value1, value2 in
            guard let valueSort1 = value1.sort, let valueSort2 = value2.sort else {
                return false
            }
            
            let ascendingValue = valueSort1 < valueSort2
            return isDescending ? !ascendingValue : ascendingValue
        }
        
        return sortingValue
    }
}
