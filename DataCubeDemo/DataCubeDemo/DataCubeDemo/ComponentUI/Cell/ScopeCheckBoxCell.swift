//
//  ScopeCheckBoxCell.swift
//  TWBank
//
//  Created by WoocheonHam on 23/05/2019.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ScopeCheckBoxCell: BaseCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var checkButton: UIButton!
    @IBOutlet private weak var checkImageView: UIImageView!
    
    var checkImageName: String {
        checkButton.isSelected ? "choose" : ""
    }
    
    var checkButtonDriver: Driver<()> {
        checkButton.rx.tap.takeUntil(rx.obsolete).asDriver(onErrorJustReturn: ())
    }
    
    var cellModel: ScopeCheckBoxCellModel?
    
    override func bindStyles() {
        
        titleLabel.lets {
            $0.font = StyleFont.body1(weight: .regular).apply
            $0.textColor = StyleColor.black_222222.apply
            $0.numberOfLines = 1
        }
        
        subTitleLabel.lets {
            $0.font = StyleFont.body3(weight: .regular).apply
            $0.textColor = StyleColor.gray_97999E.apply
            $0.numberOfLines = 1
        }
    }
    
    override func configureWith(value: BaseCellModelProtocol) {
        guard let cellModel = value as? ScopeCheckBoxCellModel else {
            return
        }
        self.cellModel = cellModel
        
        titleLabel.text = cellModel.title
        subTitleLabel.text = cellModel.subTitle
        checkButton.isSelected = cellModel.isSelected
        checkImageView.image = UIImage(named: checkImageName)

    }
}

