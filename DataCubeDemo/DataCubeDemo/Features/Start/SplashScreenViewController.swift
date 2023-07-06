//
//  SplashScreenViewController.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/29.
//

import UIKit
import RxSwift
import ReactorKit

class SplashScreenViewController: BaseViewController {
    
    private var isShowWorkthrough: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.next()
        }
    }
}

extension SplashScreenViewController {
    
    private func next() {
        if isShowWorkthrough {
            showWebView()
        } else {
            showWelcomeView()
        }
    }
    
    private func showWelcomeView() {
        let viewController = WelcomeViewController.storyboardViewController()
        let navigationController = BaseNavigationController(rootViewController: viewController)
        UIApplication.shared.keyWindow?.rootViewController = navigationController
    }
    
    private func showWebView() {
        let viewController = WebViewController.storyboardViewController()
        let navigationController = BaseNavigationController(rootViewController: viewController)
        UIApplication.shared.keyWindow?.rootViewController = navigationController
    }
}
