//
//  InputCellModel.swift
//  TWBank
//
//  Created by Hyunil.Park on 10/05/2019.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import BonMot
import RxDataSources
import RxSwift
import RxCocoa

enum InputFieldType {
    case normal
    case password
    case currency
    case number
    case secureNumber
    case disable
    case phoneNumber
    case sfs
    case disabledSFS
    case allowChinese
    case email
}

enum PlaceHolderType {
    case top
    case textField
    case `none`
}

enum ValidationLineColor {
    case valid
    case invalid
    case `default`
    
    var lineColor: UIColor {
        switch self {
        case .valid:
            return StyleColor.green_24C875.apply
        case .invalid:
            return StyleColor.red_FF0008.apply
        case .default:
            return StyleColor.gray_ECECEC.apply
        }
    }
}

class InputDeactiveCellModel: BaseCellModel {
    
    override var cellIdentifier: UITableViewCell.Type {
        InputDeactiveCell.self
    }
    
    let subTitleString: String
    let mainTitleString: String
    let activeImageName: String
    var activeImage: UIImage? {
        activeImageName.isEmpty ? nil : UIImage(named: activeImageName)
    }
    let lineColor: ValidationLineColor
    
    init(subTitleString: String, mainTitleString: String, imageName: String = .empty, lineColor: ValidationLineColor) {
        self.subTitleString = subTitleString
        self.mainTitleString = mainTitleString
        self.activeImageName = imageName
        self.lineColor = lineColor
    }
}

class InputDoneCellModel: BaseCellModel {
    
    override var cellIdentifier: UITableViewCell.Type {
        InputDoneCell.self
    }
    
    let disposeBag = DisposeBag()
    
    let changeValueObservable: PublishRelay<String?> = .init()
    let editingBeginObservable: PublishRelay<()> = .init()
    let editingEndObservable: PublishRelay<()> = .init()
    
    var textType: InputFieldType
    var defaultText: String = .empty
    var textFieldFont: StyleFont?
    var subTitle: String = .empty
    var subTitleFont: StyleFont?
    var placeholder: String = .empty
    var lineColor: ValidationLineColor = .default
    var key: String = .empty
    var isEnabled: Bool = true
    var description: String = .empty
    var inputDoneButtonHidden: Bool = true
    var isTitleFieldFocus: Bool = false
    var textFieldMaxLength: Int = UIConstant.inputMaxLength
    
    init(type textType: InputFieldType, style: CellStatus...) {
        self.textType = textType
        super.init()
        style.forEach {
            switch $0 {
            case .none:
                break
            case let .defaultText(text, font):
                defaultText = text
                textFieldFont = font
            case let .subTitle(text, font):
                subTitle = text
                subTitleFont = font
            case .placeHolder(let text):
                placeholder = text
            case .lineColor(let color):
                lineColor = color
            case .key(let key):
                self.key = key
            case .isEnabled(let flag):
                self.isEnabled = flag
            case .description(let text):
                self.description = text
            case .inputDoneButtonHidden(let flag):
                self.inputDoneButtonHidden = flag
            case .setTextFieldFocus(let flag):
                self.isTitleFieldFocus = flag
            }
        }
    }
    
}

extension InputDoneCellModel {
    enum CellStatus {
        case `none`
        case defaultText(text: String, font: StyleFont = StyleFont.subtitle2(weight: .regular))
        case subTitle(text: String, font: StyleFont = StyleFont.body5)
        case placeHolder(text: String)
        case lineColor(color: ValidationLineColor = .default)
        case key(key: String)
        case isEnabled(flag: Bool)
        case description(text: String)
        case inputDoneButtonHidden(flag: Bool)
        case setTextFieldFocus(flag: Bool)
    }
}

class InputDoneWithButtonCellModel: BaseCellModel {
    
    override var cellIdentifier: UITableViewCell.Type {
        InputDoneWithButtonCell.self
    }
    
    enum State {
        case `default`
        case invalid
        case valid
        case error(message: String)
    }
    
    let disposeBag = DisposeBag()
    
