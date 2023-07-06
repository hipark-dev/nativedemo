//
//  TextViewCellModel.swift
//  TWBank
//
//  Created by Hyunil.Park on 02/03/2020.
//  Copyright © 2020 LINE Bank TW Corporation. All rights reserved.
//

import UIKit

class TextViewCellModel: BaseCellModel {
    typealias Completion = () -> Void
    
    enum CellType {
        case openAccount
        case userProfile
    }
    override var cellIdentifier: UITableViewCell.Type {
        TextViewCell.self
    }
    
    var cellType: CellType
    let contents: String
    let linkKeyword: String
    var linkCategory: String
    let completion: Completion?
    
    init(type: CellType = .openAccount,
         contents: String,
         linkKeyword: String,
         category: String = "",
         completion: Completion?) {
        self.cellType = type
        self.contents = contents
        self.linkKeyword = linkKeyword
        linkCategory = category
        self.completion = completion
    }
}
