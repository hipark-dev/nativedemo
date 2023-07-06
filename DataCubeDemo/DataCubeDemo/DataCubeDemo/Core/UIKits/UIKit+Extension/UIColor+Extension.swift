//
//  UIColor+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit

final class ExtendedColor: Codable {
    var uiColor: UIColor
    
    var hexString: String? {
        uiColor.hexString
    }
    
    init(_ color: UIColor) {
        self.uiColor = color
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let hexString = try container.decode(String.self)
        self.uiColor = UIColor.hexadecimal(hexString)
    }
    
    public func encode(to encoder: Encoder) throws {
        assertionFailure("ExtendedColor doesn't define encoder")
    }
}

extension ExtendedColor: Equatable {
    static func == (lhs: ExtendedColor, rhs: ExtendedColor) -> Bool {
        lhs.uiColor == rhs.uiColor
    }
    
    static func == (lhs: ExtendedColor, rhs: UIColor) -> Bool {
        lhs.uiColor == rhs
    }
    
    static func == (lhs: UIColor, rhs: ExtendedColor) -> Bool {
        lhs == rhs.uiColor
    }
}

extension UIColor {
    var asExtendedColor: ExtendedColor {
        ExtendedColor(self)
    }
}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

