//
//  MarginCellModel.swift
//  TWBank
//
//  Created by KyuHo.Son on 17/05/2019.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit

class MarginCellModel: BaseCellModel {
    override var cellIdentifier: UITableViewCell.Type {
        MarginCell.self
    }
    
    let height: CGFloat
    
    init(_ height: CGFloat) {
        self.height = height
    }
}

class MarginCollectionCellModel: BaseCollectionCellModel {
    override var cellIdentifier: UICollectionViewCell.Type {
        MarginCollectionCell.self
    }
    
    let width: CGFloat
    
    init(_ width: CGFloat) {
        self.width = width
    }
}
