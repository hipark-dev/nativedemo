//
//  FullButtonCell.swift
//  NFTTradePlatform
//
//  Created by Hyunil.Park on 2022/06/16.
//

import UIKit
import RxSwift
import RxCocoa
import BonMot

class FullButtonCell: BaseCell {
    @IBOutlet private weak var fullButton: UIButton!
    let changeButtonStatus: PublishSubject<Bool> = PublishSubject()
    
    var fullButtonDriver: Driver<()> {
        fullButton.rx.tap.take(until: rx.obsolete).asDriver(onErrorJustReturn: ())
    }

    override func bindViewModel() {
        changeButtonStatus.subscribe(
            onNext: { [weak self] isEnabled in
                self?.fullButton.isEnabled = isEnabled
                self?.fullButton.backgroundColor = isEnabled ? ButtonState.enable.backgroundColor : ButtonState.disable.backgroundColor
            }
        ).disposed(by: disposeBag)
    }
    
    override func configureWith(value: BaseCellModelProtocol) {
        guard let cellModel = value as? FullButtonCellModel else { return }
        
        let attributedTitle = cellModel.titleAttributedString
        
        fullButton.lets {
            $0.setAttributedTitle(attributedTitle, for: UIControl.State.normal)
            $0.isEnabled = cellModel.state.buttonState
            $0.backgroundColor = cellModel.backgroudColor
            $0.snp.remakeConstraints {
                $0.edges.equalTo(contentView).inset(cellModel.edgeInsets)
                // FIXME: please remove constraionts on tableview cell autolayout when using snap Kit, and Set priority
                $0.height.equalTo(cellModel.height).priority(750)
            }
            $0.layer.cornerRadius = cellModel.cornerRadius
        }
    }
}
