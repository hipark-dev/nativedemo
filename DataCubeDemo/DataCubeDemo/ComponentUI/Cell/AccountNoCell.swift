//
//  AccountNoCell.swift
//  NFTTradePlatform
//
//  Created by Hyunil.Park on 2022/06/16.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class AccountNoCell: BaseCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var copyButton: UIButton! {
        didSet {
            copyButton.layer.cornerRadius = UIConstant.AccountNoCell.copyButtonCornerRadius
            copyButton.layer.borderWidth = UIConstant.AccountNoCell.copyButtonBorderWidth
            copyButton.layer.borderColor = UIColor.clear.cgColor
        }
    }

    override func configureWith(value: BaseCellModelProtocol) {
        guard let cellModel = value as? AccountNoCellModel else { return }
        titleLabel.text = cellModel.title
        numberLabel.text = cellModel.accountNo.formattedAccountNumber
        copyButton.isHidden = cellModel.isCopyButtonHidden
        copyButton.setTitle(LocalizableString.mainaSettingsButtonCopynumber, for: .normal)
        
        copyButton.rx.tap.takeUntil(rx.obsolete).asDriver(onErrorJustReturn: ()).drive(
            onNext: {
                guard let copyText = cellModel.clipBoardCopyText else { return }
                
                UIPasteboard.general.string = copyText
                ToastStatus.show(LocalizableString.topAccountcardMenuCopynumberToastCopied)
            }).disposed(by: disposeBag)
        
    }
}
