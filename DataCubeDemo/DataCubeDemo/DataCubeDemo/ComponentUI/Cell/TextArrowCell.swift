//
//  TextArrowCell.swift
//  TWBank
//
//  Created by KyuHo.Son on 08/04/2019.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit
import RxCocoa

class TextArrowCell: BaseCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var rightLabel: UILabel!
    @IBOutlet private weak var textArrowButton: UIButton!
    @IBOutlet private weak var arrowImageView: UIImageView!
    
    var textArrowButtonDriver: Driver<()> {
        textArrowButton.rx.tap.throttle().takeUntil(rx.obsolete).asDriver(onErrorJustReturn: ())
    }
    
    override func bindStyles() {
        titleLabel.lets {
            $0.font = StyleFont.body1(weight: .regular).apply
            $0.textColor = StyleColor.black_222222.apply
        }
        rightLabel.lets {
            $0.font = StyleFont.body1(weight: .regular).apply
            $0.textColor = StyleColor.gray_97999E.apply
        }
    }
    
    override func configureWith(value: BaseCellModelProtocol) {
        guard let cellModel = value as? TextArrowCellModel else { return }
        
        titleLabel.text = cellModel.title
        rightLabel.text = cellModel.rightText
        
        titleLabel.isEnabled = !cellModel.isDimded
        rightLabel.isEnabled = !cellModel.isDimded
        
        textArrowButton.isHidden = cellModel.isHiddenArrow
        arrowImageView.isHidden = cellModel.isHiddenArrow

    }
}
