//
//  NumberLabelCell.swift
//  TWBank
//
//  Created by Sunwoo.Kim on 09/07/2019.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit
import BonMot
import SnapKit

class NumberLabelCell: BaseCell {
    let label: UILabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureWith(value: BaseCellModelProtocol) {
        guard let cellModel = value as? NumberLabelCellModel else { return }
        
        self.lets {
            $0.selectionStyle = .none
        }
        label.lets {
            $0.font = cellModel.font.applyDigit
            $0.text = cellModel.title
            $0.textColor = cellModel.textColor.apply
            $0.numberOfLines = cellModel.numberOfLines
            $0.snp.remakeConstraints {
                $0.edges.equalTo(contentView).inset(cellModel.edgeInsets)
                if let height = cellModel.height {
                    $0.height.equalTo(height)
                }
            }
            layoutIfNeeded()
        }
    }
}

