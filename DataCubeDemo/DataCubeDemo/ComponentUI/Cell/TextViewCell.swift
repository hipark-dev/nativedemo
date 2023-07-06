//
//  TextViewCell.swift
//  TWBank
//
//  Created by Hyunil.Park on 02/03/2020.
//  Copyright © 2020 LINE Bank TW Corporation. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxSwiftExt

class TextViewCell: BaseCell {
    typealias Completion = () -> Void
    @IBOutlet private weak var textView: UITextView!
    private var faqCategory: String = .empty
    private var completion: Completion?
    
    override func bindStyles() {
        textView.lets {
            $0.delegate = self
            $0.isEditable = false
            $0.isUserInteractionEnabled = true
            $0.font = StyleFont.body4(weight: .regular).apply
            $0.textColor = StyleColor.gray_97999E.apply
            $0.textAlignment = .left
            $0.textContainer.lineFragmentPadding = 0
            $0.isScrollEnabled = false
        }
    }
    
    override func configureWith(value: BaseCellModelProtocol) {
        guard let cellModel = value as? TextViewCellModel else { return }
        faqCategory = cellModel.linkCategory
        completion = cellModel.completion
        
        switch cellModel.cellType {
        case .openAccount:
            textView.lets {
                $0.delegate = self
                $0.isEditable = false
                $0.isUserInteractionEnabled = true
                $0.font = StyleFont.body4(weight: .regular).apply
                $0.textColor = StyleColor.gray_97999E.apply
                $0.textAlignment = .left
                $0.textContainer.lineFragmentPadding = 0
                $0.isScrollEnabled = false
            }
        case .userProfile:
            textView.lets {
                $0.delegate = self
                $0.isEditable = false
                $0.isUserInteractionEnabled = true
                $0.font = StyleFont.body4(weight: .regular).apply
                $0.textColor = StyleColor.gray_97999E.apply
                $0.textAlignment = .left
                $0.textContainer.lineFragmentPadding = 0
                $0.isScrollEnabled = false
            }
        }
        
        let attributeString = NSMutableAttributedString(string: cellModel.contents)
        let url = URL(string: "lbtw://")
        if let stringIndex = cellModel.contents.range(of: cellModel.linkKeyword) {
            let range: NSRange = cellModel.contents.nsRange(from: stringIndex)
            attributeString.setAttributes([.link: url as Any], range: range)
        } else {
            attributeString.setAttributes([.link: url as Any], range: .init(location: 0, length: 14))
        }
        textView.attributedText = attributeString
        textView.linkTextAttributes = [
            .foregroundColor: StyleColor.gray_97999E.apply,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
    }
}

extension TextViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        completion?()
        return false
    }
}
