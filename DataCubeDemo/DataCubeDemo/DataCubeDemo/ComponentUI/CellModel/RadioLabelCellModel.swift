//
//  RadioLabelCellModel.swift
//  TWBank
//
//  Created by KyuHo.Son on 17/05/2019.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit

class RadioLabelCellModel: BaseCellModel {
    enum CellLabelType {
        case normal
        case sfs
    }
    
    override var cellIdentifier: UITableViewCell.Type {
        RadioLabelCell.self
    }
    private let titleColorType: TitleColorType
    var type: CellLabelType
    var tag: Int
    var title: String
    var sectionTag: Int?
    var isOn: Bool? = false
    var isDescriptionHidden: Bool { description == nil }
    var allowsCellSelection = false
    var isBoldDescription: Bool? = true
    
    var titleColor: StyleColor {
        switch titleColorType {
        case .sameColor:
            return .black_2B2B2B
        case .differentColor:
            return isOn == true ? .black_2B2B2B : .gray_97999E
        }
    }
    
    var description: String?
    var descriptionEdgInsets: UIEdgeInsets?
    var radioButtonLeftMargin: CGFloat?
    var stackViewBottomMargin: CGFloat?
    
    var isEquallyFontSize = false
    
    init(title: String,
         description: String? = nil,
         isOn: Bool? = nil,
         sectionTag: Int? = 0,
         tag: Int = 0,
         whenOff titleColorType: TitleColorType = .sameColor,
         descriptionMargin: UIEdgeInsets? = nil,
         radioButtonLeftMargin: CGFloat? = nil,
         stackViewBottomMargin: CGFloat? = nil,
         isEquallyFontSize: Bool = false,
         allowsCellSelection: Bool = false,
         isBoldDescription: Bool? = true,
         type: CellLabelType = .normal) {
        
        self.title = title
        self.description = description
        self.tag = tag
        self.sectionTag = sectionTag
        self.titleColorType = titleColorType
        self.descriptionEdgInsets = descriptionMargin
        self.radioButtonLeftMargin = radioButtonLeftMargin
        self.stackViewBottomMargin = stackViewBottomMargin
        self.isEquallyFontSize = isEquallyFontSize
        self.isOn = isOn
        self.allowsCellSelection = allowsCellSelection
        self.isBoldDescription = isBoldDescription
        self.type = type
    }
}

extension RadioLabelCellModel {
    enum TitleColorType {
        case sameColor
        case differentColor
    }
}
