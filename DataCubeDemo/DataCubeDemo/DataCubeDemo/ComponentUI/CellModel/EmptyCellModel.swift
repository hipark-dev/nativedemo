//
//  EmptyCellModel.swift
//  TWBank
//
//  Created by WoocheonHam on 19/06/2019.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit
import BonMot
import RxDataSources
import RxSwift

// MARK: - CellModel
class EmptyCellModel: BaseCellModel {
    override var cellIdentifier: UITableViewCell.Type {
        EmptyCell.self
    }
    
    let message: String
    
    init(_ msg: String) {
        message = msg
    }
}
