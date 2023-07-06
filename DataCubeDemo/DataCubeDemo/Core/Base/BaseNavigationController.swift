//
//  BaseNavigationController.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/29.
//

import UIKit
import RxSwift
import RxCocoa

class BaseNavigationController: UINavigationController {
    // FIXME: never usse this disposeBag, but ever time initialze
    //    private var disposeBag: DisposeBag? = DisposeBag()

    override var childForStatusBarStyle: UIViewController? {
        topViewController
    }
    
    override var childForStatusBarHidden: UIViewController? {
        topViewController
    }
}
