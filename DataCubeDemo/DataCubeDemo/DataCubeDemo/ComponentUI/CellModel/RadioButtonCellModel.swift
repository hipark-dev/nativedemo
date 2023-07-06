//
//  RadioButtonCellModel.swift
//  TWBank
//
//  Created by KyuHo.Son on 17/05/2019.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit

class RadioButtonCellModel: BaseCellModel {
    override var cellIdentifier: UITableViewCell.Type {
        RadioButtonCell.self
    }
    
    var title: String
    var yesButtonTitle: String
    var noButtonTitle: String
    var isForceType: Bool
    var errorMessage: String
    var yesButtonSelected: Bool?
    var allowsBindModel: Bool = false
    
    init(title: String,
         yesButtonTitle: String,
         noButtonTitle: String,
         errorMessage: String = .empty,
         isForceType: Bool = false,
         allowsBindModel: Bool = false) {
        self.title = title
        self.yesButtonTitle = yesButtonTitle
        self.noButtonTitle = noButtonTitle
        self.isForceType = isForceType
        self.yesButtonSelected = nil
        self.errorMessage = errorMessage
        self.allowsBindModel = allowsBindModel
    }
    
    init(_ required: Required) {
        title = required.title ?? .empty
        yesButtonTitle = required.yesButtonTitle ?? .empty
        noButtonTitle = required.noButtonTitle ?? .empty
        errorMessage = required.errorMessage ?? .empty
        isForceType = required.useForceType
        yesButtonSelected = required.yesButtonSelected
        allowsBindModel = required.allowsBindModel
    }
    
    struct Required {
        var title: String?,
        yesButtonTitle: String? = LocalizableString.openTermsButtonYes,
        noButtonTitle: String? = LocalizableString.openTermsButtonNo,
        errorMessage: String?,
        yesButtonSelected: Bool? = nil,
        useForceType: Bool = false,
        allowsBindModel: Bool = false
    }
}

