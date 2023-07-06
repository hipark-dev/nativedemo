//
//  CheckboxButtonCell.swift
//  NFTTradePlatform
//
//  Created by Hyunil.Park on 2022/06/16.
//

import UIKit
import RxSwift
import RxCocoa

enum CheckboxButtonCellType {
    case setting
    case `default`
    
    var edgeInsets: UIEdgeInsets {
        switch self {
        case .setting:
            return UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 6)
        case .default:
            return UIEdgeInsets(top: 6, left: 24, bottom: 6, right: 6)
        }
    }
    
    var height: CGFloat {
        switch self {
        case .setting:
            return 50
        case .default:
            return 42
        }
    }
}

class CheckboxButtonCell: BaseCell {
    @IBOutlet private weak var checkboxButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailViewButton: UIButton!
    @IBOutlet private weak var arrowButton: UIButton!
    var checkBoxButtonDriver: Driver<Void> {
        checkboxButton.rx.tap.throttle().takeUntil(rx.obsolete).asDriver(onErrorJustReturn: ())
    }
    var detailButtonDriver: Driver<Void> {
        detailViewButton.rx.tap.throttle().takeUntil(rx.obsolete).asDriver(onErrorJustReturn: ())
    }
    var checkboxButtonReference: UIButton { checkboxButton }
    private var checkboxSelectedStateRealy: BehaviorRelay<Bool> = .init(value: false)
    
    override func bindStyles() {
        checkboxButton.lets {
            $0.setBackgroundImage(UIImage(named: "btnCheckboxOn"), for: .selected)
            $0.setBackgroundImage(UIImage(named: "btnCheckboxOff"), for: .normal)
        }
    }
    
    override func configureWith(value: BaseCellModelProtocol) {
        guard let cellModel = value as? CheckboxButtonCellModel else {
            return
        }
        
        titleLabel.attributedText = cellModel.representTitle
        checkboxButton.isSelected = cellModel.isChecked
        detailViewButton.isHidden = !cellModel.isEnableDetailButton
        arrowButton.isHidden = !cellModel.isEnableDetailButton
        
        checkboxButton.snp.remakeConstraints { maker in
            maker.edges.equalTo(contentView).inset(cellModel.type.edgeInsets).priority(750)
            maker.leading.equalTo(cellModel.type.edgeInsets.left)
        }
        titleLabel.snp.remakeConstraints { maker in
            maker.height.equalTo(cellModel.type.height).priority(750)
        }
        guard cellModel.isNaturalyToggle else { return }
        bindCheckBoxTapEvent().disposed(by: disposeBag)
    }
    
    private func bindCheckBoxTapEvent() -> Disposable {
        checkBoxButtonDriver.drive(onNext: { [unowned self] in
            self.toggleCheckBox()
        })
    }
    
    func toggleCheckBox() {
        checkboxButton.isSelected.toggle()
        checkboxSelectedStateRealy.accept(checkboxButton.isSelected)
    }
    
    func notifyCheckboxChangeSelectedState() -> Driver<Bool> {
        checkboxSelectedStateRealy.takeUntil(rx.obsolete).skip(1).asDriver(onErrorJustReturn: false)
    }
    
}
