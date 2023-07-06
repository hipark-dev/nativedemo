//
//  CGFloat+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit

extension CGFloat {
    var toDouble: Double {
        Double(self)
    }
    
    var toInt: Int {
        Int(self)
    }
    
    var negative: CGFloat {
        (self * -1)
    }
}
