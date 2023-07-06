//
//  TextArrowCellModel.swift
//  TWBank
//
//  Created by KyuHo.Son on 17/05/2019.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit

class TextArrowCellModel: BaseCellModel {
    override var cellIdentifier: UITableViewCell.Type {
        TextArrowCell.self
    }
    
    enum CellType {
        case none
        case debitCard
        case jointMembers
        case stopJoint
        case method
        case notiScope
        case schedulePayment
        case withdraw
        case earlyRepayment
        case regularRepayment
        case interestChangeNotice
        case repaymentInfoChange
    }
    
    let title: String
    let rightText: String
    let userData: String
    let contactId: String
    let isDimded: Bool
    let cellType: CellType
    let cardStatus: APIConstant.Card.StatusCode
    let isHiddenArrow: Bool
    
    init(_ title: String,
         _ rightText: String = .empty,
         userData: String = .empty,
         isDimded: Bool = false,
         cellType: CellType = .none,
         isHiddenArrow: Bool = false) {
        
        self.title = title
        self.contactId = UIConstant.empty
        self.rightText = rightText
        self.userData = userData
        self.isDimded = isDimded
        self.cellType = cellType
        self.cardStatus = .unknown
        self.isHiddenArrow = isHiddenArrow
    }

    init(_ title: String,
         _ contactId: String,
         _ cardStatus: APIConstant.Card.StatusCode?,
         _ rightText: String = .empty,
         userData: String = .empty,
         isDimded: Bool = false,
         cellType: CellType = .none) {
        
        self.title = title
        self.contactId = contactId
        self.cardStatus = cardStatus ?? .unknown
        self.rightText = rightText
        self.userData = userData
        self.isDimded = isDimded
        self.cellType = cellType
        self.isHiddenArrow = false
    }
}