    let changeValueObservable: PublishRelay<String?> = .init()
    let editingBeginObservable: PublishRelay<()> = .init()
    let editingEndObservable: PublishRelay<()> = .init()
    let cellStateObservable: PublishRelay<State> = .init()
    let buttonStatusObservable: PublishRelay<(title: String, color: StyleColor)> = .init()
    let buttonHiddenObservable: PublishRelay<Bool> = .init()
    let descriptionObservable: PublishRelay<String> = .init()
    let setValueObservable: PublishRelay<String> = .init()
    
    var state: State = .default
    var textType: InputFieldType
    var defaultText: String = .empty
    var defaultAttributeText: NSAttributedString = .init()
    var inputTextFont: StyleFont?
    var inputTextColor: StyleColor?
    var subTitle: String = .empty
    var subTitleFont: StyleFont?
    var placeholder: String = .empty
    var lineColor: ValidationLineColor = .default
    var buttonTitle: String = .empty
    var buttonTextColor: StyleColor?
    var buttonTitleFont: StyleFont = .body2(weight: .bold)
    var buttonEnabled: Bool = false
    var key: String = .empty
    var description: String = .empty
    var descriptionColor: UIColor = StyleColor.gray_97999E.apply
    var descriptionHiddenFlag: Bool = true
    var descriptionFont: UIFont = StyleFont.body5.apply
    var imageName: String = .empty
    var textFieldEnabled: Bool = true
    var subTitleHiddenFlag: Bool = false
    var textFieldMaxLength: Int = UIConstant.inputMaxLength
    
    var representAttributedText: NSAttributedString {
        if defaultAttributeText.length > .zero {
            return defaultAttributeText
        } else {
            return defaultText.attributedString()
        }
    }
    
    init(type textType: InputFieldType, style: CellStatus...) {
        self.textType = textType
        super.init()
        style.forEach {
            switch $0 {
            case .none:
                break
            case .defaultText(let text):
                defaultText = text
            case .inputTextFont(let font):
                inputTextFont = font
            case .inputTextColor(let color):
                inputTextColor = color
            case let .subTitle(text, font):
                subTitle = text
                subTitleFont = font
            case .placeHolder(let text):
                placeholder = text
            case .lineColor(let color):
                lineColor = color
            case let .buttonProperty(text, textColor, font):
                buttonTitle = text
                buttonTextColor = textColor
                buttonTitleFont = font
            case .buttonEnable(let flag):
                buttonEnabled = flag
            case .key(let key):
                self.key = key
            case .state(let state):
                self.state = state
            case .imageName(let name): imageName = name
            case .textFieldEnabled(let flag):
                self.textFieldEnabled = flag
            case .defaultAttributeText(let text):
                self.defaultAttributeText = text
            case .textFieldMaxLength(let length):
                textFieldMaxLength = length
            case .description(let text):
                description = text
            case .descriptionHiddenValue(let flag):
                descriptionHiddenFlag = flag
            case .descriptionColor(let color):
                descriptionColor = color
            case .descriptionFont(let font):
                descriptionFont = font
            }
        }
        
        subTitleHiddenFlag = !defaultText.isNotEmpty
        if subTitleHiddenFlag {
            subTitleHiddenFlag = !defaultAttributeText.string.isNotEmpty
        }
    }
}

extension InputDoneWithButtonCellModel {
    enum CellStatus {
        case `none`
        case defaultText(text: String)
        case defaultAttributeText(text: NSAttributedString)
        case inputTextColor(color: StyleColor = StyleColor.black_222222)
        case inputTextFont(font: StyleFont = StyleFont.subtitle2(weight: .regular))
        case subTitle(text: String, font: StyleFont = StyleFont.body5)
        case placeHolder(text: String)
        case lineColor(color: ValidationLineColor = .default)
        case buttonProperty(text: String, textColor: StyleColor, font: StyleFont = StyleFont.body2(weight: .bold))
        case buttonEnable(isEnable: Bool)
        case key(key: String)
        case state(State)
        case imageName(imageName: String)
        case textFieldEnabled(flag: Bool)
        case textFieldMaxLength(value: Int)
        case description(value: String)
        case descriptionHiddenValue(value: Bool)
        case descriptionColor(color: UIColor)
        case descriptionFont(font: UIFont)
    }
}
