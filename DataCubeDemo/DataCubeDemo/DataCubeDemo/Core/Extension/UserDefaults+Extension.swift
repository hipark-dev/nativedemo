//
//  UserDefaults+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import SwiftyUserDefaults

extension DefaultsKeys {
    var loginToken: DefaultsKey<String> { .init("loginToken", defaultValue: .empty)}
    var email: DefaultsKey<String> { .init("email", defaultValue: .empty) }
    var password: DefaultsKey<String> { .init("password", defaultValue: .empty) }
}

@propertyWrapper
struct UserDefaultProptery<Value> {
    private let key: String
    var wrappedValue: Value? {
        get { UserDefaults.standard.object(forKey: key) as? Value }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
    init(_ key: String) {
        self.key = key
    }
}

@propertyWrapper
struct UserDefaultKeyedProptery<Key, Value> where Key: RawRepresentable, Key.RawValue == String {
    private let key: Key
    var wrappedValue: Value? {
        //TODO: if need UserDefaults.shared?
        get { UserDefaults.standard.object(forKey: key.rawValue) as? Value }
        set { UserDefaults.standard.set(newValue, forKey: key.rawValue) }
    }
    init(_ key: Key) {
        self.key = key
    }
}
