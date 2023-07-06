//
//  UIImageView+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import Foundation
import UIKit

extension UIImageView {

    func gradient() {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        
        gradient.colors = [
          UIColor(red: 255, green: 255, blue: 255, alpha: 0).cgColor,
          UIColor(red: 253, green: 253, blue: 253, alpha: 0).cgColor,
          UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        ]
        
        gradient.locations = [0, 0.3, 1]
        
        self.layer.addSublayer(gradient)
        
    }

}
