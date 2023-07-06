//
//  Float+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import Foundation

extension Float {
    var toInt: Int {
        Int(self)
    }
    
    var toDouble: Double {
        Double(self)
    }
    
    var percent: String {
        String(self) + UIConstant.percent
    }
    
    var toInterestPercent: String {
        let divisor = pow(10.0, Float(3))
        let roundedVal = (self * divisor).rounded() / divisor
        if (roundedVal - ceil(roundedVal)) == 0 {
            return String(Int(roundedVal)) + UIConstant.percent
        }
        return String(roundedVal) + UIConstant.percent
    }
}
