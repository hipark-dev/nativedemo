//
//  Bridge.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/08/01.
//

import Foundation
import SwiftyUserDefaults

class Bridge: NSObject {
    
    var callback: JavaScriptCallback?
    
    @objc func back(_ args: Any) {
        guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? BaseNavigationController else {
            Logger.error("UIApplication.shared.keyWindow.rootViewController is not NavigationController")
            return
        }
        navigationController.popViewController(animated: false)
    }
    
    @objc func getLoginInfo(_ args: Any, handler: @escaping JavaScriptCallback) {
        Logger.debug("getLoginInfo ==== \(Defaults[\.email]) / \(Defaults[\.password])")
        handler(["email": Defaults[\.email], "password": Defaults[\.password]].prettyString, false)
    }
    
    @objc func getSystemInfo(_ args: Any, handler: @escaping JavaScriptCallback) {
        Logger.debug("version: \(Environment.bundleVersion), build: \(Environment.buildVersion)")
        handler("version: \(Environment.bundleVersion), build: \(Environment.buildVersion)", false)
    }
}
