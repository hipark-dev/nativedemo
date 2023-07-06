//
//  InputDoneWithButtonCell.swift
//  NFTTradePlatform
//
//  Created by Hyunil.Park on 2022/06/16.
//

import UIKit
import RxCocoa
import RxSwift

class InputDoneWithButtonCell: BaseCell {
    enum InputCellKey: String {
        case livingAddressDetail
        case companyName
        case companyAddressDetail
        case address
        case name
        static func checkSpecialSymbol(_ key: String) -> Bool {
            guard key != .empty else { return true }
            return [InputCellKey.livingAddressDetail,
                    InputCellKey.companyName,
                    InputCellKey.companyAddressDetail,
                    InputCellKey.address,
                    InputCellKey.name]
                    .map { $0.rawValue }
                    .contains(key)
        }
    }
    
    @IBOutlet private weak var inputTextField: UISFSTextField!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var lineView: UIView!
    @IBOutlet private weak var actionButton: UIButton!
    @IBOutlet private weak var buttonHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    weak private(set) var cellModel: InputDoneWithButtonCellModel?
    private var defaultTextObserver: Disposable?
    private var inputFieldType: InputFieldType = .normal
    var key: String = .empty
    
    lazy var changeTextFieldValueObservable: Observable<String?> = {
        inputTextField.rx.value.distinctUntilChanged().takeUntil(rx.obsolete).asObservable()
    }()
    
    lazy var editingBeginObservable: Observable<()> = {
        inputTextField.rx.controlEvent(.editingDidBegin).takeUntil(rx.obsolete).asObservable()
    }()
    
    lazy var editingEndObservable: Observable<()> = {
        inputTextField.rx.controlEvent(.editingDidEnd).takeUntil(rx.obsolete).asObservable()
    }()
    
    var actionButtonDriver: Driver<()> {
        actionButton.rx.tap.throttle().takeUntil(rx.obsolete).asDriver(onErrorJustReturn: ())
    }
    
    var textObserver: Observable<String> {
        let textObserver = inputTextField.rx.controlEvent(.editingChanged)
            .takeUntil(rx.obsolete)
            .map { [weak self] in
                self?.inputTextField.text ?? .empty
            }.asObservable()
        return textObserver
    }
    
    func textFieldEvent(_ controlEvents: UIControl.Event = .allEvents) -> Observable<String> {
        let observable = inputTextField.rx.controlEvent(controlEvents).takeUntil(rx.obsolete)
            .map { [weak self] in
                self?.inputTextField.text ?? .empty
            }.asObservable()
        return observable
    }

    override func bindStyles() {
        selectionStyle = .none
        
        subTitleLabel.lets {
            $0.textColor = StyleColor.gray_C1C1C1.apply
            $0.numberOfLines = 1
            $0.sizeToFit()
        }   
        
        actionButton.lets {
            $0.titleLabel?.textAlignment = .right
        }
    }
    
    override func configureWith(value: BaseCellModelProtocol) {
        guard let cellModel = value as? InputDoneWithButtonCellModel else { return }
        self.cellModel = cellModel
        inputTextField.delegate = self
        configureComponent()
        bindTextField()
        bindCellState()
        bindButtonState()
        setActionButtonImageIfNeeded(cellModel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        inputTextField.text = nil
        inputTextField.attributedText = nil
        subTitleLabel.text = nil
    }
}

extension InputDoneWithButtonCell {
 
    private func configureComponent() {
        guard let cellModel = self.cellModel else { return }
        
        key = cellModel.key
        setTextType(by: cellModel.textType)
        
        if [.sfs, .disabledSFS].contains(cellModel.textType) {
            inputTextField.applySFS(cellModel.defaultText, target: inputTextField)
        }
        
        inputTextField.font = cellModel.inputTextFont?.apply
        inputTextField.textColor = cellModel.inputTextColor?.apply
        inputTextField.placeholder = cellModel.placeholder
        inputTextField.isEnabled = cellModel.textFieldEnabled
        inputTextField.attributedText = cellModel.representAttributedText
        
        subTitleLabel.font = cellModel.subTitleFont?.apply
        subTitleLabel.text = cellModel.subTitle
        subTitleLabel.isHidden = cellModel.subTitleHiddenFlag
        
        lineView.backgroundColor = cellModel.lineColor.lineColor
        
        actionButton.isEnabled = cellModel.buttonEnabled
        actionButton.setTitle(cellModel.buttonTitle, for: .normal)
        actionButton.setTitleColor(cellModel.buttonTextColor?.apply, for: .normal)
        actionButton.titleLabel?.font = cellModel.buttonTitleFont.apply
        
        descriptionLabel.text = cellModel.description
        descriptionLabel.textColor = cellModel.descriptionColor
        descriptionLabel.font = cellModel.descriptionFont
        defaultTextFieldValidation(state: cellModel.state)
        
        if cellModel.textFieldMaxLength > .zero {
            inputTextField.setLimitText(count: cellModel.textFieldMaxLength).disposed(by: disposeBag)
        }
    }
    
    private func defaultTextFieldValidation(state: InputDoneWithButtonCellModel.State) {
        switch state {
        case .default:
            defaultEvent()
        case .valid:
            successEvent()
        case .invalid:
            failEvent()
        case .error(message: let errorMessage):
            failEvent(errorMessage)
        }
    }
}

extension InputDoneWithButtonCell {
    
