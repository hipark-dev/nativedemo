//
//  Enum+Collection.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import Foundation

protocol EnumCollection: Hashable, CaseIterable {
    static var count: Int { get }
    var indexValue: Int { get }
}

extension EnumCollection {
    var indexValue: Int {
        guard let index = Self.allCases.firstIndex(where: { $0 == self }) as? Int else {
            return 0
        }
        return index
    }
}
extension EnumCollection {
    static var count: Int { Self.allCases.count }
}

protocol EnumCaseFormatable: EnumCollection, RawRepresentable {}
extension EnumCaseFormatable {
    func stringWith(format: String,
                    unknownCase: Self,
                    unknwonCasePlaceHolder: String = "__unknown__") -> String {
        switch self {
        case unknownCase:
            return unknwonCasePlaceHolder
        default:
            guard let rawValue = self.rawValue as? CVarArg else { return unknwonCasePlaceHolder }
            return String(format: format, rawValue)
        }
    }
}
