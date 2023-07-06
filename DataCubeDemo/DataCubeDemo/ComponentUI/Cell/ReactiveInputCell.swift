//
//  ReactiveInputCell.swift
//  TWBank
//
//  Created by Sunwoo.Kim on 20/05/2019.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension ReactiveInputCell {
    enum ShowingTopPlaceholder {
        case never
        case always
        case typed
    }
    
    enum TextType {
        case normal
        case password
        case secureKeypad
        case currency
        case number
        case secureNumber
        case disable
        case phoneNumber
        case disableMultline
        case currencyFixing
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            String(describing: lhs.self) == String(describing: rhs.self)
        }
    }
}

class ReactiveInputCell: BaseCell {
 
    @IBOutlet private weak var topPlaceHolderLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var textViewField: UITextView!
    @IBOutlet private weak var textFieldHeight: NSLayoutConstraint!
    @IBOutlet private weak var textFieldTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var checkImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var errorMessageLabel: UILabel!
    @IBOutlet private weak var lineView: UIView!
    @IBOutlet private weak var lineHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var coverButton: UIButton!
    @IBOutlet private weak var textRightLabel: UILabel!
    @IBOutlet private weak var linebottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var buttonRightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var buttonCenterConstraint: NSLayoutConstraint!
    
    private var isActiveCheckImage = false
    
    private(set) var state: ReactiveInputCellModel.State = .default
    private var textFont: StyleFont?
    private var textRightFont: StyleFont?
    private var textNumberFont: StyleNumberFont?
    private var allowTextInputEvent: InputStatus<Bool>?
    private var defaultTextObserver: Disposable?
    private var descriptionShow = InputStatus<Bool>(with: true,
                                                    setDefautWhenEnd: false)
    
    private var lineColor = InputStatus<StyleColor>( with: .gray_ECECEC,
                                                     setDefautWhenEnd: false)
    private var lineHeight = InputStatus<CGFloat>( with: 2,
                                                   setDefautWhenEnd: false)
    
    private var textType: TextType = .normal
    private(set) weak var model: ReactiveInputCellModel?
    
    var textFieldText: String {
        textField.text ?? ""
    }
    
    var buttonDriver: Driver<()> {
        button.rx.tap.takeUntil(rx.obsolete).asDriver(onErrorJustReturn: ())
    }
    
    var coverButtonDriver: Driver<()> {
        coverButton.rx.tap.takeUntil(rx.obsolete).asDriver(onErrorJustReturn: ())
    }
    
    func textFieldEvent(_ controlEvents: UIControl.Event = .allEvents) -> Observable<()> {
        textField.rx.controlEvent(controlEvents).takeUntil(rx.obsolete).asObservable()
    }
    
    func setDescriptionText(_ discription: String ) {
        descriptionLabel.text = discription
    }
    var descriptionText: String {
        descriptionLabel.text ?? ""
    }
    
    func buttonHide(bHide: Bool) {
        button.isHidden = bHide
    }
    
    func isShownButton(value: NumberConvertible?) {
        button.isHidden = value == nil
    }
    
    var textFieldEditing: Driver<()> {
        textField.rx.controlEvent(.editingDidBegin).takeUntil(rx.obsolete).asDriver(onErrorJustReturn: ())
    }
    
    var textFieldEditEnding: Driver<()> {
        textField.rx.controlEvent(.editingDidEnd).takeUntil(rx.obsolete).asDriver(onErrorJustReturn: ())
    }
    
    var textObserver: Observable<String> {
        let textObserver = textField.rx.controlEvent(.editingChanged)
            .map { [weak self] in
                self?.textField.text ?? ""
            }.takeUntil(rx.obsolete)
        
        if case .currency = textType {
            return textObserver.map { $0.digits.decimalCurrency }
        } else if case .currencyFixing = textType {
            return textObserver.map { $0.digits.decimalCurrencyFixing }
        } else {
            return textObserver
        }
        
    }
    
    var secureValueDriver: Driver<SecureEncryptedValue>? {
        secureQwertyKeypadProvider?.secureValuesNotificaiton().takeUntil(rx.obsolete).asDriver(onErrorJustReturn: .init())
    }
    
    var key: String = ""
    @available(*, deprecated, renamed: "key")
    var data: String {
        key
    }
    
