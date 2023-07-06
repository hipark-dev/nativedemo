//
//  UIDevice+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit

extension UIDevice {
    
    //    "iPod5,1" -> "iPod Touch 5"
    //    "iPod7,1" -> "iPod Touch 6"
    //    "iPhone3,1", "iPhone3,2", "iPhone3,3" -> "iPhone 4"
    //    "iPhone4,1"-> "iPhone 4s"
    //    "iPhone5,1", "iPhone5,2"-> "iPhone 5"
    //    "iPhone5,3", "iPhone5,4"-> "iPhone 5c"
    //    "iPhone6,1", "iPhone6,2"-> "iPhone 5s"
    //    "iPhone7,2"-> "iPhone 6"
    //    "iPhone7,1"-> "iPhone 6 Plus"
    //    "iPhone8,1"-> "iPhone 6s"
    //    "iPhone8,2"-> "iPhone 6s Plus"
    //    "iPhone8,4"-> "iPhone SE"
    //    "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4"-> "iPad 2"
    //    "iPad3,1", "iPad3,2", "iPad3,3"-> "iPad 3"
    //    "iPad3,4", "iPad3,5", "iPad3,6"-> "iPad 4"
    //    "iPad4,1", "iPad4,2", "iPad4,3"-> "iPad Air"
    //    "iPad5,3", "iPad5,4"-> "iPad Air 2"
    //    "iPad2,5", "iPad2,6", "iPad2,7"-> "iPad Mini"
    //    "iPad4,4", "iPad4,5", "iPad4,6"-> "iPad Mini 2"
    //    "iPad4,7", "iPad4,8", "iPad4,9"-> "iPad Mini 3"
    //    "iPad5,1", "iPad5,2"-> "iPad Mini 4"
    //    "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8"-> "iPad Pro"
    //    "AppleTV5,3"-> "Apple TV"
    //    "i386", "x86_64"-> "Simulator"
    static func platform() -> String {
        var size: Int = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: Int(size))
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        
        if let platformName = String(validatingUTF8: machine) {
            return platformName
        }
        
        return UIDevice.current.name
    }
    var isiPhone: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            return true
        }
        return false
    }
    var isiPad: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            return true
        }
        return false
    }
    var isSimulator: Bool {
       TARGET_OS_SIMULATOR != 0
    }
    var isLandscape: Bool {
        orientation.isLandscape || UIApplication.shared.statusBarOrientation.isLandscape
    }
    
    var isPortrait: Bool {
        orientation.isPortrait || UIApplication.shared.statusBarOrientation.isPortrait
    }
    
    var isIphoneX: Bool {
        if #available(iOS 11.0, *), isiPhone {
            if isLandscape {
                if let leftPadding = UIApplication.shared.keyWindow?.safeAreaInsets.left, leftPadding > 0 {
                    return true
                }
                if let rightPadding = UIApplication.shared.keyWindow?.safeAreaInsets.right, rightPadding > 0 {
                    return true
                }
            } else {
                if let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top, topPadding > 20 {
                    return true
                }
                if let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom, bottomPadding > 0 {
                    return true
                }
            }
        }
        return false
    }
    
    enum FinalLanguageCode: CaseIterable {
        case zhHans
        case zhHant
        case enUS
        case koKR
        
        var keyCode: (key: String, code: String) {
            switch self {
            case .zhHans:
                return (key: "zh_Hans", code: "zh_CN")
            case .zhHant:
                return (key: "zh_Hant", code: "zh_TW")
            case .enUS:
                return (key: "en_US", code: "en")
            case .koKR:
                return (key: "ko_KR", code: "ko")
            }
        }
    }
    
    static let finalLanguageCodes: [String: String] = Dictionary(uniqueKeysWithValues: FinalLanguageCode.allCases.map { $0.keyCode })
    
    //["zh_Hans": "zh_CN", "zh_Hant": "zh_TW"]
    static var language: String {
        guard var pLanguages = preferredLanguages else {
            return ""
        }
        if pLanguages.count > 1 {
            pLanguages.removeLast()
        }
        let result = pLanguages.reduce("") { result, string -> String in
            if result.count > 0 {
                return "\(result)_\(string)"
            } else {
                return string
            }
        }
        if let replaceResult = finalLanguageCodes[result] {
            return replaceResult
        }
        return result
    }
    
    static var timeZone: String {
        TimeZone.current.identifier
    }
    
    private static var preferredLanguages: [String]? {
        if let preferredLanguages = Locale.preferredLanguages.first {
            return preferredLanguages.components(separatedBy: "-")
        }
        return nil
    }
    
    enum Widths: CGFloat {
        case inches4 = 320
        case inches47 = 375
        case inches55 = 414
    }
    
    enum Heights: CGFloat {
        case inches4 = 568
        case inches47 = 667
    }
    
    static func isSizeOrHeightLarger(height: Heights) -> Bool {
        UIScreen.main.bounds.size.height > height.rawValue
    }
    
    static func isSizeOrLarger(width: Widths) -> Bool {
        UIScreen.main.bounds.size.width > width.rawValue
    }
    
    static func isSizeEqual(width: Widths) -> Bool {
        UIScreen.main.bounds.size.width == width.rawValue
    }
    
    static func screenWidthSize() -> Widths {
        if UIScreen.main.bounds.size.width == Widths.inches4.rawValue {
            return .inches4
        } else if UIScreen.main.bounds.size.width == Widths.inches55.rawValue {
            return .inches55
        } else {
            return .inches47
        }
    }
    
    static func is47InchesHeightOrLarger() -> Bool {
        isSizeOrHeightLarger(height: .inches47)
    }
    static func is47InchesOrLarger() -> Bool {
        isSizeOrLarger(width: .inches47)
    }
    
    static func getIPAddress() -> String? {
        
        var address: String?
        
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                    
                }
            }
        }
        
        freeifaddrs(ifaddr)
        return address
        
    }
}
