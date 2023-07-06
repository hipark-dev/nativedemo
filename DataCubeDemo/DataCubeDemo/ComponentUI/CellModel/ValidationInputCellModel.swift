//
//  ValidationInputCellModel.swift
//  TWBank
//
//  Created by Hyunil.Park on 03/03/2020.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ValidationInputCellModel: BaseCellModel {
    
    override var cellIdentifier: UITableViewCell.Type {
        ValidationInputCell.self
    }
    
    enum State: Equatable {
        case `default`
        case validDefault
        case valid
        case invalid
        case error(message: String)
        case start
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case let (.error(leftMessage), .error(rightMessage)):
                return leftMessage == rightMessage
            default:
                return String(describing: lhs.self) == String(describing: rhs.self)
            }
        }
    }
    
    let textType: ValidationInputCell.TextType
    let inputObservable: PublishRelay<String?> = .init()
    let cellStateObservable: PublishRelay<State> = .init()
    let editingBeginObservable: PublishRelay<()> = .init()
    let editingEndObservable: PublishRelay<()> = .init()
    let setValueObservable: PublishRelay<String> = .init()
    let inputMaskingValueObservable: PublishRelay<String> = .init()
    
    var state: State = .default
    var disposeBag = DisposeBag()
    var defaultText: String = .empty
    var defaultAttributeText: NSAttributedString = .init()
    var secureText: String?
    var textFieldStyleFont: StyleFont = StyleFont.subtitle2(weight: .regular)
    var activeTextFieldFont: StyleFont?
    var textFieldStyleColor: StyleColor?
    var textFieldKern: CGFloat?
    var textFieldAttributedString: NSAttributedString?
    var textFieldMaxLength: Int = UIConstant.inputMaxLength
    var errorMessage: String?
    var description: String?
    var descriptionShow = InputStatus<Bool>(with: false,
                                            setDefautWhenEnd: false)
    // Placeholder
    var placeholder: String?
    var showingTopPlaceholder: ValidationInputCell.ShowingTopPlaceholder = .never
    
    // Key
    var key: String = .empty
    
    // image
    var isActiveCheckImage = false
    
    // Line
    var isLineHidden = false
    var isActiveLineColor = false
    var lineHeight: InputStatus<CGFloat> {
        InputStatus<CGFloat>( with: 1,
                              setDefautWhenEnd: false)
    }
    
    var lineColor: InputStatus<StyleColor> {
        
        if isActiveLineColor {
            return InputStatus<StyleColor>( default: .gray_ECECEC,
                                            start: .green_24C875,
                                            success: .green_24C875,
                                            fail: .red_FF3A44,
                                            setDefautWhenEnd: false)
        } else {
            return InputStatus<StyleColor>( with: .gray_ECECEC,
                                            setDefautWhenEnd: false)
        }
    }
    
    var representAttributeText: NSAttributedString {
        if defaultAttributeText.length > .zero {
            return defaultAttributeText
        } else {
            return defaultText.attributedString()
        }
    }
    
    // Init
    init(type textType: ValidationInputCell.TextType, style: Option...) {
        self.textType = textType
        super.init()
        style.forEach {
            switch $0 {
            case .none:
                break
            // TextField
            case .defaultText(let text):
                defaultText = text
            case .textFieldColor(let color):
                textFieldStyleColor = color
            case .textFieldFont(let font):
                textFieldStyleFont = font
            case .activeTextFieldFont(let font):
                activeTextFieldFont = font
            case .textFieldKern(let value):
                textFieldKern = value
            case .defaultAttriburedString(let attributed):
                defaultAttributeText = attributed
            case .textFieldMaxLength(let length):
                textFieldMaxLength = length
            // Description & Error
            case let .description(text, show):
                description = text
                descriptionShow = show
            case .errorMessage(let text):
                errorMessage = text
            // Placeholder
            case let .placeholder(text, showTop):
                placeholder = text
                showingTopPlaceholder = showTop
            // Key
            case .key(let text):
                key = text
            // Image
            case .checkImage(let isActive):
                isActiveCheckImage = isActive
            // Line
            case .line(let isHidden):
                isLineHidden = isHidden
            case .lineColor(let isActive):
                isActiveLineColor = isActive
            case .state(let state):
                self.state = state
            }
        }
    }
}

extension ValidationInputCellModel {
    
    enum Option {
        case `none`
        // TextField
        case defaultText(String)
        case textFieldColor(style: StyleColor)
        case textFieldFont(style: StyleFont)
        case activeTextFieldFont(style: StyleFont)
        case defaultAttriburedString(attributeted: NSMutableAttributedString)
        case textFieldKern(value: CGFloat)
        case textFieldMaxLength(value: Int)
        // Description & Error
        case description(text: String, show: InputStatus<Bool>)
        case errorMessage(text: String)
        // Placeholder
        case placeholder(text: String, showTop: ValidationInputCell.ShowingTopPlaceholder)
        // Key
        case key(String)
        // Image
        case checkImage(isActive: Bool)
        // Line
        case line(hidden: Bool)
        case lineColor(isActive: Bool)
        // Cell Status
        case state(State)
    }
}

struct InputStatus<T: Equatable> {
    let `default`: T
    let start: T
    let success: T
    let fail: T
    let setDefautWhenEnd: Bool
    
    init(default: T, start: T, success: T, fail: T, setDefautWhenEnd: Bool) {
        self.default = `default`
        self.start = start
        self.success = success
        self.fail = fail
        self.setDefautWhenEnd = setDefautWhenEnd
    }
    
    init(with value: T, setDefautWhenEnd: Bool) {
        self.default = value
        self.start = value
        self.success = value
        self.fail = value
        self.setDefautWhenEnd = setDefautWhenEnd
    }
}
