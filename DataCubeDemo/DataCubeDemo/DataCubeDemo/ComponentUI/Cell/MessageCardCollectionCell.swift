//
//  MessageCardCollectionCell.swift
//  NFTTradePlatform
//
//  Created by Hyunil.Park on 2022/06/16.
//

import UIKit
import RxSwift
import RxSwiftExt
import RxCocoa
import Kingfisher
import RxDataSources
import RxViewController

class MessageCardCollectionCell: BaseCollectionCell {

    @IBOutlet private weak var checkboxButton: UIButton!
    @IBOutlet private weak var coverButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView! {
        didSet {
            imageView.lets {
                $0.ext.roundCorners(corners: .allCorners, radius: 10)
            }
        }
    }
    
    var checkboxButtonDriver: Driver<()> {
        checkboxButton.rx.tap.throttle().takeUntil(rx.obsolete).asDriver(onErrorJustReturn: ())
    }
    
    var coverButtonDriver: Driver<()> {
        coverButton.rx.tap.throttle().takeUntil(rx.obsolete).asDriver(onErrorJustReturn: ())
    }
    
    override func bindStyles() {
        self.lets {
            $0.ext.roundCorners(corners: .allCorners, radius: 10)
        }
    }
    
    override func configureWith(value: BaseCollectionCellModelProtocol) {
        guard let cellModel = value as? MessageCardCollectionCellModel else { return }
        
        guard let cardImageUrl = cellModel.cardImageName else { return }
        imageView.kf.setImage(with: URL(cardImageUrl), options: [.transition(.fade(1))])
        setCheckbox(cellModel)
    }
    
    func setCheckbox(_ cellModel: MessageCardCollectionCellModel) {
        checkboxButton.setImage(cellModel.checkImage, for: .normal)
    }
    
    func sendTapAction() {
        coverButton.sendActions(for: .touchUpInside)
    }
}
