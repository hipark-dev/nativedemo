//
//  UIViewController+Swizzle.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit
import ObjectiveC

private func swizzle(_ vc: UIViewController.Type) {
    [
        (#selector(vc.viewDidLoad), #selector(vc.lap_viewDidLoad)),
        (#selector(vc.viewWillAppear(_:)), #selector(vc.lap_viewWillAppear(_:))),
        (#selector(vc.traitCollectionDidChange(_:)), #selector(vc.lap_traitCollectionDidChange(_:)))
    ].forEach { original, swizzled in
            
            guard let originalMethod = class_getInstanceMethod(vc, original),
                let swizzledMethod = class_getInstanceMethod(vc, swizzled) else { return }
            
            let didAddViewDidLoadMethod = class_addMethod(vc,
                                                          original,
                                                          method_getImplementation(swizzledMethod),
                                                          method_getTypeEncoding(swizzledMethod))
            
            if didAddViewDidLoadMethod {
                class_replaceMethod(vc,
                                    swizzled,
                                    method_getImplementation(originalMethod),
                                    method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
    }
}

private var hasSwizzled = false

extension UIViewController {
    class func doBadSwizzleStuff() {
        guard !hasSwizzled else { return }
        
        hasSwizzled = true
        swizzle(self)
        if #available(iOS 13.0, *) {
            presentationStyleFullScreenSwizzle
            interactiveDissmissSwizzle
        }
    }
    
    @objc func lap_viewDidLoad() {
        self.lap_viewDidLoad()
        self.bindViewModel()
    }
    
    @objc func lap_viewWillAppear(_ animated: Bool) {
        self.lap_viewWillAppear(animated)
        
        if !self.hasViewAppeared {
            self.bindStyles()
            self.hasViewAppeared = true
        }
    }
    
    /**
     The entry point to bind all view model outputs. Called just before `viewDidLoad`.
     */
    @objc open func bindViewModel() {
    }
    
    /**
     The entry point to bind all styles to UI elements. Called just after `viewDidLoad`.
     */
    @objc open func bindStyles() {
    }
    
    @objc func lap_traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.lap_traitCollectionDidChange(previousTraitCollection)
        self.bindStyles()
    }
    
    private struct AssociatedKeys {
        static var hasViewAppeared: String = "hasViewAppeared"
    }
    
    // Helper to figure out if the `viewWillAppear` has been called yet
    private var hasViewAppeared: Bool {
        get {
            (objc_getAssociatedObject(self, &AssociatedKeys.hasViewAppeared) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.hasViewAppeared,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UIViewController {
    static let presentationStyleFullScreenSwizzle: Void = {
        let originalSelector = #selector(present(_:animated:completion:))
        let swizzledSelector = #selector(presentSwizzle)
        
        let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector)

        if let origin = originalMethod, let swizzle = swizzledMethod {
            method_exchangeImplementations(origin, swizzle)
        }
    }()

    @objc func presentSwizzle(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if #available(iOS 13.0, *) {
            if viewControllerToPresent.modalPresentationStyle == .automatic || // prevent default pagesheet
                viewControllerToPresent.modalPresentationStyle == .pageSheet { // prevent landscape pagesheet
                viewControllerToPresent.modalPresentationStyle = .fullScreen
            }
        }

        DispatchQueue.main.safeAsync {
            self.presentSwizzle(viewControllerToPresent, animated: flag, completion: completion)
        }
    }
}

extension UIViewController {
    public static let interactiveDissmissSwizzle: Void = {
        let originalSelector = #selector(present(_:animated:completion:))
        let swizzledSelector = #selector(preventInteractiveDismiss)
        
        let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector)

        if let origin = originalMethod, let swizzle = swizzledMethod {
            method_exchangeImplementations(origin, swizzle)
        }
    }()

    @objc func preventInteractiveDismiss(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        #if swift(>=5.1)
        if #available(iOS 13.0, *) {
            viewControllerToPresent.isModalInPresentation = viewControllerToPresent is ModalInPresentable
        }
        #endif
        preventInteractiveDismiss(viewControllerToPresent, animated: flag, completion: completion)
    }
}
