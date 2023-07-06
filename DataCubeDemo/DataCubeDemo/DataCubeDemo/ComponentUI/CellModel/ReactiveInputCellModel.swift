//
//  ReactiveInputCellModel.swift
//  TWBank
//
//  Created by Sunwoo.Kim on 20/05/2019.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit
import RxSwift

class ReactiveInputCellModel: BaseCellModel, TextInputsModelBehavior {
    
    override var cellIdentifier: UITableViewCell.Type {
        ReactiveInputCell.self
    }
    
    enum State: Equatable {
        case `default`
        case invalid
        case valid
        case error(message: String)
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case let (.error(leftMessage), .error(rightMessage)):
                return leftMessage == rightMessage
            default:
                return String(describing: lhs.self) == String(describing: rhs.self)
            }
        }
    }
    
    var state: State = .default
    var disposeBag = DisposeBag()
    
    var keyboardShow: Bool = false
    
    // TextField
    var isCurrency = false
    
    var defaultText = ""
    var secureText: String?
    var textValidStateSubject: PublishSubject<Bool> = .init()
    let textType: ReactiveInputCell.TextType
    
    var textFieldStyleFont: StyleFont?
    var textFieldStyleColor: StyleColor?
    var textFieldStyleNumberFont: StyleNumberFont?
    var textFieldKern: CGFloat?
    var textFieldAttributedString: NSMutableAttributedString?
    var textFieldTopMargin: CGFloat?
    var textFieldHeight: CGFloat = 37
    var textFieldMaxLength: Int = UIConstant.inputMaxLength
    var allowTextInputEvent: InputStatus<Bool> = InputStatus<Bool>(with: true, setDefautWhenEnd: true)

    // Description & Error
    var errorMessage: String?
    var description: String?
    var descriptionShow = InputStatus<Bool>(with: false,
                                            setDefautWhenEnd: false)

    // Placeholder
    var placeholder: String?
    var placeholderColor: StyleColor = .gray_C1C1C1
    var showingTopPlaceholder: ReactiveInputCell.ShowingTopPlaceholder = .never
    
    // Button
    var isCoverButtonHidden = true
    
    private var buttonType: ButtonType = .none
    var buttonImageName: String {
        buttonType.imageName
    }
    
    func getButtonType() -> ButtonType {
        buttonType
    }
    
    var isButtonHidden: Bool {
        buttonType == .none
    }
    
    // Key
    var key = ""
    
    // image
    var isActiveCheckImage = false
    
    // Line
    var isLineHidden = false
    var isActiveLineColor = false
    var fixedLineColor: StyleColor?
    var isActiveLineHeight = false
    
    var lineHeight: InputStatus<CGFloat> {
        if isActiveLineHeight {
            return InputStatus<CGFloat>( default: 1,
                                         start: 2,
                                         success: 2,
                                         fail: 2,
                                         setDefautWhenEnd: false)
        } else {
            return InputStatus<CGFloat>( with: 1,
                                         setDefautWhenEnd: false)
        }
    }
    
    var lineColor: InputStatus<StyleColor> {
        
        if let fixedLineColor = fixedLineColor {
            return InputStatus<StyleColor>( with: fixedLineColor,
                                            setDefautWhenEnd: false)
        }
        
        if isActiveLineColor {
            return InputStatus<StyleColor>( default: .gray_ECECEC,
                                            start: .green_24C875,
                                            success: .green_24C875,
                                            fail: .lipstickRed_DB1425,
                                            setDefautWhenEnd: false)
        } else {
            return InputStatus<StyleColor>( with: .gray_ECECEC,
                                            setDefautWhenEnd: false)
        }
    }
    
    // Right TextLabel
    var defaultRightText = ""
    var righttextLabelStyleFont: StyleFont?
    var righttextLabelStyleColor: StyleColor?
    var inputLimit: Int = 2048
    // Validation
    var validationIdentifiers: [String] = []
    var keypadSignedValue: AuthenticationAPIModel.KeypadSignedResponse?
    // Init
    init(type textType: ReactiveInputCell.TextType, style: Option...) {
        self.textType = textType
        super.init()
        style.forEach {
            switch $0 {
                
            case .none:
                break
                
            // TextField
            case .defaultText(let text):
                defaultText = text
            case .textField(let height):
                textFieldHeight = height
                
            case .textFieldMargin(let top):
                textFieldTopMargin = top
                
            case .textFieldColor(let color):
                textFieldStyleColor = color
                
            case .textFieldFont(let font):
                textFieldStyleFont = font
                
            case .textFieldNumberFont(let font):
                textFieldStyleNumberFont = font
                
            case .textFieldKern(let value):
                textFieldKern = value
                
            case .textFieldAttriburedString(let attributed):
                textFieldAttributedString = attributed
                
            case .textFieldMaxLength(let length):
                textFieldMaxLength = length
                
            case .allowTextInputEvent(let allow):
                allowTextInputEvent = allow
                
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

            case .placeholderColor(let color):
                placeholderColor = color
                
            // Button
            case .coverButton:
                isCoverButtonHidden = false
                
            case .searchClearButton:
                buttonType = .searchClear
            
            case .searchBigClearButton:
                buttonType = .searchBigClear
                
            case .removeAllButton:
                buttonType = .removeAll
                
            case .dropDownButton:
                buttonType = .arrowDown
                
            case .disclosureButton:
                buttonType = .arrowRight
                
            case .noneButton:
                buttonType = ReactiveInputCellModel.ButtonType.none
                 
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
             
            case .lineFixedColor(let color):
                fixedLineColor = color
                
            case .lineHeight(let isActive):
                isActiveLineHeight = isActive
                
            case .defaultRightText(let text):
                defaultRightText = text
                
            case .textRightLabelColor(let color):
                righttextLabelStyleColor = color
            case .textRightLabelFont(let font):
                righttextLabelStyleFont = font
            case .inputLimit(let value):
                inputLimit = value
            case .state(let state):
                self.state = state
            case .keyboardUp:
                keyboardShow = true
            case .keypadSignedValue(let value):
                self.keypadSignedValue = value
            }
        }
        
        //TODO: is needed anounce text validation?
//        bindTextValidState().disposed(by: disposeBag)
    }
    
    func bindTextValidState() -> Disposable {
        textValidStateSubject.subscribe(onNext: { [weak self] isValid in
            Logger.debug("bindTextValidState is Valid: \(isValid), self = \(self?.identifier ?? "none")")
            if isValid {
                self?.state = .valid
            } else {
                self?.state = .invalid
            }
        })
    }
}

