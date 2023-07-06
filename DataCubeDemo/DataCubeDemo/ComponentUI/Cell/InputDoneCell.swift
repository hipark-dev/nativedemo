//
//  InputDoneCell.swift
//  NFTTradePlatform
//
//  Created by Hyunil.Park on 2022/06/16.
//

import UIKit
import RxCocoa
import RxSwift

class InputDoneCell: BaseCell {

    @IBOutlet private weak var inputTextField: UITextField!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var lineView: UIView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var inputDoneButton: UIButton!
    
    private var textType: InputFieldType = .normal
    private var defaultTextObserver: Disposable?
    private(set) weak var cellModel: InputDoneCellModel?
    var key: String = .empty
    
    lazy var changeTextFieldValudObservable: Observable<String?> = {
        inputTextField.rx.value.distinctUntilChanged().takeUntil(rx.obsolete).asObservable()
    }()
    
    lazy var editingBeginObservable: Observable<()> = {
        inputTextField.rx.controlEvent(.editingDidBegin).takeUntil(rx.obsolete).asObservable()
    }()
    
    lazy var editingEndObservable: Observable<()> = {
        inputTextField.rx.controlEvent(.editingDidEnd).takeUntil(rx.obsolete).asObservable()
    }()
    
    var inputDoneButtonDriver: Driver<()> {
        inputDoneButton.rx.tap.takeUntil(rx.obsolete).asDriver(onErrorJustReturn: ())
    }
    
    var textObserver: Observable<String> {
        let textObserver = inputTextField.rx.controlEvent(.editingChanged).takeUntil(rx.obsolete)
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
        
        lineView.lets {
            $0.backgroundColor = StyleColor.gray_ECECEC.apply
        }
        
        descriptionLabel.lets {
            $0.font = StyleFont.body5.apply
            $0.textColor = StyleColor.gray_97999E.apply
        }
    }
    
    override func configureWith(value: BaseCellModelProtocol) {
        guard let cellModel = value as? InputDoneCellModel else { return }
        self.cellModel = cellModel
        configureComponent(cellModel)
        bindTextField(cellModel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        inputTextField.text = nil
        subTitleLabel.text = nil
        inputTextField.keyboardType = .default
    }
}

extension InputDoneCell {
    private func configureComponent(_ cellModel: InputDoneCellModel) {
        
        textType = cellModel.textType
        setTextType(by: textType)
        inputTextField.delegate = self
        key = cellModel.key
        inputTextField.font = cellModel.textFieldFont?.apply
        inputTextField.textColor = StyleColor.black_222222.apply
        inputTextField.placeholder = cellModel.placeholder
        subTitleLabel.text = cellModel.subTitle
        subTitleLabel.font = cellModel.subTitleFont?.apply
        subTitleLabel.isHidden = !(cellModel.defaultText.count > .zero)
        descriptionLabel.text = cellModel.description
        inputTextField.isEnabled = cellModel.isEnabled
        inputDoneButton.isHidden = cellModel.inputDoneButtonHidden
        if textType == .currency {
            inputTextField.showSystemToolBar()
            if cellModel.defaultText.isNotEmpty {
                inputTextField.text = cellModel.defaultText.digits.decimalCurrency
            }
        } else {
            inputTextField.text = cellModel.defaultText
        }
        
        if cellModel.isTitleFieldFocus {
            inputTextField.becomeFirstResponder()
        }
        
        if cellModel.textFieldMaxLength > .zero {
            inputTextField.setLimitText(count: cellModel.textFieldMaxLength).disposed(by: disposeBag)
        }
    }
    
    private func bindTextField(_ cellModel: InputDoneCellModel) {
        
        _ = inputTextField.rx.value.distinctUntilChanged().takeUntil(rx.obsolete)
            .subscribe(onNext: { [weak self] in
                self?.cellModel?.defaultText = $0.unwrap()
            })
        _ = changeTextFieldValudObservable.bind(to: cellModel.changeValueObservable)
        _ = editingBeginObservable.bind(to: cellModel.editingBeginObservable)
        _ = editingEndObservable.bind(to: cellModel.editingEndObservable)
        
        textObserver.subscribe(
            onNext: { [weak self] text in
                self?.subTitleLabel.isHidden = !(text.count > .zero)
            }
        ).disposed(by: disposeBag)
        
        inputTextField.rx.controlEvent(.editingDidBegin).subscribe(
            onNext: { [weak self] in
                self?.descriptionLabel.isHidden = false
            }
        ).disposed(by: disposeBag)
        
        inputTextField.rx.controlEvent(.editingDidEnd).subscribe(
            onNext: { [weak self] in
                self?.descriptionLabel.isHidden = true
            }
        ).disposed(by: disposeBag)
        
    }
}

extension InputDoneCell {
    
    private func setTextType(by type: InputFieldType) {
        inputTextField.isSecureTextEntry = false
        switch type {    
        case .currency:
            setCurrencyTextField()
        case .secureNumber:
            inputTextField.keyboardType = .numberPad
            inputTextField.isSecureTextEntry = true
        case .number:
            inputTextField.keyboardType = .numberPad
        case .disable:
            inputTextField.isEnabled = false
        case .normal:
            inputTextField.isEnabled = true
            inputTextField.keyboardType = .namePhonePad
        case .allowChinese:
            inputTextField.isEnabled = true
        case .password:
            inputTextField.isSecureTextEntry = true
        case .phoneNumber:
            setPhoneNumberTextField()
        default: break
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return textField.resignFirstResponder()
    }
}
