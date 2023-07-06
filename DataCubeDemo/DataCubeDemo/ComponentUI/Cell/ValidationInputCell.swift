//
//  ValidationInputCell.swift
//  TWBank
//
//  Created by Hyunil.Park on 03/03/2020.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ValidationInputCell: BaseCell {
 
    @IBOutlet private weak var topPlaceHolderLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var textFieldHeight: NSLayoutConstraint!
    @IBOutlet private weak var textFieldTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var checkImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var errorMessageLabel: UILabel!
    @IBOutlet private weak var lineView: UIView!
    @IBOutlet private weak var lineHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var linebottomConstraint: NSLayoutConstraint!
    
    private var textFont: StyleFont = StyleFont.subtitle2(weight: .regular)
    private var activeTextFieldFont: StyleFont?
    private var descriptionShow = InputStatus<Bool>(with: true,
                                                    setDefautWhenEnd: false)
    
    private var lineColor = InputStatus<StyleColor>( with: .gray_ECECEC,
                                                     setDefautWhenEnd: false)
    private var lineHeight = InputStatus<CGFloat>( with: 1,
                                                   setDefautWhenEnd: false)
    
    private var textType: TextType = .normal
    private(set) weak var cellModel: ValidationInputCellModel?
    var key: String = .empty
    
    lazy var changeTextFieldValueObservable: Observable<String?> = {
        textField.rx.value.distinctUntilChanged().take(until: rx.obsolete).asObservable()
    }()
    
    lazy var editingBeginObservable: Observable<()> = {
        textField.rx.controlEvent(.editingDidBegin).take(until: rx.obsolete).asObservable()
    }()
    
    lazy var editingEndObservable: Observable<()> = {
        textField.rx.controlEvent(.editingDidEnd).take(until: rx.obsolete).asObservable()
    }()
    
    func textFieldEvent(_ controlEvents: UIControl.Event = .allEvents) -> Observable<()> {
        textField.rx.controlEvent(controlEvents).take(until: rx.obsolete).asObservable()
    }
    
    var textFieldText: String {
        textField.text ?? ""
    }
    
    var textObserver: Observable<String> {
        let textObserver = textField.rx.controlEvent(.editingChanged)
            .map { [weak self] in
                self?.textField.text ?? ""
            }.take(until: rx.obsolete)
        
        if case .currency = textType {
            return textObserver.map { $0.digits.decimalCurrency }
        } else {
            return textObserver
        }
    }
    
    override func bindStyles() {
        selectionStyle = .none
    }
    
    override func configureWith(value: BaseCellModelProtocol) {
        guard let cellModel = value as? ValidationInputCellModel else { return }
        self.cellModel = cellModel
        configureComponent()
        bindTextField()
        bindCellState()
        bindTextFieldInputValue()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textField.text = nil
        textField.attributedText = nil

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

extension ValidationInputCell {
    
    private func configureComponent() {
        guard let cellModel = self.cellModel else { return }
        
        key = cellModel.key
        textField.lets {
            $0.textColor = cellModel.textFieldStyleColor?.apply
            $0.font = cellModel.textFieldStyleFont.apply
            $0.text = cellModel.defaultText
            $0.defaultTextAttributes.updateValue(cellModel.textFieldKern ?? .zero, forKey: NSAttributedString.Key.kern)
        }
        textField.attributedText = cellModel.representAttributeText
        descriptionLabel.text = cellModel.description
        descriptionShow = cellModel.descriptionShow
        
        setTextType()
        
        if textType == .currency || textType == .phoneNumber {
            textField.showSystemToolBar()
        }
        
        if let font = cellModel.activeTextFieldFont {
            activeTextFieldFont = font
        }
        
        setTopPlaceholder(by: cellModel.placeholder, when: cellModel.showingTopPlaceholder)
        errorMessageLabel.text = cellModel.errorMessage
        lineColor = cellModel.lineColor
        lineHeight = cellModel.lineHeight
        lineView.isHidden = cellModel.isLineHidden
        textFont = cellModel.textFieldStyleFont
        
        if cellModel.textFieldMaxLength > Int.zero {
            textField.setLimitText(count: cellModel.textFieldMaxLength).disposed(by: disposeBag)
        }
        defaultTextFieldValidation(state: cellModel.state)
    }
    
    private func defaultTextFieldValidation(state: ValidationInputCellModel.State) {
        switch state {
        case .valid:
            successEvent()
        case .invalid:
            failEvent()
        case .error(message: let errorMessage):
            failEvent(errorMessage)
        case .validDefault:
            validDefaultEvent()
        case .start:
            startEvent()
        default:
            defaultEvent()
        }
    }
}

extension ValidationInputCell {
    
    fileprivate func bindTextField() {
        guard let model = cellModel else { return }
        
        _ = textField.rx.value.distinctUntilChanged().take(until: rx.obsolete)
            .subscribe(onNext: { [weak cellModel = model] in
                cellModel?.defaultText = $0.unwrap()
            })
        _ = editingBeginObservable.bind(to: model.editingBeginObservable)
        _ = editingEndObservable.bind(to: model.editingEndObservable)
        _ = textFieldEvent(.editingDidBegin).observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in self?.activeTextFieldScale(.begin) })
        _ = textFieldEvent(.editingDidEnd).take(until: rx.obsolete).observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in self?.activeTextFieldScale(.end) })
        _ = changeTextFieldValueObservable.bind(to: model.inputObservable)
    }
    
    fileprivate func bindCellState() {
        guard let model = cellModel else { return }
        _ = model.cellStateObservable.compactMap { $0 }
            .take(until: rx.obsolete)
            .observe(on: MainScheduler.instance).subscribe(
                onNext: { [weak self] in
                    self?.defaultTextFieldValidation(state: $0)
                }
            )
    }
    
    fileprivate func bindTextFieldInputValue() {
        guard let model = cellModel else { return }
        _ = model.setValueObservable.compactMap { $0 }
            .take(until: rx.obsolete)
            .observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] in
                self?.textField.text = $0
            })
    }
}

