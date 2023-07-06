//
//  RadioButtonCell.swift
//  TWBank
//
//  Created by Hyunil.Park on 04/04/2019.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RadioButtonCell: BaseCell {
    
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var yesButtonLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var noButtonLabel: UILabel!
    @IBOutlet private weak var errorLabel: UILabel!
    
    var yesButtonDriver: Driver<()> {
        yesButton.rx.tap.takeUntil(rx.obsolete).asDriver(onErrorJustReturn: ())
    }
    
    var noButtonDriver: Driver<()> {
        noButton.rx.tap.takeUntil(rx.obsolete).asDriver(onErrorJustReturn: ())
    }
    var allowsBindModel = false
    weak var model: RadioButtonCellModel?
    
    override func bindStyles() {
    
        questionLabel.lets {
            $0.font = StyleFont.body2(weight: .regular).apply
            $0.textColor = StyleColor.black_2B2B2B.apply
            $0.numberOfLines = 0
        }
        
        yesButtonLabel.lets {
            $0.font = StyleFont.body2(weight: .regular).apply
            $0.textColor = StyleColor.black_2B2B2B.apply
            $0.numberOfLines = 0
        }
        
        noButtonLabel.lets {
            $0.font = StyleFont.body2(weight: .regular).apply
            $0.textColor = StyleColor.black_2B2B2B.apply
            $0.numberOfLines = 0
        }
        
        errorLabel.lets {
            $0.font = StyleFont.body2(weight: .regular).apply
            $0.textColor = StyleColor.red_FF3A44.apply
            $0.numberOfLines = 0
        }
    }
    
    override func configureWith(value: BaseCellModelProtocol) {
        
        guard let cellModel = value as? RadioButtonCellModel else {
            return
        }
        model = cellModel
        questionLabel.text = cellModel.title
        yesButtonLabel.text = cellModel.yesButtonTitle
        noButtonLabel.text = cellModel.noButtonTitle
        errorLabel.text = cellModel.errorMessage
        
        defer {
            layoutIfNeeded()
            updateConstraintsIfNeeded()
        }
        
        if let yesSelected = cellModel.yesButtonSelected {
            yesButton.isSelected = yesSelected
            noButton.isSelected = !yesSelected
            errorLabel.isHidden = !yesSelected
        } else {
            yesButton.isSelected = false
            noButton.isSelected = false
            errorLabel.isHidden = true
        }
        
        guard cellModel.allowsBindModel else { return }
                
        yesButton.rx.toggle
        .do(onNext: { [unowned self] in
            self.model?.yesButtonSelected = !$0
        }).bind(to: noButton.rx.isSelected, errorLabel.rx.isHidden).disposed(by: disposeBag)
        noButton.rx.toggle
        .do(onNext: { [unowned self] in
            self.model?.yesButtonSelected = $0
        }).bind(to: yesButton.rx.isSelected).disposed(by: disposeBag)
    }
}

