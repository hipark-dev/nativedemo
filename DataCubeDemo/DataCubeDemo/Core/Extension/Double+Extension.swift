//
//  Double+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit

extension Double {
    var toString: String {
      String(self)
    }
    
    var percent: String {
        String(self) + UIConstant.percent
    }
    
    var cgFloat: CGFloat {
        CGFloat(self)
    }
    
    var toInt: Int {
        Int(self)
    }
    
    var asDate: Date {
        Date(timeIntervalSince1970: self / 1000)
    }

    var withComma: String {
        let decimalFormatter = NumberFormatter()
        decimalFormatter.numberStyle = NumberFormatter.Style.decimal
        decimalFormatter.groupingSeparator = ","
        decimalFormatter.groupingSize = 3
        
        return decimalFormatter.string(from: self as NSNumber) ?? String(self)
    }
    
    var toInterestPercent: String {
        let divisor = pow(10.0, Double(3))
        let roundedVal = (self * divisor).rounded() / divisor
        if (roundedVal - ceil(roundedVal)) == 0 {
            return String(Int(roundedVal)) + UIConstant.percent
        }
        return String(roundedVal) + UIConstant.percent
    }
}
