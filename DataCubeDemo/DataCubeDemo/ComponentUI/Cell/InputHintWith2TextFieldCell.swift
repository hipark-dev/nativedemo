//
//  InputHintWith2TextFieldCell.swift
//  NFTTradePlatform
//
//  Created by Hyunil.Park on 2022/06/16.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class InputHintWith2TextFieldCell: BaseCell {
    
    @IBOutlet private weak var inputField1: UITextField!
    @IBOutlet private weak var inputField2: UITextField!
    @IBOutlet private weak var lineView1: UIView!
    @IBOutlet private weak var lineView2: UIView!
    @IBOutlet private weak var clearTextField1Button: UIButton!
    @IBOutlet private weak var clearTextField2Button: UIButton!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    private(set) weak var cellModel: InputHintWith2TextFieldCellModel?
    
    private var defaultTextObserver1: Disposable?
    private var defaultTextObserver2: Disposable?
    var cellKey: String = .empty
    
    lazy var textField1ValueObservable: Observable<String?> = {
        inputField1.rx.value.distinctUntilChanged().asObservable()
    }()
    
    lazy var textField2ValueObservable: Observable<String?> = {
        inputField2.rx.value.distinctUntilChanged().asObservable()
    }()
    
    var clearTextField1ButtonDriver: Driver<()> {
        clearTextField1Button.rx.tap.throttle().takeUntil(rx.obsolete).asDriver(onErrorJustReturn: ())
    }
    
    var clearTextField2ButtonDriver: Driver<()> {
        clearTextField2Button.rx.tap.throttle().takeUntil(rx.obsolete).asDriver(onErrorJustReturn: ())
    }
    
    func textField1Event(_ controlEvents: UIControl.Event = .allEvents) -> Observable<String> {
        if controlEvents == .editingDidEnd { lineView1.backgroundColor = StyleColor.gray_ECECEC.apply }
        return inputField1.rx.controlEvent(controlEvents).takeUntil(rx.obsolete)
            .map { [weak self] in
                self?.inputField1.text ?? .empty
            }.asObservable()
    }
    
    func textField2Event(_ controlEvents: UIControl.Event = .allEvents) -> Observable<String> {
        if controlEvents == .editingDidEnd { lineView2.backgroundColor = StyleColor.gray_ECECEC.apply }
        return inputField2.rx.controlEvent(controlEvents).takeUntil(rx.obsolete)
            .map { [weak self] in
                self?.inputField2.text ?? .empty
            }.asObservable()
    }
    
    override func bindStyles() {
        selectionStyle = .none
        inputField1.lets {
            $0.font = StyleFont.subtitle2(weight: .regular).apply
            $0.textColor = StyleColor.black_222222.apply
        }
        inputField2.lets {
            $0.font = StyleFont.subtitle2(weight: .regular).apply
            $0.textColor = StyleColor.black_222222.apply
        }
        
        subTitleLabel.lets {
            $0.font = StyleFont.body6(weight: .regular).apply
            $0.textColor = StyleColor.gray_C1C1C1.apply
        }
        
        lineView1.lets {
            $0.backgroundColor = StyleColor.gray_ECECEC.apply
        }
        
        lineView2.lets {
            $0.backgroundColor = StyleColor.gray_ECECEC.apply
        }
        
        descriptionLabel.lets {
            $0.font = StyleFont.body5.apply
            $0.textColor = StyleColor.gray_97999E.apply
        }
        
        clearTextField1Button.lets {
            $0.isHidden = true
        }
        
        clearTextField2Button.lets {
            $0.isHidden = true
        }
    }
    
    override func configureWith(value: BaseCellModelProtocol) {
        guard let cellModel = value as? InputHintWith2TextFieldCellModel else { return }
        self.cellModel = cellModel
        configureComponent()
        bindTextField()
        
        var copyCellModel = cellModel
        bindText(&copyCellModel)
    }
    
    func bindText(_ cellModel: inout InputHintWith2TextFieldCellModel) {
        defaultTextObserver1?.dispose()
        defaultTextObserver1 = inputField1.rx.value.changed.distinctUntilChanged()
            .compactMap { $0 }.takeUntil(rx.obsolete)
            .subscribe(
                onNext: { [weak model = cellModel] in
                    model?.defaultText1 = $0
                }
            )
        defaultTextObserver2?.dispose()
        defaultTextObserver2 = inputField2.rx.value.changed.distinctUntilChanged()
            .compactMap { $0 }.takeUntil(rx.obsolete)
            .subscribe(
                onNext: { [weak model = cellModel] in
                    model?.defaultText2 = $0
                }
            )
    }
}

