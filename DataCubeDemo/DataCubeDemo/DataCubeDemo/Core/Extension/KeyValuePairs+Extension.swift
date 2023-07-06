//
//  KeyValuePairs+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//
import Foundation

extension KeyValuePairs where Key: RawRepresentable & Equatable {
    subscript(key: Key) -> (key: Key, value: Value)? {
        filter { $0.key == key }.first
    }
}
