//
//  NeedFullButtonProtocol.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import Foundation
import SnapKit

protocol NeedFullButtonProtocol where Self: UIViewController {
    var fullButton: FullButton? { get set }
    
    func addFullButton() -> FullButton
    func updateFullButtonConstraint()
}

extension NeedFullButtonProtocol {
    func addFullButton() -> FullButton {
        let fullButton = FullButton(frame: .zero)
        view.addSubview(fullButton)
        
        updateFullButtonConstraint()
        
        return fullButton
    }
    
    func updateFullButtonConstraint() {
        guard let fullButton = fullButton else { return }
        fullButton.snp.remakeConstraints { make in
            fullButton.bottomConstraint = make.bottom.equalToSuperview().constraint
            make.height.equalTo(view.safeAreaInsets.bottom + FullButton.Constant.height)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
}