    lazy var textFieldReference: UITextField = { textField }()
    var secureQwertyKeypadProvider: SecureKeypadProvider?
    override func configureWith(value: BaseCellModelProtocol) {
        guard let cellModel = value as? ReactiveInputCellModel else { return }
        model = cellModel
        key = cellModel.key
        descriptionLabel.text = cellModel.description
        descriptionShow = cellModel.descriptionShow
        allowTextInputEvent = cellModel.allowTextInputEvent
        
        if cellModel.keyboardShow {
            textField.becomeFirstResponder()
        }
        textField.delegate = self
        textFieldTopConstraint.constant = cellModel.textFieldTopMargin ?? 28
        textFieldHeight.constant = cellModel.textFieldHeight

        textField.lets {
            $0.textColor = cellModel.textFieldStyleColor?.apply
            $0.font = cellModel.textFieldStyleFont?.apply
            $0.text = cellModel.defaultText
            $0.defaultTextAttributes.updateValue(cellModel.textFieldKern ?? 0, forKey: NSAttributedString.Key.kern)
            $0.attributedText = cellModel.textFieldAttributedString ?? NSAttributedString(string: cellModel.defaultText)
        }
        
        textField.setLimitText(count: cellModel.inputLimit).disposed(by: disposeBag)
        textType = cellModel.textType
        setTextType(by: textType, model: cellModel)
        
        if textType == .currency || textType == .phoneNumber || textType == .currencyFixing {
            textField.showSystemToolBar()
        }
        
        textViewField.lets {
            $0.textColor = cellModel.textFieldStyleColor?.apply
            $0.text = cellModel.defaultText
        }

        textRightLabel.isHidden = cellModel.defaultRightText.isEmpty
        if !cellModel.defaultRightText.isEmpty {
            textRightLabel.lets {
                $0.text = cellModel.defaultRightText
                $0.textColor = cellModel.righttextLabelStyleColor?.apply
                $0.font = cellModel.righttextLabelStyleFont?.apply
            }
        }
        setTopPlaceholder(by: cellModel.placeholder, when: cellModel.showingTopPlaceholder)
        topPlaceHolderLabel.textColor = cellModel.placeholderColor.apply
        
        errorMessageLabel.text = cellModel.errorMessage
        coverButton.isHidden = cellModel.isCoverButtonHidden
        
        isActiveCheckImage = cellModel.isActiveCheckImage
        
        lineColor = cellModel.lineColor
        lineHeight = cellModel.lineHeight
        lineView.isHidden = cellModel.isLineHidden
        
        textFont = cellModel.textFieldStyleFont
        textNumberFont = cellModel.textFieldStyleNumberFont
        
        button.isHidden = cellModel.isButtonHidden
        
        if cellModel.buttonImageName.isNotEmpty {
            button.setImage(UIImage(named: cellModel.buttonImageName), for: .normal)
        }
        
        if let font = textNumberFont {
            textField.rx.value
                .orEmpty.takeUntil(rx.obsolete)
                .bind { [weak self] in
                    self?.textField.attributedText = $0.attributedCurrency(by: font)
                }.disposed(by: disposeBag)
        }
        
        defaultEvent()
        switch cellModel.state {
        case .valid:
            successEvent()
        case .invalid:
            failEvent()
        case .error(message: let errorMessage):
            failEvent(errorMessage)
        default: break
        }
        bindText()
        
        if cellModel.textFieldMaxLength > 0 {
            textField.setLimitText(count: cellModel.textFieldMaxLength).disposed(by: disposeBag)
        }
        
        switch cellModel.getButtonType() {
        case .searchClear, .searchBigClear:
            buttonHide(bHide: true)
            buttonRightConstraint.constant = 22
            buttonCenterConstraint.constant = 0
        case .removeAll:
            buttonHide(bHide: true)
            buttonRightConstraint.constant = 28
            buttonCenterConstraint.constant = 0
        case .arrowDown:
            buttonRightConstraint.constant = 17
            buttonCenterConstraint.constant = 0
        default:
            break

        }
        
        _ = textField.rx.controlEvent(.editingDidBegin).takeUntil(rx.obsolete).bind(onNext: startEvent)
        _ = textField.rx.controlEvent(.editingDidEnd).takeUntil(rx.obsolete).bind(onNext: endEvent)
    }
    
    private func bindText() {
        defaultTextObserver?.dispose()
        defaultTextObserver = textField.rx.value.orEmpty.takeUntil(rx.obsolete)
            .subscribe(onNext: { [weak self] in
                self?.model?.defaultText = $0
            })
        
        _ = secureQwertyKeypadProvider?.maskedValueNotificaiton()
            .filter({ $0.isNotEmpty }).takeUntil(rx.obsolete)
            .subscribe(onNext: {
                [weak self] in
                self?.model?.defaultText = $0
            })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        secureQwertyKeypadProvider?.deinitAllProperties()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textField.rx.controlEvent(.editingDidBegin).takeUntil(rx.obsolete).bind(onNext: startEvent).disposed(by: disposeBag)
        textField.rx.controlEvent(.editingDidEnd).takeUntil(rx.obsolete).bind(onNext: endEvent).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        secureQwertyKeypadProvider?.deinitAllProperties()
    }
}

extension ReactiveInputCell {
    private func bindText(_ cellModel: inout ReactiveInputCellModel) {
        defaultTextObserver?.dispose()
        defaultTextObserver = textField.rx.value.orEmpty.takeUntil(rx.obsolete)
            .subscribe(onNext: { [weak model = cellModel] in
                model?.defaultText = $0
            })
    }
}

extension ReactiveInputCell {
    
