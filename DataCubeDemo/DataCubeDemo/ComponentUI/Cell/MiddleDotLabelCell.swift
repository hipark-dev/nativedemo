//
//  MiddleDotLabelCell.swift
//  NFTTradePlatform
//
//  Created by Hyunil.Park on 2022/06/16.
//

import UIKit
import SnapKit

class MiddleDotLabelCell: BaseCell {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var dotLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func configureWith(value: BaseCellModelProtocol) {
        guard let cellModel = value as? MiddleDotLabelCellModel else { return }
        dotLabel.lets {
            $0.font = cellModel.font.apply
            $0.textColor = cellModel.textColor.apply
        }
        
        descriptionLabel.lets {
            $0.text = cellModel.title
            $0.font = cellModel.font.apply
            $0.textColor = cellModel.textColor.apply
            $0.snp.remakeConstraints {
                $0.leading.equalTo(containerView).offset(cellModel.space)
            }
        }
        
        containerView.lets {
            $0.snp.remakeConstraints {
                $0.edges.equalTo(contentView).inset(cellModel.edgeInsets)
            }
        }
        
        if let backgroundColor = cellModel.backgroundColor {
            containerView.backgroundColor = backgroundColor.apply
        }
        
        if cellModel.title.notExist {
            descriptionLabel.attributedText = cellModel.titleAttributedText
        }
    }
}
