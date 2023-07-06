//
//  TitleCellModel.swift
//  TWBank
//
//  Created by KyuHo.Son on 17/05/2019.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit

class TitleCellModel: BaseCellModel {
    override var cellIdentifier: UITableViewCell.Type {
        TitleCell.self
    }
    
    let title: String
    let type: TitleCellType
    
    init(_ title: String, _ type: TitleCellType) {
        self.title = title
        self.type = type
    }
}
