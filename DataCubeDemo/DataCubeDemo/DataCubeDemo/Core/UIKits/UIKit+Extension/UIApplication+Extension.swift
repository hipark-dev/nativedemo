//
//  UIApplication+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit

extension UIApplication {
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        
        return viewController
    }
    

}

extension UIApplication {
    
    var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes.first
            .flatMap{ $0 as? UIWindowScene }?.windows
            .first
    }
    
    var topSafeArea: CGFloat {
        let statusBarHeight = keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navigationBarHeight = UIApplication.topViewController()?.navigationController?.navigationBar.frame.height ?? 0.0
        return statusBarHeight + navigationBarHeight
    }
}
