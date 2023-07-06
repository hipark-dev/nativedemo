//
//  CancelCell.swift
//  NFTTradePlatform
//
//  Created by Hyunil.Park on 2022/06/16.
//

import UIKit
import RxSwift
import RxCocoa

class CancelCell: BaseCell {
    @IBOutlet private weak var hereButton: UIButton!

    var hereButtonDriver: Driver<()> {
        hereButton.rx.tap.throttle().takeUntil(rx.obsolete).asDriver(onErrorJustReturn: ())
    }
   
    override func configureWith(value: BaseCellModelProtocol) {
        guard let cellModel = value as? CancelCellModel else { return }
        
        let attrStr = NSMutableAttributedString(string: cellModel.title).setStringUnderLine(cellModel.title)
        hereButton.setAttributedTitle(attrStr, for: .normal)
    }
}
