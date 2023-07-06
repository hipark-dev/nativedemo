//
//  CheckBoxCellModel.swift
//  TWBank
//
//  Created by KyuHo.Son on 17/05/2019.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit

class CheckBoxCellModel: BaseCellModel {
    override var cellIdentifier: UITableViewCell.Type {
        CheckBoxCell.self
    }
    
    let title: String
    var isSelected: Bool = false

    init(_ title: String, isSelected: Bool = false) {
        self.title = title
        self.isSelected = isSelected
    }
}

class NotificationCheckBoxCellModel: CheckBoxCellModel {
    override var cellIdentifier: UITableViewCell.Type {
        CheckBoxCell.self
    }

    var dataModel: SettingAPIModel.NotificationList?

    convenience init(_ title: String, isSelected: Bool = false, dataModel: SettingAPIModel.NotificationList?) {
        self.init(title, isSelected: isSelected)

        self.dataModel = dataModel
    }
}

class DepositAccountCheckBoxCellModel: CheckBoxCellModel {
    override var cellIdentifier: UITableViewCell.Type {
        CheckBoxCell.self
    }

    var order: Int = 0
    var dataModel: AccountAPIModel.Common.DepositAccountInfo?

    convenience init(_ title: String, isSelected: Bool = false, order: Int = 0, dataModel: AccountAPIModel.Common.DepositAccountInfo?) {
        self.init(title, isSelected: isSelected)

        self.order = order
        self.dataModel = dataModel
    }
}
