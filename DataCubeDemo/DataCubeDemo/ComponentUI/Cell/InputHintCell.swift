//
//  InputHintCell.swift
//  NFTTradePlatform
//
//  Created by Hyunil.Park on 2022/06/16.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
    
class InputHintCell: BaseCell {
    
    @IBOutlet private weak var actionButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var activeImageView: UIImageView!
    @IBOutlet private weak var lineView: UIView!
    
    var key: String = .empty
    
    var actionButtonDriver: Driver<()> {
        actionButton.rx.tap.throttle().takeUntil(rx.obsolete).asDriver(onErrorJustReturn: ())
    }

    override func bindStyles() {
        selectionStyle = .none
        titleLabel.lets {
            $0.numberOfLines = 0
            $0.sizeToFit()
        }
        
        subTitleLabel.lets {
            $0.textColor = StyleColor.gray_C1C1C1.apply
        }
    
        activeImageView.lets {
            $0.backgroundColor = .clear
        }
    }
    
    override func configureWith(value: BaseCellModelProtocol) {
        guard let cellModel = value as? InputHintCellModel else { return }

        titleLabel.text = cellModel.titleString
        titleLabel.font = cellModel.titleFont?.apply
        titleLabel.textColor = cellModel.subTitleHiddenFlag ? StyleColor.gray_C1C1C1.apply : StyleColor.black_222222.apply
        
        subTitleLabel.font = cellModel.subTitleFont?.apply
        subTitleLabel.text = cellModel.subTitleString
        subTitleLabel.isHidden = cellModel.subTitleHiddenFlag
        
        lineView.backgroundColor = cellModel.lineColor.lineColor
        key = cellModel.key
        activeImageView.image = cellModel.activeImage
        if cellModel.activeImage == nil {
            self.actionButton.isEnabled = false
        }
        actionButton.isEnabled = cellModel.isEnabled
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        titleLabel.textColor = StyleColor.gray_C1C1C1.apply
        subTitleLabel.text = nil
    }
}
