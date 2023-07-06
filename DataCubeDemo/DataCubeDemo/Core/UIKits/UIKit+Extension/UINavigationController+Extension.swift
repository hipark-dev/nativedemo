//
//  UINavigationController.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit

extension UINavigationController {
    func pushViewController(
        _ viewController: UIViewController,
        animated: Bool = true,
        hidesBottomBarWhenPushed: Bool = false,
        completion: (() -> Void)? = nil) {
        viewController.hidesBottomBarWhenPushed = hidesBottomBarWhenPushed
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
}
