//
//  BaseView.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit
import RxSwift
import RxCocoa

protocol BaseViewProtocol {
    associatedtype Value
    func configureWith(value: Value)
    var disposeBag: DisposeBag { get }
    
}

extension BaseViewProtocol {
    var disposeBag: DisposeBag {
        DisposeBag()
    }
}

protocol BaseViewModelProtocol { }

// MARK: - BaseView
class BaseView: UIView, BaseViewProtocol {
    
    private(set) var disposeBag = DisposeBag()
    typealias Value = BaseViewModelProtocol
    
    /// Should be override func if needed
    func configureWith(value: BaseViewModelProtocol) {
    }
}

class ViewModelType<Base: ViewModelStream>: ViewModelStream {
    private(set) lazy var inputs: Base.Input = { base.inputs }()
    private(set) lazy var outputs: Base.Output = { base.outputs }()
    private var base: Base
    init(_ base: Base) {
        self.base = base
    }
    deinit { Logger.debug("ViewModelType Deinit Base == \(Base.self)") }
}
