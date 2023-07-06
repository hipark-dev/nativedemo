//
//  CheckBoxCell.swift
//  NFTTradePlatform
//
//  Created by Hyunil.Park on 2022/06/16.
//

import UIKit
import RxSwift
import RxCocoa

class CheckBoxCell: BaseCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var checkButton: UIButton!
    @IBOutlet private weak var checkImageView: UIImageView!

    enum Constants {
        static let animationTime: CGFloat = 0.3
        static let scaleOriginal: CGFloat = 0.5
        static let scaleChange: CGFloat = 1.0
    }
    
    var checkImageName: String {
        checkButton.isSelected ? "btnCheckboxOn" : "btnCheckboxOff"
    }
    
    var checkButtonDriver: Driver<()> {
        checkButton.rx.tap.takeUntil(rx.obsolete).asDriver(onErrorJustReturn: ())
    }
    
    var cellModel: CheckBoxCellModel?
    
    override func bindStyles() {
        titleLabel.lets {
            $0.font = StyleFont.body1(weight: .regular).apply
            $0.textColor = StyleColor.black_222222.apply
            $0.numberOfLines = 0
        }
    }
    
    func changeSelectedState() {
        self.checkButton.isSelected = !self.checkButton.isSelected
        self.checkImageView.image = UIImage(named: self.checkImageName)
        
        if self.checkButton.isSelected == true {
            self.checkImageView.transform = CGAffineTransform(scaleX: Constants.scaleOriginal, y: Constants.scaleOriginal)
            UIView.animate(withDuration: TimeInterval(Constants.animationTime), animations: {
                self.checkImageView.transform = CGAffineTransform(scaleX: Constants.scaleChange, y: Constants.scaleChange)
                self.cellModel?.isSelected = self.checkButton.isSelected
            })
        } else {
            self.cellModel?.isSelected = self.checkButton.isSelected
        }
    }
    
    override func configureWith(value: BaseCellModelProtocol) {
        guard let cellModel = value as? CheckBoxCellModel else {
            return
        }
        self.cellModel = cellModel
        
        titleLabel.text = cellModel.title
        checkButton.isSelected = cellModel.isSelected
        checkImageView.image = UIImage(named: checkImageName)
    }
}
