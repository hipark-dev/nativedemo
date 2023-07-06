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
   
    @IBOutlet private weak var animationView: AnimationView!
    
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
        let url = URL(string: "https://devfs.fingerservice.co.kr/landing?groupCd=10001&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkZGFuZ3lvQDEiLCJleHAiOjE2ODg2MDcwMjksImJpel9yZWdfbm8iOiIxMjA4NjE1ODgxIn0.f9l68qTM_sNjIOikoX2G24RD4hnWiG132QY79SW4yjo")
        UIApplication.shared.open(url!)
        
    }
}
