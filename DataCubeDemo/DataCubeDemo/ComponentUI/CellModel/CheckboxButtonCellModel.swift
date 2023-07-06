//
//  CheckboxButtonCellModel.swift
//  TWBank
//
//  Created by KyuHo.Son on 17/05/2019.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit

class CheckboxButtonCellModel: BaseCellModel {
    override var cellIdentifier: UITableViewCell.Type {
        CheckboxButtonCell.self
    }
    
    var fontWeight: StyleFont.FontWeight {
        isTitleBold ? .bold : .regular
    }
    
    var representTitle: NSAttributedString {
        NSAttributedString.composed(of: [
            title.styled(with: .font(StyleFont.body2(weight: fontWeight).apply), .color(StyleColor.black_2B2B2B.apply)) ])
    }
    
    let title: String
    let isTitleBold: Bool
    let isForceType: Bool
    let data: String
    let isEnableDetailButton: Bool
    let type: CheckboxButtonCellType
    let key: String?
    var isChecked: Bool
    var isNaturalyToggle: Bool = false
    
    init( title: String,
          isTitleBold: Bool,
          isForceType: Bool,
          data: String,
          isChecked: Bool,
          isEnableDetailButton: Bool,
          type: CheckboxButtonCellType = .default,
          key: String? = nil,
          naturalyTogglable: Bool = false,
          identifier: String? = nil) {
        self.title = title
        self.isTitleBold = isTitleBold
        self.isForceType = isForceType
        self.data = data
        self.isEnableDetailButton = isEnableDetailButton
        self.type = type
        self.isChecked = isChecked
        self.key = key
        self.isNaturalyToggle = naturalyTogglable
        super.init()
        self.identifier = identifier ?? ""
    }
}

