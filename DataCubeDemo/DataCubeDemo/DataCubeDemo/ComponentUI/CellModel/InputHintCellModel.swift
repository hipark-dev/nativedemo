//
//  InputHintCellModel.swift
//  TWBank
//
//  Created by Hyunil.Park on 21/05/2019.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import RxSwift
import RxCocoa

class InputHintCellModel: BaseCellModel {
    
    override var cellIdentifier: UITableViewCell.Type {
        InputHintCell.self
    }
    
    var activeImageName: String = .empty
    var titleString: String = .empty
    var titleFont: StyleFont?
    var subTitleString: String = .empty
    var subTitleFont: StyleFont?
    var activeImage: UIImage? {
        activeImageName.isEmpty ? UIImage(named: "arrowS") : UIImage(named: activeImageName)
    }
    var lineColor: ValidationLineColor = .default
    var subTitleHiddenFlag: Bool = true
    var key: String = .empty
    var isEnabled: Bool = true
    
    init(style: CellStatus...) {
        super.init()
        style.forEach {
            switch $0 {
            case .none:
                break
            case let .title(text, font):
                titleString = text
                titleFont = font
            case let .subTitle(text, font):
                subTitleString = text
                subTitleFont = font
            case .imageName(let imageName):
                activeImageName = imageName
            case .lineColor(let color):
                lineColor = color
            case .key(let key):
                self.key = key
            case .subTitleHiddenFlag(let flag):
                subTitleHiddenFlag = flag
            case .isEnabled(let flag):
                isEnabled = flag
            }
        }
    }
}

extension InputHintCellModel {
    enum CellStatus {
        case `none`
        case title(text: String, font: StyleFont = StyleFont.subtitle2(weight: .regular))
        case subTitle(text: String, font: StyleFont = StyleFont.body5)
        case imageName(imageName: String)
        case lineColor(color: ValidationLineColor)
        case key(key: String)
        case subTitleHiddenFlag(key: Bool)
        case isEnabled(flag: Bool)
    }
}

class InputHintWith2TextFieldCellModel: BaseCellModel {
    
    override var cellIdentifier: UITableViewCell.Type {
        InputHintWith2TextFieldCell.self
    }
    
    var disposeBag = DisposeBag()
    
    let input1Observable: PublishRelay<String?> = .init()
    let input2Observable: PublishRelay<String?> = .init()
    
    var placeHolder1: String
    var placeHolder2: String
    var title: String
    var defaultText1: String
    var defaultText2: String
    var isEnabled: Bool
    var description: String
    let textFieldMaxLength: Int = UIConstant.inputMaxLength
    
    init(placeHolder1: String,
         placeHolder2: String,
         title: String = .empty,
         defaultText1: String = .empty,
         defaultText2: String = .empty,
         isEnabled: Bool = true,
         description: String = .empty) {
        self.title = title
        self.placeHolder1 = placeHolder1
        self.placeHolder2 = placeHolder2
        self.defaultText1 = defaultText1
        self.defaultText2 = defaultText2
        self.isEnabled = isEnabled
        self.description = description
    }
}