extension ReactiveInputCellModel {
    
    enum Option {
        
        case none
        
        // TextField
        case defaultText(String)
        case textField(height: CGFloat)
        case textFieldMargin(top: CGFloat)
        case textFieldColor(style: StyleColor)
        case textFieldFont(style: StyleFont)
        case textFieldNumberFont(style: StyleNumberFont)
        case textFieldAttriburedString(attributeted: NSMutableAttributedString)
        case textFieldKern(value: CGFloat)
        case textFieldMaxLength(value: Int)
        case allowTextInputEvent(allow: InputStatus<Bool>)
        // Description & Error
        case description(text: String, show: InputStatus<Bool>)
        case errorMessage(text: String)
        
        // Placeholder
        case placeholder(text: String, showTop: ReactiveInputCell.ShowingTopPlaceholder)
        case placeholderColor(color: StyleColor)
        
        // Button
        case noneButton
        case coverButton
        case dropDownButton
        case disclosureButton
        case searchClearButton
        case searchBigClearButton
        case removeAllButton
        
        // Key
        case key(String)
        
        // Image
        case checkImage(isActive: Bool)
        
        // Line
        case line(hidden: Bool)
        case lineColor(isActive: Bool)
        case lineFixedColor(color: StyleColor)
        case lineHeight(isActive: Bool)
        
        // Right Label
        case defaultRightText(String)
        case textRightLabelColor(style: StyleColor)
        case textRightLabelFont(style: StyleFont)
        
        /// input limit
        case inputLimit(Int)
        
        /// Cell Status
        case state(State)
        
        /// keyboard up
        case keyboardUp
        
        /// Security Keypad init
        case keypadSignedValue(value: AuthenticationAPIModel.KeypadSignedResponse?)
    }
}

extension ReactiveInputCellModel {
    enum ButtonType {
        case arrowDown
        case arrowRight
        case none
        case searchClear
        case searchBigClear
        case removeAll
        
        var imageName: String {
            switch self {
            case .arrowDown:
                return "btnDropdownG01"
            case .arrowRight:
                return "arrowS"
            case .none:
                return ""
            case .searchClear:
                return "btnSearchClose"
            case .searchBigClear, .removeAll:
                return "btnSearchClose02"
            }
        }
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

