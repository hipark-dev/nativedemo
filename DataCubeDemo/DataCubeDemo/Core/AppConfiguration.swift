//
//  AppConfiguration.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import Foundation

enum BuildType: CustomStringConvertible {
    case dev
    case real
    
    var description: String {
        switch self {
        case .real:     return "real"
        case .dev:      return "dev"
        }
    }
    var needDebugLog: Bool {
        if self == .dev {
            return true
        }
        return false
    }
}

struct BuildConfig {
    static var type: BuildType = {
        #if BUILD_FOR_REAL
        return BuildType.real
        #else
        return BuildType.dev
        #endif
    }()
    
    static var date: Date {
        let info = Bundle.main.infoDictionary
        let bundleName = info?["CFBundleName"] as? String ?? "Info.plist"
        if let infoPath = Bundle.main.path(forResource: bundleName, ofType: nil),
            let infoAttr = try? FileManager.default.attributesOfItem(atPath: infoPath),
        let infoDate = infoAttr[FileAttributeKey.creationDate] as? Date { return infoDate }
        return Date()
    }
}
