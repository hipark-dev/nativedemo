//
//  DepositHistoryCell.swift
//  NFTTradePlatform
//
//  Created by Hyunil.Park on 2022/06/16.
//

import UIKit

class DepositHistoryCell: BaseCell {

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var totalAmountLabel: UILabel!
    
    override func configureWith(value: BaseCellModelProtocol) {
        guard let cellModel = value as? DepositHistoryCellModel else { return }
        dateLabel.text = cellModel.date
        descriptionLabel.text = cellModel.description
        amountLabel.text = cellModel.amount
        totalAmountLabel.text = cellModel.totalAmount
    }
}
