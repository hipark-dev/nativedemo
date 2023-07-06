//
//  Numbers.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit

protocol NumberConvertible {}
extension NumberConvertible where Self: BinaryInteger {

    var greaterThanZero: Bool { self > .zero }
    var lessThanZero: Bool { self <= .zero }
    
    var asDouble: Double {
        Double(self)
    }
    
    var asCGFloat: CGFloat {
        CGFloat(self)
    }
    
    var isZero: Bool {
        self == Self.zero
    }
    
    var isPositive: Bool {
        self > Self.zero
    }
    
    var asInt32: Int32 {
        guard self >= Int32.min && self < Int32.max else { return .zero }
        return Int32(self)
    }
    
    var asInt: Int {
        guard self >= Int.min &&
            self <= Int.max else {
                assertionFailure("Assertion Failure! not a Int")
                return 0
        }
        return Int(self)
    }
    
    var asInt64: Int64 {
        guard self >= Self(Int64.min) &&
            self <= Self(Int64.max) else {
                assertionFailure("Assertion Failure! not a Int")
                return 0
        }
        return Int64(self)
    }
    
    var asDecimal: Decimal {
        let copy = Int(self)
        guard self.isZero == false else { return .zero }
        let exactlyValue = Decimal(copy)
        guard exactlyValue.isNormal else {
            assertionFailure("Decimal value is Abnormal")
            return Decimal.zero
        }
        return exactlyValue
    }
    
    var stringValue: String {
        self.description
    }
    
    var isOdd: Bool { self % 2 == 0 }
}

extension NumberConvertible where Self: BinaryFloatingPoint {
    
    static var min: Self {
        Self.leastNormalMagnitude
    }
    
    static var max: Self {
        Self.greatestFiniteMagnitude
    }
    
    var asInt: Int {
        guard self.isZero == false else { return .zero }
        guard self >= Self(Int.min).nextUp &&
            self <= Self(Int.max).nextDown else {
            assertionFailure("Assertion Failure! value is Overflow")
            return 0
        }
        return Int(self)

    }
    
    var asInt64: Int64 {
        guard self.isZero == false else { return .zero }
        guard self >= Self(Int64.min).nextUp &&
            self <= Self(Int64.max).nextDown else {
            assertionFailure("Assertion Failure! value is Overflow")
            return 0
        }
        return Int64(self)
    }
    
    var asUInt64: UInt64 {
        guard self.isZero == false else { return .zero }
        guard self >= Self(UInt64.min).nextUp &&
            self <= Self(UInt64.max).nextDown else {
                assertionFailure("Assertion Failure! value is Overflow")
                return 0
        }
        
        return UInt64(self)
    }
    
    var asFloat: Float {
        guard self.isZero == false else { return .zero }
        guard self >= Self(Float.min).nextUp &&
            Double(self) <= Double(Float.max).nextDown else {
            assertionFailure("Assertion Failure! value is Overflow")
            return 0
        }
        return Float(self)
    }
    
    var asDouble: Double {
        Double(self)
    }
    
    /// CGFloat's NativeType is Double
    var asCGFloat: CGFloat {
        CGFloat(self)
    }
    
    var isZero: Bool {
        self == Self.zero
    }
    
    var asDecimal: Decimal {
        guard self.isZero == false else { return .zero }
        guard let selfAsDouble = self as? Double else {
            assertionFailure("Assetion failure! can not cast to Double value")
            return Decimal.zero
        }
        return Decimal(selfAsDouble)
    }
}

/*
    isNormal filter: zero, subnormal, infinity, nan
    subnormal = least Normal Magnitude & non zero
    infinity = greater then greatest Finite Magnitude
    nan = Not a number (non Decimal, non binary integer, non binary floating point)
 */
extension NumberConvertible where Self == Decimal {
    
    var asDouble: Double {
        guard self.isZero == false else { return .zero }
        guard self.isNormal &&
            self >= Decimal(Double.min).nextUp &&
            self <= Decimal(Double.max).nextDown else {
            assertionFailure("Assertion Failure! value is Invaild")
            return Double.zero
        }
        return NSDecimalNumber(decimal: self).doubleValue
    }
    
    var asCGFloat: CGFloat {
        guard self.isZero == false else { return .zero }
        guard self.isNormal &&
            self >= Decimal(Double.min).nextUp &&
            self <= Decimal(Double.max).nextDown else {
            assertionFailure("Assertion Failure! value is Invaild")
            return CGFloat.zero
        }
        return CGFloat(NSDecimalNumber(decimal: self).doubleValue)
    }
    
    var asInt: Int {
        guard self.isZero == false else { return .zero }
        guard self.isNormal &&
            self >= Decimal(Int.min) &&
            self <= Decimal(Int.max) else {
            assertionFailure("Assertion Failure! value is Invaild")
            return Int.zero
        }
        return self.decimalString.convertInt
    }
    
    var stringValue: String {
        self.description
    }
    
    var currencyString: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter.string(from: NSDecimalNumber(decimal: self)) ?? ""
    }
    
    var decimalString: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter.string(from: NSDecimalNumber(decimal: self)) ?? ""
    }
    
    // FIXME: empty case showing invalid value, suggetion: use var string: String?
    var formattedString: String {
        Formatter.numberStyleApplied().string(for: self) ?? ""
    }
    
    var noneStyleFormatedString: String? {
        Formatter.numberStyleApplied().string(for: self)
    }
}

extension Int: NumberConvertible {}
extension Int64: NumberConvertible {}
extension UInt: NumberConvertible {}
extension Int32: NumberConvertible {}
extension UInt32: NumberConvertible {}
extension UInt64: NumberConvertible {}
extension Float: NumberConvertible {}
extension Double: NumberConvertible {}
extension CGFloat: NumberConvertible {}
extension Decimal: NumberConvertible {}

extension Formatter {
    static func numberStyleApplied(_ style: NumberFormatter.Style = .none) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = style
        return formatter
    }
}
