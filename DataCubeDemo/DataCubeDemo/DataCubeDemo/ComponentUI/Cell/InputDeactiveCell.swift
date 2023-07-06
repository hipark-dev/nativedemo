//
//  InputDeactiveCell.swift
//  NFTTradePlatform
//
//  Created by Hyunil.Park on 2022/06/16.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class InputDeactiveCell: BaseCell {
    
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var mainTitleLabel: UILabel!
    @IBOutlet private weak var activeImageView: UIImageView!
    @IBOutlet private weak var lineView: UIView!
    
    override func bindStyles() {
        
        subTitleLabel.lets {
            $0.font = StyleFont.body5.apply
            $0.textColor = StyleColor.gray_C1C1C1.apply
            $0.numberOfLines = 1
            $0.sizeToFit()
        }
        
        mainTitleLabel.lets {
            $0.font = StyleFont.subtitle2(weight: .regular).apply
            $0.textColor = StyleColor.gray_97999E.apply
            $0.numberOfLines = 1
            $0.sizeToFit()
        }
        
        lineView.lets {
            $0.backgroundColor = StyleColor.gray_ECECEC.apply
        }
        
        activeImageView.lets {
            $0.backgroundColor = .clear
        }
    }
    
    override func configureWith(value: BaseCellModelProtocol) {
        guard let cellModel = value as? InputDeactiveCellModel else { return }

        subTitleLabel.text = cellModel.subTitleString
        mainTitleLabel.text = cellModel.mainTitleString
        activeImageView.image = cellModel.activeImage
    }
}
