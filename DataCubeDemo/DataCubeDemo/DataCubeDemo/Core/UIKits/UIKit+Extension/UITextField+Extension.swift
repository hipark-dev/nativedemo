//
//  UITextField+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//
import UIKit

extension UITextField {
    struct PlaceHolderConfigure {
        var text: String?
        var color: UIColor? = StyleColor.gray_C7C7CD.apply
        var font: UIFont? = .systemFont(ofSize: 17, weight: .regular)
        var kern: CGFloat = 0.0
        var baselineOffset: CGFloat = 0.0
    }
    
    func configurePlaceHolder(_ binder: ((inout PlaceHolderConfigure) -> Void)?) {
        var configure = PlaceHolderConfigure()
        binder?(&configure)
        let defaultText = (configure.text ?? placeholder) ?? ""
        let attributedString = NSMutableAttributedString(string: defaultText)
        attributedString.addAttributes(
            [
                NSAttributedString.Key.foregroundColor: configure.color as Any,
                NSAttributedString.Key.font: configure.font as Any,
                NSAttributedString.Key.kern: configure.kern as Any,
                NSAttributedString.Key.baselineOffset: configure.baselineOffset as Any
            ],
            range: NSRange(location: 0, length: attributedString.string.count))
        attributedPlaceholder = attributedString
    }
    
    func showToolBar(_ height: CGFloat = 43.0) {
        
        guard let toolBarWidth = UIApplication.shared.keyWindow?.bounds.size.width else { return }
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: toolBarWidth, height: height))
        toolBar.barTintColor = StyleColor.gray_EFEFF1.apply
        toolBar.clipsToBounds = true
        toolBar.isTranslucent = false

        let doneButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: height))
        doneButton.setTitleColor(StyleColor.blue_007AFF.apply, for: .normal)
        doneButton.setTitle(.empty, for: UIControl.State.normal)
        doneButton.titleLabel?.font = StyleFont.subtitle4(weight: .bold).apply
        doneButton.contentHorizontalAlignment = .right
        doneButton.addTarget(self, action: #selector(toolBarDoneButton), for: .touchUpInside)

        toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(customView: doneButton)]
        
        self.inputAccessoryView = toolBar
        
    }
    
    func showSystemToolBar() {
        let keyboardToolbar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(toolBarDoneButton))
        keyboardToolbar.items = [ UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                  target: self, action: nil), doneButton ]
        keyboardToolbar.sizeToFit()
        self.inputAccessoryView = keyboardToolbar
    }
    
    @objc func toolBarDoneButton() {
        self.resignFirstResponder()
    }
}

extension UITextField {
    var contentView: UIView? { subviews.first }
}
