//
//  UITableView+Rx.swift
//  TWBank
//
//  Created by MyoungKyu.Shin on 16/04/2019.
//  Copyright © 2019 LINE Bank TW Corporation. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxSwiftExt

extension Reactive where Base: UITableViewCell {
    var prepareForReuse: Observable <Void> {
        methodInvoked(#selector (base.prepareForReuse)).mapTo(())
    }
    
    var obsolete: Observable <Void> {
        Observable.merge(prepareForReuse, deallocated)
    }
}

extension Reactive where Base: UICollectionViewCell {
    var prepareForReuse: Observable <Void> {
        methodInvoked(#selector (base.prepareForReuse)).mapTo(())
    }
    
    var obsolete: Observable <Void> {
        Observable.merge(prepareForReuse, deallocated)
    }
}

extension Reactive where Base == UITableView {
    func setAlphaByOffset(target view: UIView?, allowedRect: CGRect? = .zero) -> Disposable {
        base.rx.contentOffset.compactMap { $0.y - (allowedRect?.origin.y ?? 0.0) }.subscribe { offset in
            guard let offset: CGFloat = offset.element else { return }
            guard let allowedRect = allowedRect else { return }
            if offset > 0 {
                if offset > allowedRect.height {
                    view?.alpha = 1
                }
                view?.alpha = offset / allowedRect.height
            } else {
                view?.alpha = 0
            }
        }
    }
}

extension Reactive where Base: UITableView {
    func reloadRow(_ animation: UITableView.RowAnimation = .none) -> Binder<IndexPath> {
        Binder(base) { view, indexPath in
            view.reloadRows(at: [indexPath], with: animation)
        }
    }
    
    func reloadSection(_ animation: UITableView.RowAnimation = .automatic) -> Binder<IndexSet> {
        Binder(base) {  view, indexSet in
            view.reloadSections(indexSet, with: animation)
        }
    }
    
    func modelAndItemSelected<T>(_ modelType: T.Type) -> Observable<(T, IndexPath)> {
        Observable.zip(base.rx.modelSelected(modelType), base.rx.itemSelected)
    }
}
