//
//  ViewController.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class MainViewController: UITabBarController {
    
    weak var reactor: MainTabViewReactor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeViewController()
        styleTabBar()
        self.delegate = self
    }
    
    func bind(reactor: MainTabViewReactor) {
        self.reactor = reactor
    }
    
}

extension MainViewController {
    private func makeViewController() {
        super.viewControllers = MainTab.allTabs.map {
            let vc = $0.viewController.storyboardViewController()
            vc.tabBarItem = UITabBarItem(title: $0.title, image: UIImage(named: $0.imageName), selectedImage: UIImage(named: $0.selectedImageName))
            let horizontal: CGFloat = $0 == .top ? 0 : -1
            vc.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: horizontal, vertical: -3)
            UITabBarItem.appearance().setTitleTextAttributes([.font: StyleFont.micro2(weight: .regular)], for: .normal)
            return vc
        }
    }
    
    private func styleTabBar() {
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().tintColor = StyleColor.darkGreyBlue.apply
        UITabBar.appearance().unselectedItemTintColor = StyleColor.gray_85909B.apply
        
        if #available(iOS 13, *) {
            let appearance = self.tabBar.standardAppearance.copy()
            appearance.backgroundImage = UIImage()
            appearance.shadowImage = UIImage()
            appearance.backgroundColor = StyleColor.white_FFFFFF.apply
            appearance.shadowColor = StyleColor.gray_E5E5E5.apply.withAlphaComponent(0.8)
            self.tabBar.standardAppearance = appearance
            
        } else {
            
            //background color
            UITabBar.appearance().backgroundImage = UIImage()
            UITabBar.appearance().backgroundColor = StyleColor.white_FFFFFF.apply
            //top line
            UITabBar.appearance().shadowImage = UIImage()
        
            let border = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 0.5))
            border.backgroundColor = StyleColor.gray_E5E5E5.apply.withAlphaComponent(0.8)
            tabBar.addSubview(border)
        }
    }
}

extension MainViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    }
}
