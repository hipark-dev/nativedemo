//
//  UISearchBar+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit
import RxSwift
import RxCocoa

private enum UISearchBarKey: String {
    case searchField = "_searchField"
}

extension UISearchBar {
    var iconImageView: UIImageView? { textField?.leftView as? UIImageView }
    var textField: UITextField? {
        guard #available(iOS 13.0, *) else {
            return value(forKey: UISearchBarKey.searchField.rawValue) as? UITextField
        }
        return searchTextField
    }
    
    var contentView: UIView? { subviews.first }
        
    func setIconTintColor(_ color: UIColor) {
        guard let imageView = self.iconImageView else {
            assertionFailure("ASSERSION \(self) not found icon view")
            return
        }
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = color
        setImage(imageView.image, for: .search, state: .normal)
    }
    
    func contentBackgroundColor(_ color: UIColor) {
        textField?.contentView?.backgroundColor = color
        textField?.subviews.filter({ $0 is UIImageView }).first?.backgroundColor = .clear
        isTranslucent = false
    }
    
    func setLimitText(count value: Int) -> Disposable {
        rx.text.take(until: rx.deallocated).compactMap { $0 }
            .subscribe { [weak self] event in
                guard let input = event.element else { return }
                guard input.count >= value else { return }
                self?.text = String(input.prefix(value))
            }
        
    }
}
