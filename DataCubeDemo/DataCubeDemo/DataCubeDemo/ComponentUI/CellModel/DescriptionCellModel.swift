//
//  DescriptionCellModel.swift
//  TWBank
//
//  Created by KyuHo.Son on 17/05/2019.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit

class DescriptionCellModel: BaseCellModel {
    override var cellIdentifier: UITableViewCell.Type {
        DescriptionCell.self
    }
    
    let title: String
    let type: DescriptionCellType
    
    init(_ title: String, _ type: DescriptionCellType) {
        self.title = title
        self.type = type
    }
}
