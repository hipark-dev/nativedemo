//
//  ZipCodeCell.swift
//  TWBank
//
//  Created by Hyunil.Park on 10/06/2019.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit
import RxSwift
import RxSwiftExt
import RxCocoa

class ZipCodeCell: BaseCell {
    
    @IBOutlet private weak var zipCodeLabel: UILabel!
    @IBOutlet private weak var cityDistrictLabel: UILabel!
    @IBOutlet private weak var bankButton: UIButton!
    
    var zipCodeButtonDriver: Driver<()> {
        bankButton.rx.tap.throttle().takeUntil(rx.obsolete).asDriver(onErrorJustReturn: ())
    }
    
    override func bindStyles() {
        
        zipCodeLabel.lets {
            $0.font = StyleFont.body2(weight: .bold).apply
            $0.textColor = StyleColor.black_222222.apply
        }
        
        cityDistrictLabel.lets {
            $0.font = StyleFont.body2(weight: .regular).apply
            $0.textColor = StyleColor.black_222222.apply
        }

    }
    
    override func configureWith(value: BaseCellModelProtocol) {
        
        guard let cellModel = value as? ZipCodeCellModel else { return }
        zipCodeLabel.text = cellModel.representZipCode
        cityDistrictLabel.text = "\(cellModel.representCity) \(cellModel.representScope)"
        
    }
}

