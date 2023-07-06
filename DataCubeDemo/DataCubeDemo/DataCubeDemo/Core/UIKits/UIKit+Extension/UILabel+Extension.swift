//
//  UILabel+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit

extension UILabel {
    func set(textColor styleColor: StyleColor, font styleFont: StyleFont) {
        font = styleFont.apply
        textColor = styleColor.apply
    }
    
    func set(textColor styleColor: StyleColor, font styleFont: StyleFont, title: String) {
        text = title
        font = styleFont.apply
        textColor = styleColor.apply
    }
    
    func setText(value: String?, highlight: String?, highlightedColor: UIColor = StyleColor.green_24C875.apply) {
        
        guard let value = value, let highlight = highlight else { return }
        
        let attributedText = NSMutableAttributedString(string: value)
        let range = (value as NSString).range(of: highlight, options: .caseInsensitive)
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: highlightedColor
        ]
        
        attributedText.addAttributes(strokeTextAttributes, range: range)
        self.attributedText = attributedText
    }
}
