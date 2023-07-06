//
//  RadioLabelCell.swift
//  TWBank
//
//  Created by Sunwoo.Kim on 29/04/2019.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RadioLabelCell: BaseCell {
    @IBOutlet private weak var radioButton: UIButton! {
        didSet {
            radioButton.setImage(UIImage(named: "btnRadioOff"), for: .normal)
            radioButton.setImage(UIImage(named: "btnRadioOn"), for: .selected)
        }
    }
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UISFSLabel!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var radioButtonLeftConstraints: NSLayoutConstraint!
    @IBOutlet private weak var stackViewLeftConstraints: NSLayoutConstraint!
    @IBOutlet private weak var stackViewBottomContraints: NSLayoutConstraint!
    
    private var allowsCellSelection = false
    var radioButtonDriver: Driver<()> {
        radioButton.rx.tap.takeUntil(rx.obsolete).asDriver(onErrorJustReturn: ())
    }
    
    weak var model: RadioLabelCellModel?
    
    override func configureWith(value: BaseCellModelProtocol) {
        guard let model = value as? RadioLabelCellModel else { return }
        self.model = model
        titleLabel.lets {
            $0.font = StyleFont.body2(weight: .regular).apply
        }
        
        descriptionLabel.lets {
            $0.font = model.isBoldDescription ?? true ? StyleFont.body5.apply : StyleFont.body6(weight: .regular).apply
            $0.textColor = StyleColor.gray_97999E.apply
        }
        
        titleLabel.text = model.title
        titleLabel.textColor = model.titleColor.apply
        
        setDescription(description: model.description.unwrap())
        descriptionLabel.isHidden = model.isDescriptionHidden
        
        tag = model.tag
        
        if model.isEquallyFontSize {
            descriptionLabel.font = titleLabel.font
        }
        
        if model.stackViewBottomMargin != nil {
            stackViewBottomContraints.constant = model.stackViewBottomMargin ?? 24.0
        }
        radioButton.isSelected = model.isOn ?? false
        allowsCellSelection = model.allowsCellSelection
        guard let edgeInsets = model.descriptionEdgInsets else { return }
        let bottomInset = stackView.constraints.filter {
            $0.secondAttribute == NSLayoutConstraint.Attribute.bottom
        }.first
        stackView.spacing = edgeInsets.top
        stackViewLeftConstraints.constant = edgeInsets.left
        bottomInset?.constant = edgeInsets.bottom
        
        if model.type == .sfs {
            descriptionLabel.applySFS(model.description.unwrap(), target: descriptionLabel)
        }
        
        guard let leftMargin = model.radioButtonLeftMargin else { return }
        radioButtonLeftConstraints.constant = leftMargin
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if allowsCellSelection {
            setRadioButton(to: selected)
            radioButton.isUserInteractionEnabled = false
            self.model?.isOn = selected
        }
    }
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setRadioButton(to isSelected: Bool) {
        radioButton.isSelected = isSelected
    }
    
    func setDescription(description: String) {
        descriptionLabel.text = description
    }
}
