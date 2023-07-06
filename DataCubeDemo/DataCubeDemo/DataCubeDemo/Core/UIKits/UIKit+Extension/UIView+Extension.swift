//
//  UIView+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//
import UIKit
import Kingfisher

extension UIView {
    
    func backgroundImage(imgUrl: String, placeHolder: String) {
        let imageView = UIImageView(frame: bounds)
        imageView.kf.setImage(with: URL(string: imgUrl), placeholder: UIImage(named: placeHolder))
        imageView.contentMode = .scaleAspectFill
        insertSubview(imageView, at: 0)
        sendSubviewToBack(imageView)
    }
    
    func backgroundImageFill(imgUrl: String, placeHolder: String) {
        let imageView = UIImageView(frame: bounds)
        imageView.kf.setImage(with: URL(string: imgUrl), placeholder: UIImage(named: placeHolder))
        imageView.contentMode = .scaleToFill
        insertSubview(imageView, at: 0)
        sendSubviewToBack(imageView)
    }
    
    func backgroundImage(by image: UIImage?, contentMode: UIView.ContentMode = .scaleAspectFill) {
        let imageView = UIImageView(frame: bounds)
        imageView.contentMode = contentMode
        imageView.image = image
        insertSubview(imageView, at: 0)
        sendSubviewToBack(imageView)
        
    }
 
}
extension UIView {
    static let defaultSubViewTag = 195948557
    var foundScrollView: UIScrollView? {
        subviews.compactMap { $0 as? UIScrollView }.first
    }
    
    func findSubView<T>(_ viewType: T.Type, tag: Int = defaultSubViewTag) -> T? {
        let foundSubviews = subviews.compactMap { $0 as? T }
        guard tag != UIView.defaultSubViewTag else {
            return viewWithTag(tag) as? T
        }
        return foundSubviews.count > 1 ? nil : foundSubviews.first
    }
    
    func set(isHidden: Bool, alpha: CGFloat) {
        self.isHidden = isHidden
        self.alpha = alpha
    }
}

extension UIView {
    @IBInspectable var cornerRadius: Double {
        get {
            Double(self.layer.cornerRadius)
        } set {
            self.layer.cornerRadius = CGFloat(newValue)
        }
    }

    @IBInspectable var borderWidth: Double {
        get {
            Double(self.layer.borderWidth)
        }
        set {
            self.layer.borderWidth = CGFloat(newValue)
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = self.layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable var layerShadowColor: UIColor? {
        get {
            guard let color = self.layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }

    @IBInspectable var shadowOpacity: Float {
        get {
            self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
} 

extension UIView {
    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        let rotation = self.transform.rotated(by: radians)
        self.transform = rotation
    }
    
    func rotated(angle: CGFloat) -> Self {
        rotate(angle: angle)
        return self
    }
}

extension UIView {
    
    func colorApplied(_ color: UIColor) -> UIView {
        backgroundColor = color
        return self
    }
    
    func marginApplied(_ margins: UIEdgeInsets) -> UIView {
        layoutMargins = margins
        return self
    }
    
    func shake(scale: CGFloat, duration: Double, delay: Double) {
        self.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        UIView.animate(withDuration: duration,
                       delay: delay,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .allowUserInteraction,
                       animations: {
                        self.transform = .identity
        }, completion: { _ -> Void in
        })
    }
}

extension UIView {
    func subviewsMaxX() -> CGFloat {
        subviews.compactMap { $0.frame.maxX }.max() ?? 0.0
    }
    
    func subviewsMaxY() -> CGFloat {
        subviews.compactMap { $0.frame.maxY }.max() ?? 0.0
    }
}

extension UIView {
    func hideAnimated(in target: UIView) {
        if !self.isHidden {
            UIView.animate(
                withDuration: 0.35,
                delay: 0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    self.isHidden = true
                    target.layoutIfNeeded()
                },
                completion: nil
            )
        }
    }
    
    func showAnimated(in target: UIView) {
        if self.isHidden {
            UIView.animate(
                withDuration: 0.35,
                delay: 0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    self.isHidden = false
                    target.layoutIfNeeded()
                },
                completion: nil
            )
        }
    }
}

extension UIView {
   var viewController: UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            if let responder = responder as? UIViewController {
                return responder
            }
            
            guard let currentResponder = responder else { break }
            responder = currentResponder.next
        }
    
        return nil
    }
    
    var offsetFromTopView: CGPoint {
        var point = frame.origin
        var parentView = superview
        
        while parentView != nil {
            let parentPoint = parentView?.frame.origin ?? CGPoint()
            point.x += parentPoint.x
            point.y += parentPoint.y
            parentView = parentView?.superview
        }
        
         return point
    }
    
    var topSuperView: UIView? {
        var parentView = superview
        while parentView != nil {
            if parentView?.superview == nil {
                return parentView
            }
            parentView = parentView?.superview
        }
        return nil
    }
}

extension UIView {
    func layoutImmediately() {
        setNeedsUpdateConstraints()
        setNeedsLayout()
        layoutIfNeeded()
    }
}
