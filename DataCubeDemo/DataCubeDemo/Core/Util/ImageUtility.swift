//
//  ImageUtility.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit
import RxSwift

struct ImageUtility {
    static func croppedImage(from originalImage: UIImage,
                             rectangle: CGRect,
                             orientation: UIImage.Orientation = .right) -> UIImage {
        let originalSize: CGSize = isLandscapeImage(originalImage) ? originalImage.size : originalImage.size.toggle()
        let cropRect = rectangle *= originalSize
        guard let cgImage = originalImage.cgImage?.cropping(to: cropRect)  else {
            return originalImage
        }
        return UIImage(cgImage: cgImage, scale: 1.0, orientation: orientation)
    }
    
    private static func isLandscapeImage(_ image: UIImage) -> Bool {
        [.left, .right].contains(image.imageOrientation)
    }
}

private extension CGSize {
    func toggle() -> CGSize {
        .init(width: height, height: width)
    }
    
    static func *= (lhs: inout CGSize, rhs: CGSize) {
        lhs.width *= rhs.width
        lhs.height *= rhs.height
    }
}

private extension CGRect {
    static func *= (_ rectangle: CGRect, size: CGSize) -> CGRect {
        var copiedRect = rectangle
        copiedRect.origin.x *= size.width
        copiedRect.origin.y *= size.height
        copiedRect.size *= size
        return copiedRect
    }
}
