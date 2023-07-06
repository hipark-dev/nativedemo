//
//  DropdownLabelCell.swift
//  NFTTradePlatform
//
//  Created by Hyunil.Park on 2022/06/16.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher
import RxSwiftExt

class DropdownLabelCell: BaseCell {
    
    @IBOutlet private weak var dropDownLabel: UILabel!
    @IBOutlet private weak var dropDownButton: UIButton!
    @IBOutlet private weak var dropDownImageView: UIImageView!
    
    var dropDownButtonDriver: Driver<()> {
        dropDownButton.rx.tap.throttle().takeUntil(rx.obsolete).asDriver(onErrorJustReturn: ())
    }
   
    override func configureWith(value: BaseCellModelProtocol) {
    
        guard let cellModel = value as? DropdownLabelCellModel else {
            return
        }
        
        dropDownLabel.lets {
            $0.font = StyleFont.subtitle2(weight: .regular).apply
            $0.textColor = cellModel.textColor.apply
            $0.text = cellModel.text
        }

        dropDownImageView.isHidden = cellModel.representDropDown
        dropDownButton.isEnabled = !cellModel.representDropDown
    }
}
