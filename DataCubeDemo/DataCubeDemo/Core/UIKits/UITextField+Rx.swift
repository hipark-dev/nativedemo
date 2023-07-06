//
//  UITextField+Rx.swift
//  TWBank
//
//  Created by JunKyung.Park on 31/07/2019.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UITextField {
    var deleteBackward: Observable<Void> {
        methodInvoked(#selector(base.deleteBackward)).map { _ in Void() }
    }
}

extension UITextField {
    func setLimitText(count value: Int) -> Disposable {
        rx.text.take(until: rx.deallocated).compactMap { $0 }
            .subscribe { [weak self] event in
                guard let input = event.element else { return }
                guard input.count >= value else { return }
                self?.text = String(input.prefix(value))
            }
        
    }
}

extension Reactive where Base: UITextField {
    var font: Binder<UIFont> {
        Binder<UIFont>(base) { textField, font in
            textField.font = font
        }
    }
}
