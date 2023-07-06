//
//  UIView+Nib.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit

extension UIView {
    func loadNib() -> UIView {
        guard let nibName = type(of: self).description().components(separatedBy: ".").last else {
            fatalError("Could not load nib with name: \(type(of: self).description())")
        }
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        
        guard let unwrappedNib = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("Could not instantiate view with name: \(nibName)")
        }
        
        return unwrappedNib
    }
}

protocol NibLoadableView: AnyObject {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        NSStringFromClass(self).components(separatedBy: ".").last ?? NSStringFromClass(self)
    }
    
    static func viewWithNib() -> Self {
        guard let view = UINib(nibName: nibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? Self else {
            fatalError("Could not instantiate view with name: \(nibName)")
        }
        return view
    }
}

extension UIView {
    static var nib: UINib {
        UINib(nibName: String(describing: self), bundle: nil)
    }

    static func instantiate(autolayout: Bool = true) -> Self {
        // generic helper function
        func instantiateUsingNib<T: UIView>(autolayout: Bool) -> T {
            guard let view = nib.instantiate() as? T else {
                fatalError("Could not instantiate view with name: \(nib)")
            }
            view.translatesAutoresizingMaskIntoConstraints = !autolayout
            return view
        }
        return instantiateUsingNib(autolayout: autolayout)
    }
}

extension UINib {
    func instantiate() -> Any? {
        self.instantiate(withOwner: nil, options: nil).first
    }
}
