//
//  TitleCell.swift
//  TWBank
//
//  Created by KyuHo.Son on 22/04/2019.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

enum TitleCellType {
    case setting
    case settingNotification
    case settingTransferLimit
    case lineAccountConnectingError
    case cancellation
    case selectAccount
    case reasonSignOut
    case termCondition
    case picture
    case mainAccount
    case customerInfo
    case splitbillMain
    case splitbillComplete
    case splitbillContent
    case splitbillValidDate
    case splitbillMember
    case splitbillCount
    case occupation
    case transactionSummary
    case timeline
    case schedule
    case bigAmount
    case schedulePeriod
    case bankSearch
    case noSearchList
    case sameAccountError
    case bigLimitAmount
    case scheduleEmptyTitle
    case scheduleEmptySubTitle
    case permission
    
    var edgeInsets: UIEdgeInsets {
        switch self {
        case .setting:
            return UIEdgeInsets(top: 16, left: 16, bottom: 15, right: 16)
        case .settingNotification:
            return UIEdgeInsets(top: 7, left: 16, bottom: 7, right: 16)
        case .settingTransferLimit:
            return UIEdgeInsets(top: 7, left: 28, bottom: 7, right: 28)
        case .cancellation:
            return UIEdgeInsets(top: 7, left: 28, bottom: 7, right: 28)
        case .reasonSignOut, .termCondition:
            return UIEdgeInsets(top: 12, left: 28, bottom: 12, right: 28)
        case .selectAccount, .lineAccountConnectingError, .noSearchList:
            return UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 28)
        case .mainAccount:
            return UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        case .picture, .customerInfo, .splitbillMain:
            return UIEdgeInsets(top: 10, left: 28, bottom: 10, right: 16)
        case .splitbillComplete:
            return UIEdgeInsets(top: 0, left: 28, bottom: 4, right: 16)
        case .transactionSummary:
            return UIEdgeInsets(top: 2, left: 28, bottom: 2, right: 16)
        case .splitbillValidDate:
            return UIEdgeInsets(top: 3, left: 28, bottom: 0, right: 16)
        case .splitbillCount:
            return UIEdgeInsets(top: 7, left: 28, bottom: 8, right: 16)
        case .splitbillContent:
            return UIEdgeInsets(top: 8, left: 28, bottom: 8, right: 16)
        case .splitbillMember:
            return UIEdgeInsets(top: 8, left: 28, bottom: 8, right: 16)
        case .schedule:
            return UIEdgeInsets(top: 8, left: 28, bottom: 2, right: 16)
        case .occupation:
            return UIEdgeInsets(top: 12, left: 28, bottom: 12, right: 28)
        case .timeline, .bankSearch:
            return UIEdgeInsets(top: 1, left: 16, bottom: 1, right: 16)
        case .bigAmount, .bigLimitAmount:
            return UIEdgeInsets(top: 0, left: 26, bottom: 0, right: 28)
        case .schedulePeriod, .sameAccountError, .scheduleEmptyTitle, .scheduleEmptySubTitle:
            return UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 28)
        case .permission:
            return UIEdgeInsets(top: 22, left: 28, bottom: 16, right: 27)
        }
    }
    
    var height: CGFloat {
        switch self {
        case .setting, .splitbillComplete, .transactionSummary, .schedulePeriod:
            return 19
        case .picture, .customerInfo, .splitbillMain, .timeline:
            return 20
        case .settingNotification:
            return 20
        case .settingTransferLimit:
            return 20
        case .cancellation, .lineAccountConnectingError:
            return 18
        case .reasonSignOut:
            return 0
        case .termCondition, .selectAccount:
            return 36
        case .mainAccount:
            return 15
        case .splitbillContent:
            return 30
        case .splitbillValidDate:
            return 14
        case .splitbillCount, .schedule:
            return 12
        case .splitbillMember, .bankSearch:
            return 13
        case .noSearchList:
            return 15
        case .occupation:
            return 36
        case .bigAmount, .bigLimitAmount:
            return 48
        case .sameAccountError:
            return 32
        case .scheduleEmptyTitle, .scheduleEmptySubTitle:
            return 60
        case .permission:
            return 33
        }
    }
    
    var font: UIFont {
        switch self {
        case .setting, .settingNotification:
            return StyleFont.subtitle3(weight: .bold).apply
        case .lineAccountConnectingError:
            return StyleFont.body2(weight: .bold).apply
        case .cancellation:
            return StyleFont.body2(weight: .regular).apply
        case .reasonSignOut, .termCondition, .selectAccount:
            return StyleFont.head2.apply
        case .settingTransferLimit:
            return StyleFont.body1(weight: .bold).apply
        case .picture, .transactionSummary, .timeline:
            return StyleFont.body2(weight: .bold).apply
        case .splitbillContent:
            return StyleFont.head2.apply
        case .customerInfo, .splitbillMain:
            return StyleFont.body1(weight: .bold).apply
        case .splitbillComplete:
            return StyleFont.subtitle1(weight: .regular).apply
        case .splitbillValidDate:
             return StyleFont.body6(weight: .regular).apply
        case .splitbillCount:
            return StyleFont.body5.apply
        case .schedule:
            return StyleFont.body6(weight: .regular).apply
        case .splitbillMember, .bankSearch, .mainAccount:
            return StyleFont.body4(weight: .bold).apply
        case .occupation:
            return StyleFont.head2.apply
        case .bigAmount:
            return StyleNumberFont.no2.applyDigit
        case .bigLimitAmount:
            if UIDevice.is47InchesOrLarger() {
                return StyleNumberFont.no4.applyDigit
            } else {
                return StyleFont.input1(weight: .bold).apply
            }
        case .schedulePeriod:
            return StyleFont.subtitle1(weight: .regular).apply
        case .noSearchList:
            return StyleFont.body2(weight: .regular).apply
        case .sameAccountError:
            return StyleFont.body3(weight: .regular).apply
        case .scheduleEmptyTitle:
            return StyleFont.head3(weight: .bold).apply
        case .scheduleEmptySubTitle:
            return StyleFont.body1(weight: .regular).apply
        case .permission:
            return StyleFont.head7(weight: .bold).apply
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .reasonSignOut, .termCondition:
            return StyleColor.black_000000.apply
        case .splitbillCount:
            return StyleColor.green_24C875.apply
        case .splitbillValidDate, .lineAccountConnectingError, .scheduleEmptySubTitle:
            return StyleColor.gray_97999E.apply
        case .schedule:
            return StyleColor.gray_D0D0D5.apply
        case .noSearchList:
            return StyleColor.gray_C1C1C1.apply
        case .sameAccountError:
            return StyleColor.lipstickRed_DB1425.apply
        default:
            return StyleColor.black_222222.apply
        }
    }
}

