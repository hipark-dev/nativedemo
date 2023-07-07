//
//  WelcomeViewController.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/27.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift
import Lottie

class WelcomeViewController: BaseViewController, StoryboardView  {
    
    typealias Reactor = WelcomeViewReactor
    
    @IBOutlet private weak var animationView: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationView.loopMode = .loop
        animationView.play()
    }
    
    override func bindStyles() {
        navigationController?.view.backgroundColor = .white
    }
    
    func bind(reactor: WelcomeViewReactor) {
        Logger.debug("bind==========================")
    }
    
    @IBAction func pushLoginView(_ sender: Any) {
        let viewController = WebViewController.initiate()
        navigationController?.pushViewController(viewController)
    }
    
    @IBAction func pushSignupView(_ sender: Any) {
        let url = URL(string: "https://devfs.fingerservice.co.kr?groupCd=10001&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkZGFuZ3lvQDEiLCJleHAiOjE2ODg3NzU1OTcsImJpel9yZWdfbm8iOiIxMjA4NjE1ODgxIn0.O8srBVZGHR65isyvFerM83h5Rk25r4I85a7t3xH-72g")
        UIApplication.shared.open(url!)
        
    }
}
