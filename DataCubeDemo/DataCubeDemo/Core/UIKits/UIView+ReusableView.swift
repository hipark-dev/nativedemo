//
//  UIView+ReusableView.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit

public protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    
    // reusableIdentifier == ClassName
    public static var reuseIdentifier: String {
        String(describing: self)
    }
}
