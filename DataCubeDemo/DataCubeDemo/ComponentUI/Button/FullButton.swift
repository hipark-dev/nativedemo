//
//  FullButton.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import Foundation
import UIKit
import BonMot
import RxSwift
import RxCocoa
import SnapKit

enum ButtonState {
    case disable
    case grayable
    case enable
    case graydisable
    
    var buttonState: Bool {
        switch self {
        case .enable, .grayable:
            return true
        case .disable, .graydisable:
            return false
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .enable:
            return StyleColor.green_00B8C5.apply
        case .grayable:
            return StyleColor.paleGreyFour.apply
        case .disable:
            return StyleColor.paleLilac_E3E5EC.apply
        case .graydisable:
            return StyleColor.paleGreyFour.apply
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .enable, .disable:
            return StyleColor.white_FFFFFF.apply
        case .grayable:
            return StyleColor.gray_74767D.apply
        case .graydisable:
            return StyleColor.gray_D0D0D5.apply
        }
    }
}

class FullButton: UIView {
    enum Constant {
        static let height: CGFloat = 56
    }
    
    @IBOutlet private var button: UIButton!
    weak var bottomConstraint: Constraint?
    
    lazy var titleStyle = {
        StringStyle(
            .font(StyleFont.body1(weight: StyleFont.FontWeight.bold).apply),
            .color(ButtonState.enable.textColor)
        )
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initNib()
    }
    
    public var tapButton: ((ControlEvent<Void>) -> Void)?
    
    private func initNib() {
        let nibView = loadNib()
        nibView.frame = bounds
        addSubview(nibView)
    }
    
    func configureButton(_ state: ButtonState,
                         _ labelText: String,
                         cornerRadius: CGFloat = 0,
                         _ tapEvent: (ControlEvent<Void>) -> Void) {
        titleStyle.color = state.textColor
        let attributedTitle = labelText.styled(with: titleStyle)
        button.lets {
            $0.setAttributedTitle(attributedTitle, for: UIControl.State.normal)
            $0.isEnabled = state.buttonState
            $0.backgroundColor = state.backgroundColor
            $0.superview?.backgroundColor = state.backgroundColor
            $0.layer.cornerRadius = cornerRadius
            ControlEvent<Void>(events: $0.rx.tap.throttle(.seconds(UIConstant.fullbuttonThrottleTime)))
                .bind(to: tapEvent)
        }
    }
    
    func configureButton(_ state: ButtonState, title: String) {
        let attributedTitle =
            title.styled(
                with: StringStyle(
                    .font(StyleFont.body1(weight: StyleFont.FontWeight.bold).apply),
                    .color(state.textColor)))
        button.lets {
            $0.setAttributedTitle(attributedTitle, for: UIControl.State.normal)
            $0.isEnabled = state.buttonState
            $0.backgroundColor = state.backgroundColor
            $0.superview?.backgroundColor = state.backgroundColor
        }
    }
    
    func configuredButton(_ state: ButtonState, title: String) -> Observable<Void> {
        configureButton(state, title: title)
        button.bindStyles()
        return button.rx.tap.throttle()
    }
    
    func bindTap(_ event: (ControlEvent<Void>) -> Void) {
        button.rx.tap.bind(to: event)
    }
    
    func tapEvent() -> Observable<Void> {
        button.rx.tap.take(until: rx.deallocated).throttle()
    }
    
    func changeButtonText( _ labelText: String ) {
        let attributedTitle = labelText.styled(with:
            StringStyle(.font(StyleFont.body1(weight: StyleFont.FontWeight.bold).apply), .color(.white))
        )
        
        button.lets {
            $0.setAttributedTitle(attributedTitle, for: UIControl.State.normal)
        }
    }
    
    func changeButtonText( _ state: ButtonState, _ labelText: String ) {
        
        let attributedTitle = labelText.styled(with:
            StringStyle(.font(StyleFont.body1(weight: StyleFont.FontWeight.bold).apply), .color(state.textColor))
        )
        
        button.lets {
            $0.setAttributedTitle(attributedTitle, for: UIControl.State.normal)
            $0.isEnabled = state.buttonState
            $0.backgroundColor = state.backgroundColor
            $0.superview?.backgroundColor = state.backgroundColor
        }
    }
    
    func changeButtonStatus(_ state: ButtonState) {
        button.lets {
            $0.isEnabled = state.buttonState
            $0.backgroundColor = state.backgroundColor
            $0.superview?.backgroundColor = state.backgroundColor
        }
    }
    
    func changeButton(state: ButtonState = .enable, color: UIColor = .clear) {
        button.lets {
            $0.isEnabled = state.buttonState
            $0.backgroundColor = color
            $0.superview?.backgroundColor = color
        }
    }
    
    func changeColor(background: UIColor, text: UIColor) {
        button.lets {
            $0.setTitleColor(text, for: .normal)
            $0.setAttributedTitle(
                $0.currentAttributedTitle?.styled(with: titleStyle, .color(text)),
                for: UIControl.State.normal
            )
            $0.backgroundColor = background
            $0.superview?.backgroundColor = background
        }
    }
    
    func setHidden(isHidden: Bool) {
        button.lets {
            $0.isHidden = isHidden
            $0.superview?.isHidden = isHidden
        }
    }
    
    internal func buttonRefference() -> UIButton {
        button
    }
}

extension Reactive where Base == FullButton {
    var isEnabled: Binder<Bool> {
        base.buttonRefference().rx.isEnabled
    }
    
    var buttonState: Binder<ButtonState> {
        Binder<ButtonState>(base) { fullButton, state in
            fullButton.changeButtonStatus(state)
        }
    }
    
    var buttonEnable: Binder<Bool> {
        Binder<Bool>(base) { fullButton, enable in
            fullButton.changeButtonStatus(enable ? .enable : .disable)
        }
    }
}
