//
//  Storyboard+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit

protocol Storyboard: AnyObject, HasApply, HasLet {
    static var defaultStoryboardName: String { get }
}

extension Storyboard where Self: UIViewController {
    static var defaultStoryboardName: String {
        String(describing: self)
    }
    
    static func storyboard() -> UIStoryboard {
        UIStoryboard(name: defaultStoryboardName, bundle: nil)
    }
    
    static func storyboard(_ storyboardName: String) -> UIStoryboard {
        UIStoryboard(name: storyboardName, bundle: nil)
    }

    static func storyboardViewController() -> Self {
        guard let vc = storyboard().instantiateViewController(withIdentifier: defaultStoryboardName) as? Self else {
            fatalError("Could not instantiate storyboard with name: \(defaultStoryboardName)")
        }
        
        return vc
    }
    
    static func storyboardViewController(_ storyboardName: String) -> Self {
        guard let vc = storyboard(storyboardName).instantiateViewController(withIdentifier: defaultStoryboardName) as? Self else {
            fatalError("Could not instantiate storyboard with name: \(defaultStoryboardName)")
        }
        
        return vc
    }
}

extension UIViewController: Storyboard { }

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>(withClass: T.Type) -> UIViewController {
        let className = String(describing: withClass)
        return instantiateViewController(withIdentifier: className)
    }
}
