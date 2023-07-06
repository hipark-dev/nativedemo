//
//  SettingInfoCell
//  TWBank
//
//  Created by Sunwoo.Kim on 02/05/2019.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class SettingInfoCell: BaseCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!

    override func configureWith(value: BaseCellModelProtocol) {
        guard let cellModel = value as? SettingInfoCellModel else { return }
        
        titleLabel.text = cellModel.title
        detailLabel.lets {
            $0.text = cellModel.detail
            $0.lineBreakMode = .byWordWrapping
            $0.numberOfLines = cellModel.lineType.numberOfLines
            $0.sizeToFit()
        }
        layoutIfNeeded()
    }
    
}
