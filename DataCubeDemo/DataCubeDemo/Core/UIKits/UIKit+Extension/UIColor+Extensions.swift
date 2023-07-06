//
//  UIColor+Extensions.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import Foundation
import UIKit

extension UIColor {
    ///Using: UIColor.rgb(88, 193, 92)
    static func rgb(_ red: Int, _ green: Int, _ blue: Int, _ alpha: CGFloat = 1.0) -> UIColor {
        UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    // Normalize RGB
    static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1.0) -> UIColor {
        if red > 1 || green > 1 || blue > 1 {
            Logger.error("Using Normalized RGB - R: \(red), G: \(blue), B: \(blue)")
        }
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    ///Using: UIColor.hexadecimal(0x58C15C)
    static func hexadecimal(_ value: UInt32, _ alpha: CGFloat = 1.0) -> UIColor {
        UIColor.rgb(Int((value & 0xFF0000) >> 16),
                    Int((value & 0xFF00) >> 8),
                    Int(value & 0xFF),
                    alpha)
    }
    
    ///Using: UIColor.hexadecimal("#58C15C")
    ///Using: UIColor.hexadecimal("58C15C")
    static func hexadecimal(_ value: String, _ alpha: CGFloat = 1.0) -> UIColor {
        let alphanumerics = value.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        return UIColor.hexadecimal(UInt32(alphanumerics, radix: 16) ?? 0, alpha)
    }
    
    static func randomBackgroundColor() -> UIColor {
        let colors = [UIColor.rgb(5, 200, 123), UIColor.rgb(176, 158, 145), UIColor.rgb(106, 97, 248), UIColor.rgb(33, 173, 254), UIColor.rgb(249, 135, 40)]
        let randomIndex = Int(arc4random_uniform(UInt32(colors.count)))
        return colors[randomIndex]
    }
}

extension UIColor {
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let multiplier = CGFloat(255.999999)
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        } else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
    
    static var dimmedColor: UIColor {
        .hexadecimal(0x000000, 0.6)
    }
    
    static var halfDimmedColor: UIColor {
        .hexadecimal(0xffffff, 0.6)
    }
    
    static var shinyDimmedColor: UIColor {
        .hexadecimal(0xffffff, 0.5)
    }
}
