//
//  SearchController+Rx.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UISearchController {
    var searchResultUpdater: DelegateProxy<UISearchController, UISearchResultsUpdating> {
        RxSearchResultUpdatingProxy.proxy(for: base)
    }
    var queryText: Observable<String> {
        Observable.merge(Observable.just(String()),
                         RxSearchResultUpdatingProxy
                            .proxy(for: base)
                            .didUpdateSearchResultSubject.map { $0.searchBar.text ?? "" })
            .distinctUntilChanged()
    }
}
class RxSearchResultUpdatingProxy: DelegateProxy<UISearchController, UISearchResultsUpdating>, DelegateProxyType, UISearchResultsUpdating {
    
    static func currentDelegate(for object: UISearchController) -> UISearchResultsUpdating? {
        object.searchResultsUpdater
    }
    
    static func setCurrentDelegate(_ delegate: UISearchResultsUpdating?, to object: UISearchController) {
        object.searchResultsUpdater = delegate
    }
    
    static func registerKnownImplementations() { self.register { RxSearchResultUpdatingProxy(searchController: $0) } }
    
    init(searchController: UISearchController) {
        super.init(parentObject: searchController, delegateProxy: RxSearchResultUpdatingProxy.self)
    }
    
    let didUpdateSearchResultSubject = PublishSubject<UISearchController>()
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let forwardToDelegate = _forwardToDelegate else { return }
        forwardToDelegate.updateSearchResults(for: searchController)
        didUpdateSearchResultSubject.onNext(searchController)
    }
    
    deinit { didUpdateSearchResultSubject.onCompleted() }
}

