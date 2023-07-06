//
//  UIViewController+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import Foundation
import UIKit

extension UIViewController {
    var topMostViewController: UIViewController {
        topViewControllerWithRootViewController(self)
    }
    
    var modalTopViewController: UIViewController {
        if let viewController = presentedViewController {
            return viewController.modalTopViewController
        }
        return self
    }
    
    var modalTopMostViewController: UIViewController {
        if let viewController = presentedViewController {
            return viewController.modalTopViewController
        }
        return topMostViewController
    }
    
    var isModalTopViewController: Bool {
        presentingViewController?.presentedViewController == self
    }
    
    var isRootViewController: Bool {
        navigationController?.viewControllers.first == self
    }
    
    private func topViewControllerWithRootViewController(_ rootViewController: UIViewController) -> UIViewController {
        guard let topViewController = UIApplication.topViewController() else {
            return rootViewController
        }
        
        return topViewController
    }
    
    func dismissAllModalViewController(completion:(() -> Void)? = nil) {
        if let viewController = presentedViewController {
            viewController.dismiss(animated: false, completion: { [weak self] in
                self?.dismissAllModalViewController(completion: completion)
            })
        } else {
            dismiss(animated: false, completion: completion)
        }
    }
    
    func setPopOverPresent(_ sender: UIView) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.popoverPresentationController?.sourceRect = sender.frame
            self.popoverPresentationController?.sourceView = sender
            self.popoverPresentationController?.permittedArrowDirections = .any
        }
    }
    
    func isPresent() -> Bool {
        if presentingViewController != nil {
            return true
        }
        
        if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        }
        
        return false
    }
}

extension UIViewController {
    var safeAreaHeight: CGFloat {
        if #available(iOS 11.0, *) { 
            return view.safeAreaLayoutGuide.layoutFrame.height
        } else {
            let screenHeight = UIScreen.main.bounds.height
            return screenHeight - topLayoutGuide.length - bottomLayoutGuide.length
        }
    }
}
