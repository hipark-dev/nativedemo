//
//  FullButtonCellModel.swift
//  TWBank
//
//  Created by KyuHo.Son on 20/05/2019.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit
import BonMot

class FullButtonCellModel: BaseCellModel {
    override var cellIdentifier: UITableViewCell.Type {
        FullButtonCell.self
    }
    
    let type: ButtonType
    
    let title: String
    var state: ButtonState
    
    var backgroudColor: UIColor {
        switch type {
        case .default, .login:
            return state.backgroundColor
        case .splitbilldetail:
            return StyleColor.white_FFFFFF.apply
        }
    }
    var titleAttributedString: NSAttributedString {
        switch type {
        case .default, .login:
            return title.styled(with: StringStyle(.font(StyleFont.body1(weight: StyleFont.FontWeight.bold).apply), .color(.white)))
        case .splitbilldetail:
            return title.styled(with: StringStyle(.font(StyleFont.body3(weight: .regular).apply), .color(StyleColor.gray_97999E.apply)))
        }
    }
    var edgeInsets: UIEdgeInsets {
        switch type {
        case .default, .splitbilldetail:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .login:
            return UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 28)
        }
    }
    
    var height: CGFloat {
        switch type {
        case .default, .login:
            return 56
        case .splitbilldetail:
            return 64
        }
    }
    
    var cornerRadius: CGFloat {
        switch type {
        case .default:
            return 0
        case .login:
            return 5
        case .splitbilldetail:
            return 0
            
        }
    }
    
    init(title: String, state: ButtonState, type: ButtonType = .default) {
        self.title = title
        self.state = state
        self.type = type
    }
}

extension FullButtonCellModel {
    enum ButtonType {
        case `default`
        case login
        case splitbilldetail
    }
}