class TitleCell: BaseCell, View {
    
    typealias Reactor = TitleCellReactor
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func bindStyles() {
        titleLabel.numberOfLines = 0
    }
    
    func bind(reactor: TitleCellReactor) {
        let cellModel = reactor.currentState.cellModel
        
        titleLabel.lets {
            $0.text = cellModel.title
            $0.textColor = cellModel.type.textColor
            $0.font = cellModel.type.font
        }
        
        switch cellModel.type {
        case .reasonSignOut:
            titleLabel.snp.remakeConstraints { maker in
                maker.edges.equalTo(contentView).inset(cellModel.type.edgeInsets).priority(1000)
            }
        case .noSearchList:
            titleLabel.snp.remakeConstraints { maker in
                maker.height.equalTo(cellModel.type.height)
                maker.centerX.equalToSuperview().priority(750)
            }
        case .cancellation:
            titleLabel.lineBreakMode = .byWordWrapping
            titleLabel.snp.remakeConstraints { maker in
                maker.edges.equalTo(contentView).inset(cellModel.type.edgeInsets).priority(750)
            }
        case .sameAccountError:
            titleLabel.lineBreakMode = .byWordWrapping
            titleLabel.snp.remakeConstraints { maker in
                maker.edges.equalTo(contentView).inset(cellModel.type.edgeInsets).priority(750)
            }
        case .scheduleEmptyTitle, .scheduleEmptySubTitle:
            titleLabel.snp.remakeConstraints { maker in
                maker.height.equalTo(cellModel.type.height)
                maker.edges.equalTo(contentView).inset(cellModel.type.edgeInsets).priority(750)
            }
            titleLabel.textAlignment = .center
        case .splitbillContent:
            titleLabel.snp.remakeConstraints { maker in
                maker.height.equalTo(cellModel.type.height)
                maker.edges.equalTo(contentView).inset(cellModel.type.edgeInsets).priority(750)
            }
            titleLabel.adjustsFontSizeToFitWidth = true
        default:
            titleLabel.snp.remakeConstraints { maker in
                maker.height.equalTo(cellModel.type.height)
                maker.edges.equalTo(contentView).inset(cellModel.type.edgeInsets).priority(750)
            }
        }
        
        layoutIfNeeded()
        updateConstraintsIfNeeded()
    }
}
