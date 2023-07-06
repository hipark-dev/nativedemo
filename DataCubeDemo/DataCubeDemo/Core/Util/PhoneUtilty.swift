//
//  PhoneNumberValidator.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import Foundation
import CoreTelephony
import UIKit

class PhoneNumberValidator {
    
    // FIXME: After the UX hyphen guide has been defined
    let mask = "XX-XXXX-XXXX"
    
    func validate(text: String) -> Bool {
        true
    }
    
    func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
 
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func formattedNumberWithMasked(number: String) -> String {
        
        var result = ""
        var index = number.startIndex
        for ch in mask where index < number.endIndex {
            if ch == "X" {
                result.append(number[index])
                index = number.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}
