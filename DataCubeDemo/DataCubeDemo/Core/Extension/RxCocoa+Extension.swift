//
//  RxCocoa+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import RxSwift
import RxCocoa

extension SharedSequenceConvertibleType where Self.SharingStrategy == RxCocoa.DriverSharingStrategy {
    /**
     Leverages instance method currying to provide a weak wrapper around an instance function
     
     - parameter obj:    The object that owns the function
     - parameter method: The instance function represented as `InstanceType.instanceFunc`
     */
    fileprivate func weakify<A: AnyObject, B>(_ obj: A, method: ((A) -> (B) -> Void)?) -> ((B) -> Void) { { [weak obj] value in
            guard let obj = obj else { return }
            method?(obj)(value)
        }
    }
    
    fileprivate func weakify<A: AnyObject>(_ obj: A, method: ((A) -> () -> Void)?) -> (() -> Void) { { [weak obj] in
            guard let obj = obj else { return }
            method?(obj)()
        }
    }
    
    /**
     Subscribes an element handler, an error handler, a completion handler and disposed handler to an observable sequence.
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter onNext: Function to invoke on `weak` for each element in the observable sequence.
     - parameter onError: Function to invoke on `weak` upon errored termination of the observable sequence.
     - parameter onCompleted: Function to invoke on `weak` upon graceful termination of the observable sequence.
     - parameter onDisposed: Function to invoke on `weak` upon any type of termination of sequence (if the sequence has
     gracefully completed, errored, or if the generation is cancelled by disposing subscription)
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    public func drive<A: AnyObject>(
        weak obj: A,
        onNext: ((A) -> (Self.Element) -> Void)? = nil,
        onError: ((A) -> (Error) -> Void)? = nil,
        onCompleted: ((A) -> () -> Void)? = nil,
        onDisposed: ((A) -> () -> Void)? = nil)
        -> Disposable {
            let disposable: Disposable
            
            if let disposed = onDisposed {
                disposable = Disposables.create(with: weakify(obj, method: disposed))
            } else {
                disposable = Disposables.create()
            }
            let observer = AnyObserver { [weak obj] (event: RxSwift.Event<Self.Element>) in
                guard let obj = obj else { return }
                switch event {
                case .next(let value):
                    onNext?(obj)(value)
                case .error(let error):
                    onError?(obj)(error)
                    disposable.dispose()
                case .completed:
                    onCompleted?(obj)()
                    disposable.dispose()
                }
            }
            
            return Disposables.create(self.drive(observer), disposable)
    }
        
    public func drive<A: AnyObject>(
        weak obj: A,
        onNext: ((A) -> () -> Void)? = nil,
        onError: ((A) -> (Error) -> Void)? = nil,
        onCompleted: ((A) -> () -> Void)? = nil,
        onDisposed: ((A) -> () -> Void)? = nil)
        -> Disposable {
            let disposable: Disposable
            
            if let disposed = onDisposed {
                disposable = Disposables.create(with: weakify(obj, method: disposed))
            } else {
                disposable = Disposables.create()
            }
            let observer = AnyObserver { [weak obj] (event: RxSwift.Event<Self.Element>) in
                guard let obj = obj else { return }
                switch event {
                case .next:
                    onNext?(obj)()
                case .error(let error):
                    onError?(obj)(error)
                    disposable.dispose()
                case .completed:
                    onCompleted?(obj)()
                    disposable.dispose()
                }
            }
            
            return Disposables.create(self.drive(observer), disposable)
    }
    
    /**
     Subscribes an element handler to an observable sequence.
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter onNext: Function to invoke on `weak` for each element in the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    public func driveNext<A: AnyObject>(weak obj: A, _ onNext: @escaping (A) -> (Self.Element) -> Void) -> Disposable {
        self.drive(onNext: weakify(obj, method: onNext))
    }
    
    public func driveNext<A: AnyObject>(weak obj: A, _ onNext: @escaping (A) -> () -> Void) -> Disposable {
        self.drive(weak: obj, onNext: onNext)
    }
    /**
     Subscribes a completion handler to an observable sequence.
     
     - parameter weak: Weakly referenced object containing the target function.
     - parameter onCompleted: Function to invoke on `weak` graceful termination of the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    public func driveCompleted<A: AnyObject>(weak obj: A, _ onCompleted: @escaping (A) -> () -> Void) -> Disposable {
        self.drive(onCompleted: weakify(obj, method: onCompleted))
    }
}

extension Reactive where Base == UILabel {
    var isEnabled: Binder<Bool> {
        Binder(self.base) { target, isEnabled in
            target.isEnabled = isEnabled
        }
    }
}
