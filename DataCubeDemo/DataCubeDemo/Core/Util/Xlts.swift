//
//  Xlts.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import Foundation
import UIKit

@propertyWrapper
struct Xlts<T: XltsProtocol> {
    private let key: String

    var wrappedValue: T? = nil {
        didSet {
            wrappedValue?.set(key)
        }
    }

    init(_ key: String) {
        self.key = key
    }
}

protocol XltsProtocol {
    func set(_ key: String)
}

extension UIButton: XltsProtocol {
    func set(_ key: String) {
        setTitle(key, for: .normal)
    }
}

extension UILabel: XltsProtocol {
    func set(_ key: String) {
        text = key
    }
}
