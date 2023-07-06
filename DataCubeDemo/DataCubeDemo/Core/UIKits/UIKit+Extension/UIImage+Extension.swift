//
//  UIImage+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import Foundation
import UIKit

extension UIImage {

    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        // Move origin to middle
        context.translateBy(x: newSize.width / 2, y: newSize.height / 2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    func darkened() -> UIImage? {
           UIGraphicsBeginImageContextWithOptions(size, false, 0)
           defer { UIGraphicsEndImageContext() }

           guard let ctx = UIGraphicsGetCurrentContext(), let cgImage = cgImage else {
               return nil
           }

           // flip the image, or result appears flipped
           ctx.scaleBy(x: 1.0, y: -1.0)
           ctx.translateBy(x: 0, y: -size.height)

           let rect = CGRect(origin: .zero, size: size)
           ctx.draw(cgImage, in: rect)
           UIColor(white: 0, alpha: 0.3).setFill()
           ctx.fill(rect)

           return UIGraphicsGetImageFromCurrentImageContext()
       }
}
    
extension UIImage {
    /// ## EX1: UIImage(named: .bottom as CommonImage.ChevronDirection)
    /// ## EX:2 UIImage(named: CommonImage.ChevronDirection.bottom)
    convenience init?<T>(named name: T) where T: RawRepresentable, T.RawValue == String {
        self.init(named: name.rawValue)
    }
}
