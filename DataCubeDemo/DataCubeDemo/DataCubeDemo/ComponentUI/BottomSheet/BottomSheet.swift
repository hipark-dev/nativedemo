//
//  BottomSheet.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import Foundation
import PanModal

protocol ModalInPresentable {}
class BottomSheetViewController: UIViewController {
    var longFormHeight: PanModalHeight {
        shortFormHeight
    }
    
    var shortFormHeight: PanModalHeight {
        .intrinsicHeight
    }
    
}

extension BottomSheetViewController: PanModalPresentable {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    var panScrollable: UIScrollView? {
        nil
    }
    
    var anchorModalToLongForm: Bool {
        true
    }
    
    var cornerRadius: CGFloat {
        0
    }
    
    var shouldRoundTopCorners: Bool {
        false
    }
    
    var allowsDragToDismiss: Bool {
        false
    }
    
    var panModalBackgroundColor: UIColor { StyleColor.black_222222.apply.withAlphaComponent(0.4) }
    
}
