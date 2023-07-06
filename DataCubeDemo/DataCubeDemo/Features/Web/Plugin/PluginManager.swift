//
//  PluginManager.swift
//  DataCubeDemo
//
//  Created by hipark on 2022/10/17.
//

import Foundation

typealias JavaScriptCallback = (String, Bool) -> Void

final class PluginManager {
    
    static let shared = PluginManager()
    
    private init() {
        signupInputParameterStoredValue = [:]
        emailStoredValue = UIConstant.empty
        passwordStoredValue = UIConstant.empty
    }
    
    var signupInputParameter: [String: Any] {
        get {
            signupInputParameterStoredValue
        }
        set(newValue) {
            for key in newValue.keys {
                signupInputParameterStoredValue[key] = newValue[key]
            }
        }
        
    }
    private var signupInputParameterStoredValue: [String: Any]
    
    
    var email: String {
        get {
            emailStoredValue
        }
        set(newValue) {
            emailStoredValue = newValue
        }
    }
    private var emailStoredValue: String
    
    var password: String {
        get {
            passwordStoredValue
        }
        set(newValue) {
            passwordStoredValue = newValue
        }
    }
    private var passwordStoredValue: String
}
