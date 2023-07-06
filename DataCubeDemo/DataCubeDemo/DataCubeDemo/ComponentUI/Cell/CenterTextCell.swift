//
//  CenterTextCell.swift
//  NFTTradePlatform
//
//  Created by Hyunil.Park on 2022/06/16.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher
import RxSwiftExt

class CenterTextCell: BaseCell {
    
    @IBOutlet private weak var textNoHistoryLabel: UILabel!
    
    override func bindStyles() {
        
        textNoHistoryLabel.lets {
            $0.font = StyleFont.body2(weight: .regular).apply
            $0.textColor = StyleColor.gray_C1C1C1.apply
        }
    }

    override func configureWith(value: BaseCellModelProtocol) {
    
        guard let cellModel = value as? CenterTextCellModel else {
            return
        }
        textNoHistoryLabel.text = cellModel.representTextLabel
        
    }
}
