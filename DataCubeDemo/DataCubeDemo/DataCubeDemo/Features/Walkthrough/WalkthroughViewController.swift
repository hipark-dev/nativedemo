//
//  WalkthroughViewController.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/15.
//

import UIKit
import RxCocoa
import RxSwift
import ReactorKit

class WalkthroughViewController: BaseViewController, StoryboardView {
    
    typealias Reactor = WalkthroughViewReactor
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var fullButton: FullButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = Reactor()
    }
    
    override func bindFullButtonIfNeeded() {
        guard let fullButton = fullButton else { return }
        
        fullButton.lets {
            $0.bindStyles()
            $0.configureButton(.disable, title: UIConstant.next)
        }
    }
    
    func bind(reactor: WalkthroughViewReactor) {
        
        // Action
        
        fullButton?.tapEvent().map { Reactor.Action.next }.bind(to: reactor.action).disposed(by: disposeBag)
        
//        scrollView.rx.contentOffset.map{
//            Reactor.Action.swipeView(offset: $0)
//        }.bind(to: reactor.action).disposed(by: disposeBag)
//        
//        pageControl.rx.controlEvent(.valueChanged).map{
//            Reactor.Action.swipeView(offset: pageControl.currentPage.)
//        }
        
//        pageControl.rx.controlEvent(.valueChanged)
//            .subscribe(onNext: { [weak self] in
//                guard let currentPage = self?.pageControl.currentPage else {
//                    return
//                }
//                self?.scrollView.setCurrentPage(currentPage, animated: true)
//            })
//            .disposed(by: disposeBag)
//
//        scrollView.rx.currentPage
//            .subscribe(onNext: { [weak self] in
//                self?.pageControl.currentPage = $0
//            })
//            .disposed(by: disposeBag)
        
        
        
        // State
        reactor.state.map {
            $0.imageNames
        }.distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [unowned self] in
                self.setupUI(images:$0, pageWidth: reactor.pageWidth)
            }).disposed(by: disposeBag)
        
        reactor.state.map {
            $0.imageNames.count
        }.distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: pageControl.rx.numberOfPages)
            .disposed(by: disposeBag)
        
        reactor.state.map{
            $0.currentPageIndex
        }.bind(to: pageControl.rx.currentPage).disposed(by: disposeBag)
        
        reactor.state.map {
            $0.nextButtonState
        }.distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: fullButton!.rx.buttonState)
            .disposed(by: disposeBag)
    }
    
    func setupUI(images: [String], pageWidth: CGFloat) {
        
        scrollView.lets {
            $0.alwaysBounceVertical = false
            $0.isPagingEnabled = true
            $0.isScrollEnabled = true
            $0.contentSize = .init(width: ($0.frame.width) * CGFloat(images.count), height: $0.frame.height)
        }
        
        pageControl.lets {
            $0.currentPage = .zero
            $0.pageIndicatorTintColor = .lightGray
            $0.currentPageIndicatorTintColor = StyleColor.green_00B8C5.apply
        }
        
        for (index, imageName) in images.enumerated() {
            let imageView = UIImageView(image: .init(named: imageName))
            scrollView.addSubview(imageView)
        }
    }
}

extension WalkthroughViewController: NeedFullButtonProtocol { }