    func setTextType(by type: TextType, model: ReactiveInputCellModel) {
        textField.isEnabled = true
        switch type {
        case .currency:
            setCurrencyTextField()
        case .secureNumber:
            textField.keyboardType = .numberPad
            textField.isSecureTextEntry = true
        case .number:
            textField.keyboardType = .numberPad
        case .disable:
            textField.isEnabled = false
        case .disableMultline:
            textField.isEnabled = false
            textViewField.isEditable = false
            textViewField.isHidden = false
            linebottomConstraint.constant = 10
        case .normal:
            textField.isSecureTextEntry = false
            textField.keyboardType = .namePhonePad
        case .password:
            textField.isSecureTextEntry = true
        case .secureKeypad:
            textField.inputView = nil
            guard let configuration = model.keypadSignedValue else { return }
            secureQwertyKeypadProvider?.deinitAllProperties()
            secureQwertyKeypadProvider = .init(
                configure: configuration,
                maxLength: model.textFieldMaxLength.asInt32,
                textField: textField, canAutoFinish: true
            )
            secureQwertyKeypadProvider?.beginKeypadProcess()
        case .phoneNumber:
            setPhoneNumberTextField()
        case .currencyFixing:
            setCurrencyFinxingTextField()
        }
    }
    
    func setTextField(text: String) {
        textField.text = text
        textViewField.text = text
    }
    
    func setAttributeString(text: NSAttributedString) {
        textField.attributedText = text
    }
    
    func defaultEvent() {
        guard allowTextInputEvent?.default ?? false else { return }
        state = .default
        lineView.backgroundColor = lineColor.default.apply
        lineHeightConstraint.constant = lineHeight.default
        descriptionLabel.isHidden = !descriptionShow.default
        errorMessageLabel.isHidden = true
        checkImageView.isHidden = true
        layoutIfNeeded()
    }
    
    func startEvent() {
        guard allowTextInputEvent?.start ?? false else { return }
        lineView.backgroundColor = lineColor.start.apply
        lineHeightConstraint.constant = lineHeight.start
        descriptionLabel.isHidden = !descriptionShow.start
        errorMessageLabel.isHidden = true
        layoutIfNeeded()
    }
    
    func successEvent() {
        guard allowTextInputEvent?.success ?? false else { return }
        state = .valid
        lineView.backgroundColor = lineColor.success.apply
        lineHeightConstraint.constant = lineHeight.success
        descriptionLabel.isHidden = !descriptionShow.success
        errorMessageLabel.isHidden = true
        checkImageView.isHidden = !isActiveCheckImage
        layoutIfNeeded()
    }
    
    func failEvent(_ message: String? = nil) {
        guard allowTextInputEvent?.fail ?? false else { return }
        state = .invalid
        if let message = message {
            errorMessageLabel.text = message
        }
        lineView.backgroundColor = lineColor.fail.apply
        lineHeightConstraint.constant = lineHeight.fail
        descriptionLabel.isHidden = !descriptionShow.fail
        errorMessageLabel.isHidden = (errorMessageLabel.text ?? "").isEmpty
        if descriptionLabel.text == errorMessageLabel.text {
            descriptionLabel.isHidden = true
        }
        checkImageView.isHidden = true
        layoutIfNeeded()
    }

    func sendEvent(_ state: ReactiveInputCellModel.State) {
        switch state {
        case .default: defaultEvent()
        case .invalid: failEvent()
        case .valid: successEvent()
        case .error(message: let message): failEvent(message)
        }
    }
    
    func endEvent() {
        if lineColor.setDefautWhenEnd {
            lineView.backgroundColor = lineColor.default.apply
        }
        
        if descriptionShow.setDefautWhenEnd {
            descriptionLabel.isHidden = !descriptionShow.default
        }
        
        layoutIfNeeded()
    }
    
    func setVisiblePlaceHolder(_ visible: Bool) {
        topPlaceHolderLabel.isHidden = !visible
    }
}

private extension ReactiveInputCell {

    func setCurrencyTextField() {
        textField.keyboardType = .numberPad
        textField.rx.text.orEmpty
            .map { $0.digits.decimalCurrency }
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setPhoneNumberTextField() {
        textField.keyboardType = .numberPad
        textField.rx.text.orEmpty
            .map { PhoneNumberValidator().formattedNumber(number: $0) }
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setTopPlaceholder(by placeholder: String?, when showingType: ShowingTopPlaceholder) {
        
        topPlaceHolderLabel.text = placeholder
        textField.placeholder = placeholder
        topPlaceHolderLabel.isHidden = true
        
        if case .always = showingType {
            topPlaceHolderLabel.isHidden = false
            textField.placeholder = ""
        }
        
        textField.rx.text.orEmpty.bind { [weak self] in
            if case .typed = showingType {
                self?.textField.placeholder = $0.isEmpty ? placeholder : ""
                self?.topPlaceHolderLabel.isHidden = $0.isEmpty
                self?.layoutIfNeeded()
            }
        }.disposed(by: disposeBag)
        
        layoutIfNeeded()
    }
    
    func setCurrencyFinxingTextField() {
        textField.keyboardType = .numberPad
        textField.rx.text.orEmpty
            .map { $0.digits.decimalCurrencyFixing }
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base == ReactiveInputCell {
    var sendEvent: Binder<ReactiveInputCellModel.State> {
        Binder<ReactiveInputCellModel.State>(base) { cell, state in
            cell.sendEvent(state)
        }
    }
}
