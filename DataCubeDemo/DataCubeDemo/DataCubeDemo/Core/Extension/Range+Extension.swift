//
//  Range+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import Foundation

extension Range where Bound == Int {
    func tildeString() -> String {
        String(startIndex) + UIConstant.tilde + String(endIndex)
    }
    
    func tildeCurrencyString() -> String {
        let endIndexString = endIndex == 0 ? String("0") : String(endIndex - 1)
        return String(startIndex).decimalCurrency + UIConstant.tilde + endIndexString.decimalCurrency
    }
}

extension ClosedRange where Bound == Int {
    func tildeString() -> String {
        String(lowerBound) + UIConstant.tilde + String(upperBound)
    }
    
    func tildeCurrencyString() -> String {
        let endIndexString = upperBound == 0 ? String("0") : String(upperBound)
        return String(lowerBound).decimalCurrency + UIConstant.tilde + endIndexString.decimalCurrency
    }
    
    func tiledePercentString() -> String {
        let endIndexString = upperBound == 0 ? String("0") : String(upperBound)
        return String(lowerBound) + UIConstant.tilde + endIndexString + UIConstant.percent
    }
}
