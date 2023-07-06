//
//  Numbers+String.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import Foundation
import UIKit

extension NumberConvertible where Self: BinaryInteger {
    /// "第65,535" , LOCALE: zh_Hant_TW, LOCALE: en-US: "65,535th"
    var ordinalString: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        return numberFormatter.string(from: (Int(self)) as NSNumber) ?? String(self)
    }
    /// default: en-US: "65,535th"
    func ordinalString(_ locale: Locale = Locale(identifier: "en-US")) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        numberFormatter.locale = locale
        return numberFormatter.string(from: (Int(self)) as NSNumber) ?? String(self)
    }
    
    /// "65,535"
    var decimalString: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter.string(from: Int(self) as NSNumber) ?? String(self)
    }
    
    /// "75%.00" == 0.75
    var percentString: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        return numberFormatter.string(from: Int(self) as NSNumber) ?? String(self)
    }
    
    /// "sixty-five thousand five hundred thirty-five", "六萬五千五百三十五"
    var spellOutString: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .spellOut
        return numberFormatter.string(from: Int(self) as NSNumber) ?? String(self)
    }
}

extension NumberConvertible where Self: BinaryFloatingPoint & LosslessStringConvertible {
    /// "75%.00" == 0.75
    var percentString: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        return numberFormatter.string(from: Double(self) as NSNumber) ?? String(self)
    }
    /// "0.7123%" == 0.007123, maximumFractionDigits: 4
    func percentString(_ maximumFractionDigits: Swift.Int = 0) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        numberFormatter.maximumFractionDigits = maximumFractionDigits
        return numberFormatter.string(from: Double(self) as NSNumber) ?? String(self)
    }
}

extension NumberConvertible where Self: BinaryInteger {
    func isLessThan(_ other: Self) -> Bool {
        self < other
    }
    
    func isLessOr(_ other: Self) -> Bool {
        self <= other
    }
    
    func isMoreThan(_ other: Self) -> Bool {
        self > other
    }
    
    func isMoreOr(_ other: Self) -> Bool {
        self >= other
    }
}