extension InputHintWith2TextFieldCell {
    private func configureComponent() {
        guard let cellModel = self.cellModel else { return }
        inputField1.delegate = self
        inputField2.delegate = self
        cellKey = cellModel.identifier
        subTitleLabel.isHidden = cellModel.defaultText1.isEmpty && cellModel.defaultText2.isEmpty
        subTitleLabel.text = cellModel.title
        inputField1.placeholder = cellModel.placeHolder1
        inputField2.placeholder = cellModel.placeHolder2
        inputField1.text = cellModel.defaultText1
        inputField2.text = cellModel.defaultText2
        
        inputField1.isEnabled = cellModel.isEnabled
        inputField2.isEnabled = cellModel.isEnabled
        descriptionLabel.text = cellModel.description
        
        inputField1.keyboardType = .alphabet
        inputField2.keyboardType = .alphabet
        
        clearTextField1ButtonDriver.drive(onNext: { [weak self] in
            guard let self = self else { return }
            cellModel.defaultText1 = .empty
            self.inputField1.text = .empty
            self.clearTextField1Button.isHidden = true
        }).disposed(by: disposeBag)
        
        clearTextField2ButtonDriver.drive(onNext: { [weak self] in
            guard let self = self else { return }
            cellModel.defaultText2 = .empty
            self.inputField2.text = .empty
            self.clearTextField2Button.isHidden = true
        }).disposed(by: disposeBag)
        
        if cellModel.textFieldMaxLength > .zero {
            inputField1.setLimitText(count: cellModel.textFieldMaxLength).disposed(by: disposeBag)
            inputField2.setLimitText(count: cellModel.textFieldMaxLength).disposed(by: disposeBag)
        }
    }
    
    fileprivate func bindTextField() {
        guard let cellModel = self.cellModel else { return }
        
        _ = textField1ValueObservable.bind(to: cellModel.input1Observable)
        _ = textField2ValueObservable.bind(to: cellModel.input2Observable)
        _ = inputField1.rx.value.distinctUntilChanged().takeUntil(rx.obsolete)
            .subscribe(onNext: {
                cellModel.defaultText1 = $0.unwrap()
            })
        _ = inputField2.rx.value.distinctUntilChanged().takeUntil(rx.obsolete)
            .subscribe(onNext: {
                cellModel.defaultText2 = $0.unwrap()
            })
        
        inputField1.rx.controlEvent(.editingDidBegin).observeOn(MainScheduler.instance).subscribe(
            onNext: { [weak self] in
                self?.descriptionLabel.isHidden = false
                self?.subTitleLabel.isHidden = false
                self?.lineView1.backgroundColor = StyleColor.green_24C875.apply
                self?.clearTextField1Button.isHidden = self?.inputField1.text.unwrap().isEmpty == true
            }
        ).disposed(by: disposeBag)
        
        inputField2.rx.controlEvent(.editingDidBegin).observeOn(MainScheduler.instance).subscribe(
            onNext: { [weak self] in
                self?.descriptionLabel.isHidden = false
                self?.subTitleLabel.isHidden = false
                self?.lineView2.backgroundColor = StyleColor.green_24C875.apply
                self?.clearTextField2Button.isHidden = self?.inputField2.text.unwrap().isEmpty == true
            }
        ).disposed(by: disposeBag)
        
        inputField1.rx.controlEvent(.editingDidEnd).observeOn(MainScheduler.instance).subscribe(
            onNext: { [weak self] in
                self?.descriptionLabel.isHidden = true
                self?.lineView1.backgroundColor = StyleColor.gray_ECECEC.apply
                self?.clearTextField1Button.isHidden = true
            }
        ).disposed(by: disposeBag)
        
        inputField2.rx.controlEvent(.editingDidEnd).observeOn(MainScheduler.instance).subscribe(
            onNext: { [weak self] in
                self?.descriptionLabel.isHidden = true
                self?.lineView2.backgroundColor = StyleColor.gray_ECECEC.apply
                self?.clearTextField2Button.isHidden = true
            }
        ).disposed(by: disposeBag)
        
        inputField1.rx.controlEvent(.editingChanged).observeOn(MainScheduler.instance)
            .compactMap { self.inputField1.text?.isEmpty }
            .bind(to: clearTextField1Button.rx.isHidden).disposed(by: disposeBag)
            
        inputField2.rx.controlEvent(.editingChanged).observeOn(MainScheduler.instance)
            .compactMap { self.inputField2.text?.isEmpty }
            .bind(to: clearTextField2Button.rx.isHidden).disposed(by: disposeBag)
    }
}

extension InputHintWith2TextFieldCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return textField.resignFirstResponder()
    }
}
