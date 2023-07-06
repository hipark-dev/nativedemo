//
//  UnderLineButtonCell.swift
//  TWBank
//
//  Created by JunKyung.Park on 26/06/2019.
//  Copyright (c) 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import BonMot

class UnderLineButtonCell: BaseCell {
    
    @IBOutlet weak private var underlineButton: UIButton!
    private var underlineTitleAttribute: NSAttributedString?
    
    override func configureWith(value: BaseCellModelProtocol) {
        guard let cellModel = value as? UnderLineButtonCellModel else { return }
        guard let attributedTitle = cellModel.attributedTitle else { return }
        underlineButton.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    var underlineButtonDriver: SharedSequence<DriverSharingStrategy, Void> {
        underlineButton.rx.tap.takeUntil(rx.obsolete).asDriver(onErrorJustReturn: ())
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        let attributedTitle = underlineButton.titleLabel?.text?.styled(
            with:
            .font(StyleFont.body2(weight: .regular).apply),
            .color(BONColor(cgColor: StyleColor.green_24C875.apply.cgColor)),
            .underline(.single, BONColor(cgColor: StyleColor.green_24C875.apply.cgColor))
        )
        underlineButton.setAttributedTitle(attributedTitle, for: .normal)
    }
}
