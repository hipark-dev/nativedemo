//
//  BaseViewController.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit
import BonMot
import RxCocoa
import RxSwift
import RxGesture
import RxKeyboard
import NVActivityIndicatorView

class BaseViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    var setNeedsNewDisposeBag: Bool = false {
        didSet {
            if setNeedsNewDisposeBag {
                disposeBag = DisposeBag()
                setNeedsNewDisposeBag = false
            }
        }
    }
    
    private var cellHeightDictionary: [String: Int] = [:]
    private(set) lazy var className: String = {
        type(of: self).description().components(separatedBy: ".").last ?? .empty
    }()
    private var activityIndicatorView: NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        with(navigationController?.navigationBar) {
            $0?.isTranslucent = false
            $0?.barTintColor = .white
        }
        
        addFullButtonIfNedded()
        setActivityIndicatorView()
        
        Logger.debug("viewDidLoad: \(self.className)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    deinit {
        Logger.debug("deinit: \(self.className)")
    }
}

extension BaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        otherGestureRecognizer is UIScreenEdgePanGestureRecognizer
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        gestureRecognizer is UIScreenEdgePanGestureRecognizer
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == navigationController?.interactivePopGestureRecognizer else {
            return true
        }
        
        guard navigationController?.topViewController?.isBeingDismissed == false else {
            return false
        }
        
        guard navigationController?.topViewController?.isBeingPresented == false else {
            return false
        }
        
        guard navigationController?.isBeingPresented == false else {
            return false
        }
        
        guard navigationController?.isBeingDismissed == false else {
            return false
        }
        
        guard (navigationController.map { $0.viewControllers.count } ?? 0) > 1 else {
            return false
        }
        
        guard navigationController?.transitionCoordinator == nil else {
            return false
        }
        
        return true
    }
}

extension BaseViewController {
    
    enum NavigationItemType {
        case white
        case black
        case image(name: String)
        case title(_ title: String, color: StyleColor, font: StyleFont)
    }
    
    @objc func setNavigationBarItem() {
        navigationItem.lets {
            $0.leftBarButtonItem?.tintColor = .white
            $0.rightBarButtonItem?.tintColor = .white
            $0.titleView?.tintColor = .white
        }
        
        navigationController?.navigationBar.lets {
            $0.setTitleColor(.white)
            $0.isTranslucent = false
        }
    }
    
    func setBackButton(_ type: NavigationItemType = .black) {
        switch type {
        case .white:
            setBackButtonWithImage("back")
        case .black:
            setBackButtonWithImage("back2")
        case .image(let name):
            setBackButtonWithImage(name)
        case let .title(title, color, font):
            setBackButtonWithTitle(title, color: color.apply, font: font.apply)
        }
    }
    
    func setBackButtonWithTitle(_ title: String, color: UIColor, font: UIFont) {
        UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(back))
            .lets {
                $0.setTitleTextAttributes([.foregroundColor: color, .font: font], for: .normal)
                navigationItem.setLeftBarButton($0, animated: true)
            }
    }
    
    
    private func setBackButtonWithImage(_ imageName: String) {
        navigationItem.lets {
            $0.setLeftBarButton(UIBarButtonItem(
                image: UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal),
                style: .plain,
                target: self,
                action: #selector(back)), animated: true)
        }
        setLeftBarButtonInset(inset: UIEdgeInsets(top: 1, left: -6, bottom: 0, right: 0))
    }
    
    @objc func back() {
        if notPoppable {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    var notPoppable: Bool {
        [
            ((navigationController?.isModalTopViewController ?? false) && isRootViewController),
            isModalTopViewController
        ].contains(true)
    }
    
    func setLeftBarButtonInset(inset: UIEdgeInsets) {
        navigationItem.leftBarButtonItem?.imageInsets = inset
    }
    
}

extension BaseViewController {
    /**
     Need to import RxGesture when you use.
     */
    func hideKeyboard(when gestures: AnyFactory...) {
        for gesture in gestures {
            view.rx
                .anyGesture(gesture)
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    self?.dismissKeyboard()
                })
                .disposed(by: disposeBag)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    var bottomSafeArea: CGFloat {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets.bottom
        } else {
            return bottomLayoutGuide.length
        }
    }
    
    var topSafeArea: CGFloat {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets.top
        } else {
            return bottomLayoutGuide.length
        }
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        updateFullButtonConstraintIfNeeded()
    }
}

extension BaseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeightDictionary[indexPath.description] = cell.frame.size.height.toInt
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = cellHeightDictionary[indexPath.description] {
            return height.asCGFloat
        }
        return UITableView.automaticDimension
    }
}

private extension BaseViewController {
    func addFullButtonIfNedded() {
        guard let self = self as? NeedFullButtonProtocol else { return }
        self.fullButton = self.addFullButton()
        
        updateFullButtonConstraintIfNeeded()
        
        bindFullButtonIfNeeded()
    }
    
    func updateFullButtonConstraintIfNeeded() {
        (self as? NeedFullButtonProtocol)?.updateFullButtonConstraint()
    }
}

extension BaseViewController {
    @objc func bindFullButtonIfNeeded() {
        
    }
}

extension BaseViewController {
    @objc func enterForegroundRefresh() {
    }
}

extension BaseViewController {
    
    func startIndicator() {
        activityIndicatorView?.startAnimating()
    }
    
    func stopIndicator() {
        activityIndicatorView?.stopAnimating()
    }
    
    private func setActivityIndicatorView() {
        let activityIndicatorViewFrame: CGRect = .init(x: view.center.x - 25, y: view.center.y - 100, width: 50, height: 50)
        activityIndicatorView = NVActivityIndicatorView(frame: activityIndicatorViewFrame,
                                                        type: .pacman,
                                                        color: StyleColor.green_61DDB1.apply,
                                                        padding: .zero)
        guard let indicatorView = activityIndicatorView else { return }
        view.addSubview(indicatorView)
    }
}
