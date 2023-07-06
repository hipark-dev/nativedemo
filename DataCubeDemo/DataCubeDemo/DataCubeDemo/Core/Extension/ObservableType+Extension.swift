//
//  ObservableType+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import RxSwift

extension ObservableType {
    func flatMap<A: AnyObject, O: ObservableType>(weak obj: A, selector: @escaping (A, Self.Element) throws -> O) -> Observable<O.Element> {
        flatMap { [weak obj] value -> Observable<O.Element> in
            try obj.map { try selector($0, value).asObservable() } ?? .empty()
        }
    }
    
    func flatMapLatest<A: AnyObject, O: ObservableType>(weak obj: A, selector: @escaping (A, Self.Element) throws -> O) -> Observable<O.Element> {
        flatMapLatest { [weak obj] value -> Observable<O.Element> in
            try obj.map { try selector($0, value).asObservable() } ?? .empty()
        }
    }
}

extension ObservableType {
    func map<T>(_ element: T) -> Observable<T> {
        self.map({ _ in element })
    }
    
    func mapVoid() -> Observable<Void> {
        self.map(Void())
    }
}
