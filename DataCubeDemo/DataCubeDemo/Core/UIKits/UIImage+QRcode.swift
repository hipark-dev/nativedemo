//
//  UIImage+QRcode.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit
import CoreImage

private enum Constant {
    static let qrcodeGeneratorName = "CIQRCodeGenerator"
    static let qrcodeInputMessageKey = "inputMessage"
    static let qrcodeTransformScale: CGFloat = 12
    
    static let ciFilterInputImage = "inputImage"
}

extension URL {
    func qrImage(using color: UIColor, logo: UIImage? = nil) -> CIImage? {
        let tintedQRImage = qrImage?.tinted(using: color)
        
        guard let logo = logo?.cgImage else {
            return tintedQRImage
        }
        
        return tintedQRImage?.combined(with: CIImage(cgImage: logo))
    }
    
    var qrImage: CIImage? {
        guard let qrFilter = CIFilter(name: Constant.qrcodeGeneratorName),
            let qrData = absoluteString.data(using: String.Encoding.ascii) else {
                return nil
        }
        
        return with(qrFilter) {
            $0.setValue(qrData, forKey: Constant.qrcodeInputMessageKey)
            return $0.outputImage?.transformed(by: CGAffineTransform(scaleX: Constant.qrcodeTransformScale,
                                                                     y: Constant.qrcodeTransformScale))
        }
    }
}

extension CIImage {
    var transparent: CIImage? {
        inverted?.blackTransparent
    }
    
    var inverted: CIImage? {
        guard let invertedColorFilter = CIFilter(name: "CIColorInvert") else {
            return nil
        }
        
        invertedColorFilter.setValue(self, forKey: "inputImage")
        return invertedColorFilter.outputImage
    }
    
    var blackTransparent: CIImage? {
        guard let blackTransparentFilter = CIFilter(name: "CIMaskToAlpha") else {
            return nil
        }
        
        blackTransparentFilter.setValue(self, forKey: "inputImage")
        return blackTransparentFilter.outputImage
    }
    
    func tinted(using color: UIColor) -> CIImage? {
        guard
            let transparentQRImage = transparent,
            let filter = CIFilter(name: "CIMultiplyCompositing"),
            let colorFilter = CIFilter(name: "CIConstantColorGenerator") else {
                return nil
        }
        
        let ciColor = CIColor(color: color)
        colorFilter.setValue(ciColor, forKey: kCIInputColorKey)
        let colorImage = colorFilter.outputImage
        
        filter.setValue(colorImage, forKey: kCIInputImageKey)
        filter.setValue(transparentQRImage, forKey: kCIInputBackgroundImageKey)
        
        return filter.outputImage
    }
}

extension CIImage {
    func combined(with image: CIImage) -> CIImage? {
        guard let combinedFilter = CIFilter(name: "CISourceOverCompositing") else {
            return nil
        }
        
        let centerTransform = CGAffineTransform(translationX: extent.midX - (image.extent.size.width / 2),
                                                y: extent.midY - (image.extent.size.height / 2))
        combinedFilter.setValue(image.transformed(by: centerTransform), forKey: "inputImage")
        combinedFilter.setValue(self, forKey: "inputBackgroundImage")
        return combinedFilter.outputImage
    }
}
