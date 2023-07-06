//
//  TitleBold2LineCell.swift
//  TWBank
//
//  Created by Hyunil.Park on 04/04/2019.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit

class TitleBold2LineCell: BaseCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    override func bindStyles() {
        titleLabel.lets {
            $0.textColor = .black
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
        }
    }
    
    override func configureWith(value: BaseCellModelProtocol) {

        guard let cellModel = value as? TitleBold2LineCellModel else {
            return
        }
        titleLabel.text = cellModel.titleString
        titleLabel.font = cellModel.titleFont
    }
}
