//
//  MarginCollectionCell.swift
//  TWBank
//
//  Created by Hyunil.Park on 17/01/2020.
//  Copyright © 2020 LINE Bank TW Corporation. All rights reserved.
//

import UIKit

class MarginCollectionCell: BaseCollectionCell {
    @IBOutlet private weak var widthConstraint: NSLayoutConstraint!
    
    override func configureWith(value: BaseCollectionCellModelProtocol) {
        guard let cellModel = value as? MarginCollectionCellModel else { return }
        widthConstraint.constant = cellModel.width
    }
}
