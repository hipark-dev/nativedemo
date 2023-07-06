//
//  DescriptionCell.swift
//  NFTTradePlatform
//
//  Created by Hyunil.Park on 2022/06/16.
//

import UIKit

enum DescriptionCellType {
    case authentication
    case cancellation
    case deposit
    case notification
    case customerInfo
    case selectAccount
    case manualExtend
    case lineAccountConnectingError
    case settingTransferLimit
    case loanAmount
    case loanDecrease
    case cannotOpenAccount
    case signup
    case permissionInfo
    
    var edgeInsets: UIEdgeInsets {
        switch self {
        case .authentication:
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 102)
        case .deposit, .notification:
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        case .cancellation:
            return UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 28)
        case .customerInfo:
            return UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 10)
        case .selectAccount:
            return UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 45)
        case .manualExtend, .lineAccountConnectingError, .settingTransferLimit, .loanAmount, .cannotOpenAccount,
             .permissionInfo:
            return UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 28)
        case .loanDecrease:
            return UIEdgeInsets(top: 12, left: 28, bottom: 0, right: 28)
        case .signup:
            return UIEdgeInsets(top: 0, left: 38, bottom: 0, right: 56)
        }
    }
    
    var height: CGFloat {
        switch self {
        case .authentication, .permissionInfo:
            return 0
        case .notification:
            return 15
        case .manualExtend:
            return 32
        case .cancellation:
            return 0
        case .deposit:
            return 15
        case .customerInfo:
            return 34
        case .selectAccount:
            return 33
        case .lineAccountConnectingError:
            return 54
        case .settingTransferLimit:
            return 0
        case .loanAmount:
            return 45
        case .loanDecrease:
            return 15
        case .cannotOpenAccount:
            return 15
        case .signup:
            return 47
        }
    }
}

class DescriptionCell: BaseCell {
    @IBOutlet private weak var descriptionLabel: UILabel!

    override func bindStyles() {
        descriptionLabel.lets {
            $0.font = StyleFont.body4(weight: .regular).apply
            $0.textColor = StyleColor.gray_97999E.apply
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
        }
    }
    
    override func configureWith(value: BaseCellModelProtocol) {
        guard let cellModel = value as? DescriptionCellModel else {
            return
        }
        
        descriptionLabel.text = cellModel.title
        
        switch cellModel.type {
        case .customerInfo:
            descriptionLabel.font = StyleFont.body5.apply
        case .lineAccountConnectingError, .permissionInfo:
            descriptionLabel.font = StyleFont.body2(weight: .regular).apply
            descriptionLabel.snp.remakeConstraints { maker in
                maker.edges.equalTo(cellModel.type.height).priority(750)
                maker.edges.equalTo(contentView).inset(cellModel.type.edgeInsets).priority(1000)
            }
        case .settingTransferLimit, .authentication, .notification, .cancellation,
             .manualExtend, .loanAmount, .cannotOpenAccount:
            descriptionLabel.snp.remakeConstraints { maker in
                maker.edges.equalTo(contentView).inset(cellModel.type.edgeInsets).priority(1000)
            }
        default:
            descriptionLabel.snp.remakeConstraints { maker in
                maker.height.equalTo(cellModel.type.height)
                maker.edges.equalTo(contentView).inset(cellModel.type.edgeInsets).priority(750)
            }
        }
        layoutIfNeeded()
        updateConstraintsIfNeeded()
    }
}
