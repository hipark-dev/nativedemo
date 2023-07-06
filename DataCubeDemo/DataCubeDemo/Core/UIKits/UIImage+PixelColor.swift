//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit

extension UIImage {

    subscript (xPos: Int, yPos: Int) -> UIColor? {

        if xPos < 0 || xPos > Int(size.width) || yPos < 0 || yPos > Int(size.height) {
            return nil
        }
        
        guard let cgImage = self.cgImage else {
            return nil
        }
        
        guard let provider = cgImage.dataProvider else {
            return nil
        }
        let providerData = provider.data
        
        guard let data = CFDataGetBytePtr(providerData) else {
            return nil
        }
        
        let numberOfComponents = 4
        let pixelData = ((Int(size.width) * yPos) + xPos) * numberOfComponents

        let rValue = CGFloat(data[pixelData]) / 255.0
        let gValue = CGFloat(data[pixelData + 1]) / 255.0
        let bValue = CGFloat(data[pixelData + 2]) / 255.0
        let aValue = CGFloat(data[pixelData + 3]) / 255.0

        return UIColor(red: rValue, green: gValue, blue: bValue, alpha: aValue)
    }
    
}
