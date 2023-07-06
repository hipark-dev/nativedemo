//
//  Style.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit

protocol Style {}

// MARK: - Font Declaration
enum StyleFont: Style {
    /// fontSize: 48
    case amount(weight: FontWeight)
    /// fontSize: 42
    case input(weight: FontWeight)
    /// fontSize: 40
    case input1(weight: FontWeight)
    /// fontSize: 28
    case input2(weight: FontWeight)
    /// fontSize: 27
    case input3(weight: FontWeight)
    /// fontSize: 26
    case key1(weight: FontWeight)
    /// fontSize: 25
    case nickname(weight: FontWeight)
    /// fontSize: 32
    case intro(weight: FontWeight)
    /// fontSize: 31
    case intro2(weight: FontWeight)
    /// fontSize: 34
    case head1
    /// fontSize: 30
    case head2
    /// fontSize: 24
    case head3(weight: FontWeight)
    /// fontSize: 22
    case head4(weight: FontWeight)
    /// fontSize: 21
    case head5(weight: FontWeight)
    /// fontSize: 20
    case head6(weight: FontWeight)
    /// fontSize: 27
    case head7(weight: FontWeight)
    /// fontSize: 19
    case subtitle1(weight: FontWeight)
    /// fontSize: 18
    case subtitle2(weight: FontWeight)
    /// fontSize: 16
    case subtitle3(weight: FontWeight)
    /// fontSize: 17
    case subtitle4(weight: FontWeight)
    /// fontSize: 16
    case body1(weight: FontWeight)
    /// fontSize: 15
    case body2(weight: FontWeight)
    /// fontSize: 14
    case body3(weight: FontWeight)
    /// fontSize: 13
    case body4(weight: FontWeight)
    /// fontSize: 12
    case body5
    /// fontSizey: 12
    case body6(weight: FontWeight)
    /// fontSize: 11
    case body7(weight: FontWeight)
    /// fontSize: 11
    case micro1
    /// fontSize: 10
    case micro2(weight: FontWeight)
    /// fontSize: 9
    case micro3
    case custom(size: CGFloat, weight: FontWeight)
    /// fontSize: 40
    case dinmed
}
// MARK: - Font Appearance
extension StyleFont {
    enum FontType {
        case system
        case dinmed
        
        var fontName: String {
            switch self {
            case .dinmed:
                return "DINPro-Medium"
            default:
                return ""
            }
        }
    }
    
    enum FontWeight {
        case regular
        case bold
        case heavy
    }
    
    var fontSize: CGFloat {
        switch self {
        case .amount: return 48
        case .input: return 42
        case .input1: return 40
        case .input2: return 28
        case .input3, .head7: return 27
        case .key1: return 26
        case .nickname: return 25
        case .intro: return 32
        case .intro2: return 31
        case .head1: return 34
        case .head2: return 30
        case .head3: return 24
        case .head4: return 22
        case .head5: return 21
        case .head6: return 20
        case .subtitle1: return 19
        case .subtitle2: return 18
        case .subtitle3: return 16
        case .subtitle4: return 17
        case .body1: return 16
        case .body2: return 15
        case .body3: return 14
        case .body4: return 13
        case .body5: return 12
        case .body6: return 12
        case .body7: return 11
        case .micro1: return 11
        case .micro2: return 10
        case .micro3: return 9
        case .custom(size: let size, weight: _): return size
        case .dinmed: return 40
        }
    }
}
// MARK: - Font Apply
extension StyleFont {
   var apply: UIFont {
        switch self {
        case .head1, .head2,
             .body5, .micro1, .micro3:
            return .systemFont(ofSize: self.fontSize, weight: .bold)
            
        case .dinmed:
            return UIFont(name: "DINPro-Medium", size: 40.0) ?? .systemFont(ofSize: self.fontSize)

        case .key1(let weight), .nickname(let weight), .intro(let weight), .intro2(let weight), .input(let weight),
             .input1(let weight), .input2(let weight), .input3(let weight), .head3(let weight),
             .head4(let weight), .head5(let weight), .head6(let weight), .head7(let weight),
             .subtitle1(let weight), .subtitle3(let weight), .subtitle2(let weight), .subtitle4(let weight),
             .body1(let weight), .body2(let weight), .body3(let weight), .body4(let weight),
             .body6(let weight), .body7(let weight), .amount(let weight), .custom(size: _, weight: let weight),
             .micro2(let weight):
            switch weight {
            case .regular: return .systemFont(ofSize: self.fontSize)
            case .bold: return .systemFont(ofSize: self.fontSize, weight: .bold)
            case .heavy: return .systemFont(ofSize: self.fontSize, weight: .heavy)
            }
        }
    }
}

enum StyleNumberFont: Style {
    /// fontSize - digit: 55, alphabet: 53
    case no1
    /// fontSize - digit: 48, alphabet: 46
    case no2
    /// fontSize - digit: 44, alphabet: 42
    case no3
    /// fontSize - digit: 40, alphabet: 39
    case no4
    /// fontSize - digit: 32, alphabet: 31
    case no5
    /// fontSize - digit: 38, alphabet: 38
    case no6
    /// fontSize - digit: 42, alphabet: 42
    case no7
    /// fontSize - digit: 14, alphabet: 14
    case no8
    /// fontSize - digit: 48, alphabet: 48
    case no9
    /// fontSize - digit: 44, alphabet: 44
    case no10
    
    var fontSize: (digit: CGFloat, alphabet: CGFloat) {
        switch self {
        case .no1: return (55, 53)
        case .no2: return (48, 46)
        case .no3: return (44, 42)
        case .no4: return (40, 39)
        case .no5: return (32, 31)
        case .no6: return (38, 38)
        case .no7: return (42, 41)
        case .no8: return (14, 14)
        case .no9: return (48, 48)
        case .no10: return (44, 44)
        }
    }
    
    var applyDigit: UIFont {
        guard let font = UIFont(name: StyleFont.FontType.dinmed.fontName, size: self.fontSize.digit) else {
            return .systemFont(ofSize: self.fontSize.digit)
        }
        
        return font
    }
    
    var applyAlphabet: UIFont {
        guard let font = UIFont(name: StyleFont.FontType.dinmed.fontName, size: self.fontSize.alphabet) else {
            return .systemFont(ofSize: self.fontSize.alphabet)
        }
        
        return font
    }
}
