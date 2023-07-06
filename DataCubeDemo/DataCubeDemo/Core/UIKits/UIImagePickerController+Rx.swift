//
//  UIImagePickerController+Rx.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIImagePickerController {
    static func createWithParent(_ parent: UIViewController?, animated: Bool = true, configureImagePicker: @escaping (UIImagePickerController) throws -> Void = { value in }) -> Observable<UIImagePickerController> {
        Observable.create { [weak parent] observer in
            let imagePicker = UIImagePickerController()
            let dismissDisposable = imagePicker.rx
                .didCancel
                .subscribe(
                    onNext: { [weak imagePicker] _ in
                        guard let imagePicker = imagePicker else { return }
                        dismissViewController(imagePicker, animated: animated)
                    }
            )
            
            do {
                try configureImagePicker(imagePicker)
            } catch let error {
                observer.on(.error(error))
                return Disposables.create()
            }
            
            guard let parent = parent else {
                observer.on(.completed)
                return Disposables.create()
            }
            
            parent.present(imagePicker, animated: animated, completion: nil)
            observer.on(.next(imagePicker))
            
            return Disposables.create(dismissDisposable, Disposables.create {
                dismissViewController(imagePicker, animated: animated)
            })
        }
    }
    
    static func dismissViewController(_ viewController: UIViewController, animated: Bool) {
        if viewController.isBeingDismissed || viewController.isBeingPresented {
            DispatchQueue.main.async {
                dismissViewController(viewController, animated: animated)
            }
        } else if viewController.presentingViewController != nil {
            viewController.dismiss(animated: animated, completion: nil)
        }
    }
}

extension Reactive where Base: UIImagePickerController {
    
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didFinishPickingMediaWithInfo: Observable<[String: AnyObject]> {
        delegate .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
            .map { object in
                guard let info = object[1] as? [String: AnyObject] else {
                    throw RxCocoaError.castingError(object: object[1], targetType: [String: AnyObject].self)
                }
                return info
            }
    }
    
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didCancel: Observable<()> {
        delegate .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
            .map { _ in () }
    }
    
}
