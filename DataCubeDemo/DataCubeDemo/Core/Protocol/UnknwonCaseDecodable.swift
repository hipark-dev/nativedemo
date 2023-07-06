//
//  UnknownCaseDecodable.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import Foundation

/**
 for Decodable(&Codable) enum, unexpected decoded values exchange to unknowncase
 
 ```
 enum TrasnsactionCode: String, Codable, UnknownCaseDecodable {
    case authentication =   "1"
    case activates =        "2"
    case unknown =          "__unknown__"
 
    init(from decoder: Decoder) throws {
        self = try type(of: self).instance(from: decoder, unknownCase: .unknown)
    }
 }
 ```
 */
protocol UnknownCaseDecodable {}
extension UnknownCaseDecodable where Self: RawRepresentable, RawValue: Codable {
    static func instance(from decoder: Decoder, unknownCase: Self) throws -> Self {
        let contianter = try decoder.singleValueContainer()
        let decoded = try contianter.decode(RawValue.self)
        guard let instance = Self.init(rawValue: decoded) else {
            return unknownCase
        }
        return instance
    }
}

