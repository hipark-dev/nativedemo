//
//  RxSwift+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import RxSwift
import RxCocoa

extension ControlEvent {
    func throttle(_ dueTime: RxTimeInterval = .milliseconds(300), isLatest: Bool = false, scheduler: SchedulerType) -> Observable<PropertyType> {
        self.throttle(dueTime, latest: isLatest, scheduler: scheduler)
    }
    
    func throttle(_ dueTime: RxTimeInterval = .milliseconds(300), scheduler: SchedulerType) -> Observable<PropertyType> {
        self.throttle(dueTime, latest: false, scheduler: scheduler)
    }
    
    func debounce(_ dueTime: RxTimeInterval = .milliseconds(300)) -> Observable<PropertyType> {
        self.debounce(dueTime, scheduler: MainScheduler.instance)
    }
}

extension ObservableType {
    func throttle(_ dueTime: RxTimeInterval = .milliseconds(300), isLatest: Bool = false, scheduler: SchedulerType = MainScheduler.instance) -> Observable<Element> {
        self.throttle(dueTime, latest: isLatest, scheduler: scheduler)
    }
    
    func throttle(_ dueTime: RxTimeInterval = .milliseconds(300), scheduler: SchedulerType = MainScheduler.instance) -> Observable<Element> {
        self.throttle(dueTime, latest: false, scheduler: scheduler)
    }
    
    func debounce(_ dueTime: RxTimeInterval = .milliseconds(300)) -> Observable<Element> {
        self.debounce(dueTime, scheduler: MainScheduler.instance)
    }
}

extension SharedSequenceConvertibleType {
    public func throttle(_ dueTime: RxTimeInterval = .milliseconds(300), isLatest: Bool = false) -> SharedSequence<SharingStrategy, Element> {
        self.throttle(dueTime, latest: isLatest)
    }
    
    public func throttle(_ dueTime: RxTimeInterval = .milliseconds(300)) -> SharedSequence<SharingStrategy, Element> {
        self.throttle(dueTime, latest: false)
    }
    
    public func debounce() -> SharedSequence<SharingStrategy, Element> {
        self.debounce(.milliseconds(300))
    }
}
