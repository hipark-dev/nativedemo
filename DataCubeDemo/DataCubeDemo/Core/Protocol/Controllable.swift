//
//  Controlable.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit

protocol Controllable {
    var controllableTarget: UIControl? { get }
}

extension Controllable {
    var controllableTarget: UIControl? {
        nil
    }
    
    func control<T: UIControl>(_ type: T.Type) -> T? {
        if let control = controllableTarget as? T {
            return control
        }
        
        return nil
    }
}
