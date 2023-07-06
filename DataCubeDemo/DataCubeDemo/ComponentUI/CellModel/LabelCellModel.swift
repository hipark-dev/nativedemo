//
//  LabelCellModel.swift
//  TWBank
//
//  Created by KyuHo.Son on 17/05/2019.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit

class LabelCellModel: BaseCellModel {
    var title: String
    var detail: String?
    var edgeInsets: UIEdgeInsets
    var textColor: StyleColor
    var font: StyleFont
    var numberFont: StyleNumberFont?
    var detailFont: StyleFont?
    var numberOfLines: Int
    var appendArrow: Bool = false
    var textAlignment: NSTextAlignment
    var height: CGFloat?
    var isUnderlinedTitle: Bool = false
    
    override var cellIdentifier: UITableViewCell.Type {
        LabelCell.self
    }
    
    init(title: String,
         detail: String? = nil,
         height: CGFloat? = nil,
         textColor: StyleColor,
         font: StyleFont,
         detailFont: StyleFont? = nil,
         numberOfLines: Int = 0,
         appendArrow: Bool = false,
         top: CGFloat = 0,
         left: CGFloat = 0,
         bottom: CGFloat = 0,
         right: CGFloat = 0,
         textAlignment: NSTextAlignment = .left) {
        self.title = title
        self.detail = detail
        self.height = height
        self.textColor = textColor
        self.font = font
        self.detailFont = detailFont
        self.numberOfLines = numberOfLines
        self.appendArrow = appendArrow
        self.textAlignment = textAlignment
        edgeInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    init(title: String,
         detail: String? = nil,
         height: CGFloat? = nil,
         textColor: StyleColor,
         font: StyleFont,
         detailFont: StyleFont? = nil,
         numberOfLines: Int = 0,
         appendArrow: Bool = false,
         edgeInsets: UIEdgeInsets,
         textAlignment: NSTextAlignment = .left,
         underlinedTitle: Bool = false) {
        self.title = title
        self.detail = detail
        self.height = height
        self.textColor = textColor
        self.font = font
        self.detailFont = detailFont
        self.numberOfLines = numberOfLines
        self.appendArrow = appendArrow
        self.edgeInsets = edgeInsets
        self.textAlignment = textAlignment
        self.isUnderlinedTitle = underlinedTitle
    }
    
    override init() {
        self.title = ""
        self.font = .body5
        self.edgeInsets = .zero
        self.textColor = .black_222222
        self.numberOfLines = 0
        self.appendArrow = false
        self.textAlignment = .left
        super.init()
    }
    
    static func instantiate(style: PreparedStyle) -> LabelCellModel {
        style.preparedInstance
    }
}

extension LabelCellModel {
    @discardableResult func font(_ font: StyleFont, detailFont: StyleFont? = nil) -> LabelCellModel {
        self.font = font
        self.detailFont = detailFont
        return self
    }
    
    @discardableResult func font(_ font: StyleNumberFont, detailFont: StyleFont? = nil) -> LabelCellModel {
        self.numberFont = font
        self.detailFont = detailFont
        return self
    }
    
    @discardableResult func title(_ title: String, detail: String? = nil) -> LabelCellModel {
        self.title = title
        self.detail = detail
        return self
    }
    
    @discardableResult func edgeInsets(_ edgeInsets: UIEdgeInsets = .zero) -> LabelCellModel {
        self.edgeInsets = edgeInsets
        return self
    }
    
    @discardableResult func textColor(_ textColor: StyleColor = .black_222222) -> LabelCellModel {
        self.textColor = textColor
        return self
    }
    
    @discardableResult func textAlignment(_ textAlignment: NSTextAlignment = .left) -> LabelCellModel {
        self.textAlignment = textAlignment
        return self
    }
    
    @discardableResult func numberOfLines(_ numberOfLines: Int) -> LabelCellModel {
        self.numberOfLines = numberOfLines
        return self
    }
    
    @discardableResult func underlinedTitle(_ allowUnderline: Bool = false) -> LabelCellModel {
        self.isUnderlinedTitle = allowUnderline
        return self
    }
}

extension LabelCellModel {
    enum PreparedStyle {
        /// body5 size 15
        case `default`(String)
        /// head1 size 34
        case title(String)
        /// body4 size 13
        case description(String)
        /// number font
        case number(String, StyleNumberFont)
        /// biody6 size 12
        case subTitle(String)
        /// body1 size 16
        case debitBenefitsTitle(String)
        
    }
}

extension LabelCellModel.PreparedStyle {
    var preparedInstance: LabelCellModel {
        let instance = LabelCellModel()
        switch self {
        case .default(let title):
            return instance.title(title)
                .font(.body5)
                .edgeInsets(.init(top: .zero, left: 28, bottom: .zero, right: 28))
            
        case .title(let title):
            return instance.title(title)
                .textColor(.black_000000)
                .font(.head1)
                .edgeInsets(.init(top: .zero, left: 28, bottom: .zero, right: 28))
        case .description(let title):
            return instance.title(title)
                .textColor(.gray_97999E)
                .font(.body4(weight: .regular))
                .edgeInsets(.init(top: .zero, left: 28, bottom: .zero, right: 28))
        case let .number(title, numberFont):
            return instance.title(title)
                .font(numberFont)
                .edgeInsets(.init(top: .zero, left: 28, bottom: .zero, right: 28))
        case let .subTitle(text):
            return instance.title(text)
                .textColor(.gray_D0D0D5)
                .font(.body6(weight: .regular))
                .edgeInsets(.init(top: 14, left: 28, bottom: .zero, right: 28))
        case let .debitBenefitsTitle(text):
            return instance.title(text)
            .textColor(.black_000000)
            .font(.body1(weight: .bold))
            .edgeInsets(Self.debitCardBasicBenefitsTtileInset)
            .textAlignment(.center)
        }
    }
    
    static let debitCardBasicBenefitsTtileInset: UIEdgeInsets = .init(top: 30, left: 28, bottom: 30, right: 28)
}

