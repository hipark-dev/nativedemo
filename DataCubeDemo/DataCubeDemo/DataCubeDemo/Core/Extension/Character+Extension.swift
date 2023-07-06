//
//  Character+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit

extension Character {
    var asciiValue: Int {    
        let scalars = String(self).unicodeScalars
        return Int(scalars[scalars.startIndex].value)
        
    }
}
