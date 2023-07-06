//
//  Int+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit

extension Int {
    /**
     ex) ordinal
     english: 25 -> 25th
     korean : 25 -> 25번째
     */
    @available(*, deprecated, renamed: "ordinalString")
    var ordinal: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        return numberFormatter.string(from: self as NSNumber) ?? String(self)
    }
    
    @available(*, deprecated, renamed: "decimalString")
    var withComma: String {
        let decimalFormatter = NumberFormatter()
        decimalFormatter.numberStyle = .decimal
        return decimalFormatter.string(from: self as NSNumber) ?? String(self)
    }
    
    @available(*, deprecated, renamed: "percentString")
    var percent: String {
        String(self) + UIConstant.percent
    }
    
    @available(*, deprecated, renamed: "currencyString")
    var decimalCurrency: String {
        UIConstant.monetary + withComma
    }
    
    @available(*, deprecated, renamed: "currencyString(_:)")
    var decimalCurrencyWithSpace: String {
        UIConstant.monetary + UIConstant.space + withComma
    }
    
    var string: String {
        String(self)
    }
    
    var remainderDividedBy10: Int {
        (self > 10) ? (self % 10) : self
    }
}

extension Int64 {
    @available(*, deprecated, renamed: "currencyString")
    var decimalCurrency: String {
        UIConstant.monetary + withComma
    }
    @available(*, deprecated, renamed: "currencyString(_:)")
    var decimalCurrencyWithSpace: String {
        UIConstant.monetary + UIConstant.space + withComma
    }
    @available(*, deprecated, renamed: "decimalString")
    var withComma: String {
        let decimalFormatter = NumberFormatter()
        decimalFormatter.numberStyle = NumberFormatter.Style.decimal
        decimalFormatter.groupingSeparator = ","
        decimalFormatter.groupingSize = 3
        
        return decimalFormatter.string(from: self as NSNumber) ?? String(self)
    }
}

extension Int {
    @available(*, deprecated, renamed: "asCGFloat")
    var cgFloat: CGFloat {
        CGFloat(self)
    }
    @available(*, deprecated, renamed: "isZero")
    func isZero() -> Bool {
        isZero
    }
}

extension Int {
    var monthName: String? {
        DateFormatter().monthSymbols[safe: self - 1]
    }
    
    var shortMonthName: String? {
        DateFormatter().shortMonthSymbols[safe: self - 1]
    }
}

extension Int {
    var toMinutes: String {
        String(format: "%0.2d", (self / 60) % 60)
    }
    
    var toSeconds: String {
        String(format: "%0.2d", self % 60)
    }
}

extension Int {
    var sign: String {
        switch self {
        case 0: return .empty
        case ..<0: return "-"
        default: return "+"
        }
    }
}
