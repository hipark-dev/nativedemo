//
//  Reactive+UIScrollView.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UITableView {
    func allowsHeaderScroll() {
        _ = base.rx.didScroll.take(until: base.rx.deallocated).asDriver(onErrorJustReturn: ())
        .drive(onNext: { [weak base = base] in
            base?.applyZeroOffsetHeader()
        })
    }
}
