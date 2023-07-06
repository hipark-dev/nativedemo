//
//  Bool+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//
import Foundation
extension Bool {
    var upperCase: String {
        self == true ? "Y" : "N"
    }
    var lowerCase: String {
        self == true ? "y" : "n"
    }
    
    static func && (lhs: Bool, rhs: @autoclosure () throws -> ExtendedBool) rethrows
        -> Bool {
            lhs ? try rhs().boolValue : false
    }
    
    var asExtendedBool: ExtendedBool {
        self ? .true : .false
    }
}
enum ExtendedBool: String, Codable {
    typealias RawValue = String
    case `true` = "Y"
    case `false` = "N"
}
extension ExtendedBool {
    init() { self = .false }
    init(rawValue: String) {
        if [true.lowerCase, true.upperCase, true.description].contains(rawValue) {
            self = .true
        } else {
            self = .false
        }
    }
    //FIXME : need to change name
    var toggleStatus: ExtendedBool {
        self == .false ? .true : .false
    }
}
extension ExtendedBool: ExpressibleByBooleanLiteral {
    init(booleanLiteral value: Bool) {
        self = value ? .`true` : .`false`
    }
    
    typealias BooleanLiteralType = Bool
    static func convertFromBooleanLiteral(value: Bool) -> ExtendedBool {
        value ? `true` : `false`
    }
    
    var boolValue: Bool {
        self == .true ? true : false
    }
}
extension ExtendedBool: Equatable {
    
    static func == (lhs: ExtendedBool, rhs: ExtendedBool) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
    
    static func == (lhs: ExtendedBool, rhs: Bool) -> Bool {
        lhs.boolValue == rhs
    }
    
    static func == (lhs: Bool, rhs: ExtendedBool) -> Bool {
        lhs == rhs.boolValue
    }
}
extension ExtendedBool: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine((boolValue ? 1 : 0) as UInt8)
    }
}
extension ExtendedBool {
    static prefix func ! (value: ExtendedBool) -> Bool {
        !value.boolValue
    }
    
    static func != (lhs: ExtendedBool, rhs: ExtendedBool) -> Bool {
        lhs.boolValue != rhs.boolValue
    }
    
    static func != (lhs: ExtendedBool, rhs: Bool) -> Bool {
        lhs.boolValue != rhs
    }
    
    static func != (lhs: Bool, rhs: ExtendedBool) -> Bool {
        lhs != rhs.boolValue
    }
    
    static func || (lhs: ExtendedBool, rhs: @autoclosure () throws -> Bool) rethrows
        -> Bool {
            lhs.boolValue ? true : try rhs()
    }
    
    static func || (lhs: ExtendedBool, rhs: @autoclosure () throws -> ExtendedBool) rethrows
        -> Bool {
            lhs.boolValue ? true : try rhs().boolValue
    }
    
    static func && (lhs: ExtendedBool, rhs: @autoclosure () throws -> Bool) rethrows
        -> Bool {
            lhs.boolValue ? try rhs() : false
    }
    
    mutating func toggle() {
        var copy = boolValue
        copy.toggle()
        self = .init(booleanLiteral: copy)
    }
}

extension ExtendedBool {
    init(from decoder: Decoder) throws {
        let container = try? decoder.singleValueContainer()
        // needs thrwos catch ?
        if let decodedBool = try? container?.decode(Bool.self) {
            self = .init(booleanLiteral: decodedBool)
            return
        }
        if let decodedString = try? container?.decode(String.self) {
            self = .init(rawValue: decodedString)
            return
        }
        self = false
    }
}