extension ValidationInputCell {
    
    enum ScaleOption {
        case begin
        case end
    }
    
    fileprivate func activeTextFieldScale(_ option: ScaleOption) {
        switch option {
        case .begin:
            descriptionLabel.isHidden = false
            if let font = activeTextFieldFont {
                textField.font = font.apply
                lineHeightConstraint.constant = lineHeight.default * 2
            }
        case .end:
            if activeTextFieldFont != nil {
                textField.font = textFont.apply
                lineHeightConstraint.constant = lineHeight.default
            }
        }
        layoutIfNeeded()
    }
    
    fileprivate func setTextType() {
        guard let model = cellModel else { return }
        textType = model.textType
        textField.isEnabled = true
        switch textType {
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
            linebottomConstraint.constant = 10
        case .normal:
            textField.keyboardType = .namePhonePad
        case .email:
            textField.keyboardType = .emailAddress
        case .password:
            textField.isSecureTextEntry = true
        case .phoneNumber:
            setPhoneNumberTextField()
        }
    }
    
    private func validDefaultEvent() {
        lineView.backgroundColor = lineColor.default.apply
        lineHeightConstraint.constant = lineHeight.default
        descriptionLabel.isHidden = true
        errorMessageLabel.isHidden = true
        checkImageView.isHidden = false
        layoutIfNeeded()
    }
    
    func defaultEvent() {
        lineView.backgroundColor = lineColor.default.apply
        lineHeightConstraint.constant = lineHeight.default
        descriptionLabel.isHidden = !descriptionShow.default
        errorMessageLabel.isHidden = true
        checkImageView.isHidden = true
        layoutIfNeeded()
    }
    
    func startEvent() {
        lineView.backgroundColor = lineColor.start.apply
        descriptionLabel.isHidden = !descriptionShow.start
        errorMessageLabel.isHidden = true
        checkImageView.isHidden = true
        layoutIfNeeded()
    }
    
    func successEvent() {
        lineView.backgroundColor = lineColor.success.apply
        lineHeightConstraint.constant = lineHeight.success
        descriptionLabel.isHidden = !descriptionShow.success
        errorMessageLabel.isHidden = true
        checkImageView.isHidden = false
        layoutIfNeeded()
    }
    
    func failEvent(_ message: String? = nil) {
        if let message = message {
            errorMessageLabel.text = message
        }
        lineView.backgroundColor = lineColor.fail.apply
        descriptionLabel.isHidden = !descriptionShow.fail
        errorMessageLabel.isHidden = errorMessageLabel.text?.isEmpty == true
        if descriptionLabel.text == errorMessageLabel.text {
            descriptionLabel.isHidden = true
        }
        checkImageView.isHidden = true
        layoutIfNeeded()
    }
}

private extension ValidationInputCell {

    private func setCurrencyTextField() {
        textField.keyboardType = .numberPad
        textField.rx.text.orEmpty
            .map { $0.digits.decimalCurrency }
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setPhoneNumberTextField() {
        textField.keyboardType = .numberPad
        textField.rx.text.orEmpty
            .map { PhoneNumberValidator().formattedNumber(number: $0) }
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setTopPlaceholder(by placeholder: String?, when showingType: ShowingTopPlaceholder) {
        
        topPlaceHolderLabel.text = placeholder
        textField.placeholder = placeholder
        topPlaceHolderLabel.isHidden = true
        
        if case .always = showingType {
            topPlaceHolderLabel.isHidden = false
            textField.placeholder = .empty
        }
        
        textField.rx.text.orEmpty.bind { [weak self] in
            if case .typed = showingType {
                self?.textField.placeholder = $0.isEmpty ? placeholder : .empty
                self?.topPlaceHolderLabel.isHidden = $0.isEmpty
                self?.layoutIfNeeded()
            }
        }.disposed(by: disposeBag)
        
        layoutIfNeeded()
    }
}

extension ValidationInputCell {
    enum ShowingTopPlaceholder {
        case never
        case always
        case typed
    }
    
    enum TextType {
        case normal
        case password
        case currency
        case number
        case secureNumber
        case disable
        case phoneNumber
        case disableMultline
        case email
        static func == (lhs: Self, rhs: Self) -> Bool {
            String(describing: lhs.self) == String(describing: rhs.self)
        }
    }
}