    private func bindTextField() {
        guard let cellModel = self.cellModel else { return }
        _ = inputTextField.rx.value.distinctUntilChanged().takeUntil(rx.obsolete)
            .subscribe(onNext: { [weak self, weak cellModel = cellModel] in
                self?.subTitleLabel.isHidden = $0.unwrap().isEmpty
                cellModel?.defaultText = $0.unwrap()
            })
        _ = changeTextFieldValueObservable.bind(to: cellModel.changeValueObservable)
        _ = editingBeginObservable.bind(to: cellModel.editingBeginObservable)
        _ = editingEndObservable.bind(to: cellModel.editingEndObservable)
        _ = cellModel.setValueObservable.compactMap { $0 }.takeUntil(rx.obsolete)
            .observeOn(MainScheduler.instance).bind(to: inputTextField.rx.text)
    }
    
    private func bindCellState() {
        guard let cellModel = self.cellModel else { return }
        _ = cellModel.cellStateObservable.compactMap { $0 }
            .takeUntil(rx.obsolete)
            .observeOn(MainScheduler.instance).subscribe(
                onNext: { [weak self] in
                    self?.defaultTextFieldValidation(state: $0)
                }
            )
        
        _ = cellModel.descriptionObservable.compactMap { $0 }
            .takeUntil(rx.obsolete)
            .observeOn(MainScheduler.instance).bind(to: descriptionLabel.rx.text)
    }
    
    private func bindButtonState() {
        guard let cellModel = self.cellModel else { return }
        _ = cellModel.buttonStatusObservable.compactMap { $0 }
            .takeUntil(rx.obsolete)
            .observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] in
                self?.updateButtonStatus(state: $0)
            })
        
        _ = cellModel.buttonHiddenObservable.compactMap { $0 }.takeUntil(rx.obsolete)
            .observeOn(MainScheduler.instance).bind(to: actionButton.rx.isHidden)
    }
}

extension InputDoneWithButtonCell {
    func showSFSKeyboard() {
        guard inputFieldType == .sfs else { return }
        inputTextField.showSFSKeyboard()
    }
}

extension InputDoneWithButtonCell {
    func setTitleLabel(title: String) {
        actionButton.setTitle(title, for: .normal)
    }
}

extension InputDoneWithButtonCell {
    
    private func setTextType(by type: InputFieldType) {
        inputFieldType = type
        inputTextField.isSecureTextEntry = false
        switch type {
        case .currency:
            setCurrencyTextField()
        case .secureNumber:
            inputTextField.keyboardType = .numberPad
            inputTextField.isSecureTextEntry = true
        case .number:
            inputTextField.keyboardType = .numberPad
            let keyboardToolbar = UIToolbar()
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
            keyboardToolbar.items = [ UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil), doneButton ]
            keyboardToolbar.sizeToFit()
            inputTextField.inputAccessoryView = keyboardToolbar
        case .disable:
            inputTextField.isEnabled = false
        case .normal:
            inputTextField.isEnabled = true
        case .email:
            inputTextField.keyboardType = .emailAddress
        case .password:
            inputTextField.isSecureTextEntry = true
        case .phoneNumber:
            setPhoneNumberTextField()
        default: break
        }
    }

    func setActionButtonImageIfNeeded(_ moddel: InputDoneWithButtonCellModel) {
        guard moddel.imageName.isEmpty == false else { return }
        actionButton.lets {
            $0.setImage(UIImage(named: moddel.imageName), for: .normal)
            $0.setTitle(nil, for: .normal)
        }
    }
    
    private func setCurrencyTextField() {
        inputTextField.keyboardType = .numberPad
        inputTextField.rx.text.orEmpty
            .map { $0.digits.decimalCurrency }
            .bind(to: inputTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setPhoneNumberTextField() {
        inputTextField.keyboardType = .numberPad
        inputTextField.rx.text.orEmpty
            .map { PhoneNumberValidator().formattedNumber(number: $0) }
            .bind(to: inputTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func defaultEvent() {
        lineView.backgroundColor = StyleColor.gray_ECECEC.apply
        descriptionLabel.isHidden = true
        if cellModel?.descriptionHiddenFlag == false {
            descriptionLabel.isHidden = false
        }
        layoutIfNeeded()
    }
    
    private func successEvent() {
        lineView.backgroundColor = StyleColor.green_24C875.apply
        descriptionLabel.isHidden = true
        if cellModel?.descriptionHiddenFlag == false {
            descriptionLabel.isHidden = false
        }
        layoutIfNeeded()
    }
    
    private func failEvent(_ message: String? = nil) {
        if let message = message {
            descriptionLabel.text = message
            descriptionLabel.textColor = StyleColor.red_FF0008.apply
        }
        lineView.backgroundColor = StyleColor.red_FF0008.apply
        descriptionLabel.isHidden = false
        layoutIfNeeded()
    }
    
    private func updateButtonStatus(state: (title: String, color: StyleColor)) {
        actionButton.setTitle(state.title, for: .normal)
        actionButton.setTitleColor(state.color.apply, for: .normal)
        actionButton.isEnabled = cellModel?.buttonEnabled ?? true
        layoutIfNeeded()
    }
    
    @objc private func donePressed() {
        inputTextField.resignFirstResponder()
    }
}

extension InputDoneWithButtonCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length > .zero && string.isEmpty { return true }
        if InputCellKey.checkSpecialSymbol(key) {
            return string.hasRestrictSymbolInputRule()
        }
        return true
    }
}
