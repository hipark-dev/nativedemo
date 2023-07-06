//
//  UINavigationBar+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit
import BonMot

extension UINavigationBar {
    func setTitleColor(_ color: UIColor) {
        self.titleTextAttributes = StringStyle(.color(color)).attributes
    }
}
