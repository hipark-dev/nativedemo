//
//  CallUtility.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import Foundation
import CallKit
import UIKit

class CallUtility: NSObject {
    
    enum CallResultType {
        case call
        case cancel
    }
    
    typealias Completion = (CallUtility.CallResultType) -> Void
    let callObserver = CXCallObserver()
    let notificationName = UIApplication.didBecomeActiveNotification
    var didDetectOutgoingCall = false
    var completion: Completion?
    func call(_ rawNumber: String, completion: Completion?) {
        let number = rawNumber.digits
        guard let url = URL(string: "tel://\(number)") else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
        self.completion = completion
        callObserver.setDelegate(self, queue: nil)
        didDetectOutgoingCall = false
        UIApplication.shared.open(url, options: [:]) { [weak self] success in
            if success {
                DispatchQueue.main.safeAsync {
                    self?.addNotificationObserver()
                }
            }
        }
    }
    
    func addNotificationObserver() {
        let selector = #selector(appDidBecomeActive)
        NotificationCenter.default.addObserver(self,
                                               selector: selector,
                                               name: notificationName,
                                               object: nil)
    }
    
    func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
    }
    
    @objc func appDidBecomeActive() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            if self.didDetectOutgoingCall == false {
                self.completion?(.cancel)
            } else {
                self.completion?(.call)
            }
            self.removeNotificationObserver()
        }
    }
}

extension CallUtility: CXCallObserverDelegate {
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        if call.isOutgoing && !didDetectOutgoingCall {
            didDetectOutgoingCall = true
        }
    }
}
