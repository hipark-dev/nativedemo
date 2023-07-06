//
//  Enviroment.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit

struct Environment {
    
    static var bundleVersion: String = {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }()
    
    static var buildVersion: String = {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }()
    
    static var debugTargetServer: String = {
        Bundle.main.infoDictionary?["DebugTargetServer"] as? String ?? ""
    }()
    
    static var debugTargetTmsUrl: String = {
        Bundle.main.infoDictionary?["DebugTargetTms"] as? String ?? ""
    }()
    
    static var debugTargetSfsUrl: String = {
        Bundle.main.infoDictionary?["DebugTargetSfs"] as? String ?? ""
    }()
    
    static var debugTargetVideoCall: String = {
        Bundle.main.infoDictionary?["DebugTargetVideoCall"] as? String ?? ""
    }()
    
    static var debugTargetVideoCallGateway: String = {
        Bundle.main.infoDictionary?["DebugTargetVideoCallGateway"] as? String ?? ""
    }()
    
    static var appVersion: String = {
        return Environment.bundleVersion
    }()
    
    static var displayName: String = {
        Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
    }()
    static var uuid: String = {
        UUID().uuidString
    }()
    static var vendorUuid: String = {
        UIDevice.current.identifierForVendor?.uuidString ?? ""
    }()

    static var lineChannelId: String = {
        guard let channelId = lineConfig["ChannelID"] as? String else {
            fatalError("You must be check to LineConfig.ChannelID in Info.plist")
        }
        
        return channelId
    }()

    static var lineChannelAppId: String = {
        guard let channelId = lineConfig["ChannelAppID"] as? String else {
            fatalError("You must be check to LineConfig.ChannelAppID in Info.plist")
        }

        return channelId
    }()

    static var lineAppSchemeName: String? = {
        Bundle.main.infoDictionary?["LineAppScheme"] as? String
    }()

    static var clientInfo: String = {
        "\(Environment.displayName)/\(Environment.appVersion)/\(UIDevice.current.systemName)/\(UIDevice.current.systemVersion)"
    }()
    
    static var bundleId: String {
        return (bundleIdConfig["developement"] as? String) ?? ""
    }

    static var bundleIdConfig: [String: Any] = {
        guard let config = Bundle.main.infoDictionary?["BundleIdConfig"] as? [String: Any] else {
            fatalError("You must be check to BundleIdConfig in Info.plist")
        }

        return config
    }()

    static var lineConfig: [String: AnyObject] = {
        Bundle.main.infoDictionary?["LineConfig"] as? Dictionary ?? [:]
    }()

    static var googleMapApiKey: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "GoogleMapAPIKey") as? String else {
            fatalError("You must be check to GoogleMapAPIKey in Info.plist")
        }

        return key
    }()

    static var appUniversalURL: URL? = {
        guard
            let appLinkDomain = Bundle.main.infoDictionary?["APPLINK_DOMAIN"] as? String,
            let univeralURL = URL(string: "https://\(appLinkDomain)")
        else {
            return nil
        }
        return univeralURL
    }()

    static var lineAuthUniversalURL: URL? = {
        Environment.appUniversalURL?.appendingPathComponent("/line-auth/")
    }()
    
    static var infoDictionary: [String: Any]? { Bundle.main.infoDictionary }
    
    enum BuildPhase {
        case dev
        case rc
        case beta
        case real
    }
}
