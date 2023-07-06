//
//  UnderLineButtonCellModel.swift
//  TWBank
//
//  Created by JunKyung.Park on 26/06/2019.
//  Copyright (c) 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit

class UnderLineButtonCellModel: BaseCellModel {
    override var cellIdentifier: UITableViewCell.Type {
        UnderLineButtonCell.self
    }
    
    var hasUnderLine = false
    var attributedTitle: NSAttributedString?
    
    override init() {}
    
    init(attributedTitle: NSAttributedString? = nil) {
        self.attributedTitle = attributedTitle
    }
    
}
