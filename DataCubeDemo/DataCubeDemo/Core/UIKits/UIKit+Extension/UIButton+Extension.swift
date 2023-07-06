//
//  UIButton+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit
import RxSwift
import RxCocoa

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}

//extension UIButton {
//    @IBInspectable var imageLeft: CGFloat {
//        get {
//            imageEdgeInsets.left
//        } set {
//            imageEdgeInsets.left = newValue
//            if semanticContentAttribute == .forceLeftToRight {
//                titleEdgeInsets.left += (imageView?.frame.maxX ?? 0 + newValue)
//            }
//        }
//    }
//
//    @IBInspectable var imageRight: CGFloat {
//        get {
//            imageEdgeInsets.right
//        } set {
//            imageEdgeInsets.right = newValue
//            if semanticContentAttribute == .forceLeftToRight {
//                titleEdgeInsets.left += newValue
//            }
//        }
//    }
//
//    @IBInspectable var imageTop: CGFloat {
//        get {
//            imageEdgeInsets.top
//        } set {
//            imageEdgeInsets.top = newValue
//        }
//    }
//
//    @IBInspectable var imageBottom: CGFloat {
//        get {
//            imageEdgeInsets.bottom
//        } set {
//            imageEdgeInsets.bottom = newValue
//        }
//    }
//}

extension Reactive where Base: UIButton {
    var tapped: Observable<UIButton> {
        base.rx.tap.map { [unowned base = base] _ in base }
    }
    
    var toggle: Observable<Bool> {
        .create { [weak base = base] obsever in
            guard let base = base else { return Disposables.create() }
            return base.rx.tapped.bind {
                if $0.isSelected == false {
                    base.isSelected.toggle()
                }
                obsever.onNext(!base.isSelected)
            }
        }
    }
}
