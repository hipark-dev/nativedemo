//
//  Fido.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/10/04.
//

import Foundation
import UIKit

typealias FidoParameter = [String: String]
typealias FidoUrl = (request: String, response: String)

enum FidoConstant: ConstantProtocol {
    
    static let fidoServerURL: String = "https://ipnft-trade.fingerservice.co.kr:8000/MagicFIDO2Server"
    static let fidoRequest: String   = "/processUafRequest.jspx?site="
    static let fidoResponse: String  = "/processUafResponse.jspx?site="
    
    static let patternURL: String = "www.pattern.com"
    static let pinURL: String     = "www.pin.com"
    static let bioURL: String     = "www.finger.com"
    
    static let UserID: String     = "userName"
}

enum LoginType: Equatable {
    case None
    case Email
    case Fido
    
    var identifier: String {
        String(describing: self)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.identifier == rhs.identifier
    }
}

enum FidoType: Equatable {
    case Pin
    case Pattern
    case Biometric
    
    var identifier: String {
        String(describing: self)
    }
    
    var fidoUrl: FidoUrl {
        let defaultRequestDomain: String = FidoConstant.fidoServerURL + FidoConstant.fidoRequest
        let defaultResponseDomain: String = FidoConstant.fidoServerURL + FidoConstant.fidoResponse
        switch self {
        case .Biometric:
            return (defaultRequestDomain + FidoConstant.bioURL, defaultResponseDomain + FidoConstant.bioURL)
        case .Pin:
            return (defaultRequestDomain + FidoConstant.pinURL, defaultResponseDomain + FidoConstant.pinURL)
        case .Pattern:
            return (defaultRequestDomain + FidoConstant.patternURL, defaultResponseDomain + FidoConstant.patternURL)
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.identifier == rhs.identifier
    }
}

class Fido {
    typealias JsonParameter = Dictionary<String, Any>
    static func initialize() {
        
        if MagicFidoUtil.isAvailableFIDO(.PATTERN_TYPE) {
            /***********************************
             *  패턴이 사용 가능할 경우 패턴 옵션 설정
             ***********************************/
            Fido.patternOptionsSetting()
        }
        
        if (MagicFidoUtil.isAvailableFIDO(.PASSCODE_TYPE)) {
            /***********************************
             *  패스코드가 사용 가능할 경우 패스코드 옵션 설정
             ***********************************/
            Fido.passcodeOptionsSetting()
            //패스코드 인증장치의 UI Type을 설정
            MagicFidoUtil.setPasscodeUIType(.PASSCODE_PIN6)
        }
        
        // 인증장치(패스코드, 패턴) 락 걸렸을 경우 재등록 버튼 활성화
//        MagicFidoUtil.setAuthenticatorResetCallbackEnable(true)
        
        // 보안키패드의 VoiceOver 스피커 모드를 설정
//        MagicFidoUtil.setKeypadAccessibilityOnSpeakerEnable(true)
//        var ignore = Dictionary<String, String>()
//        ignore["900101"] = "생년월일은 비밀번호로 설정이 불가능합니다."
//        ignore[KEY_ASCENDING_DESCENDING] = "오름차순과 내림차순은 비밀번호로 설정이 불가능합니다."
//        MagicFidoUtil.setPasscodeIgnoreList(ignore)
        
        // 생체인증 배경화면의 타이틀 설정
//        MagicFidoUtil.setBiometryVerificationTitle("테스트타이틀")
        
    }
    
    static func patternOptionsSetting() {
        var dic = JsonParameter()
        dic[KEY_MINIMUM_NODE_COUNT] = NSNumber(value: 4)
        dic[KEY_NODE_SIZE_WIDTH] = NSNumber(value: 80)
        dic[KEY_NODE_IMAGE_DEFAULT] = "pattern_btn_touched"
        dic[KEY_NODE_IMAGE_SELECTED] = "pattern_btn_touched_ov"
        dic[KEY_NODE_IMAGE_MISMATCH] = "pattern_btn_red"
        dic[KEY_LINE_WIDTH] = NSNumber(value: 6)
        dic[KEY_LINE_COLOR] = UIColor.green
        dic[KEY_MISMATCH_LINE_COLOR] = UIColor.red
        dic[KEY_RETRY_COUNT_TO_LOCK] = NSNumber(value: 5)
        dic[KEY_LOCK_TIME] = NSNumber(value: 30)
        dic[KEY_MAX_LOCK_COUNT] = NSNumber(value: 3)
        
        MagicFidoUtil.setAuthenticatorOptions(dic, authenticatorType: .PATTERN_TYPE)
    }
    
    static func passcodeOptionsSetting() {
        var dic = Dictionary<String, Any>()
        dic[KEY_RETRY_COUNT_TO_LOCK] = NSNumber(value: 5)
        dic[KEY_LOCK_TIME] = NSNumber(value: 30)
        dic[KEY_MAX_LOCK_COUNT] = NSNumber(value: 3)
        dic[KEY_MIN_LENGTH] = NSNumber(value: 4)
        dic[KEY_MAX_LENGTH] = NSNumber(value: 8)
        dic[KEY_USE_NUMBER_KEYPAD] = NSNumber(value: true)
        
        MagicFidoUtil.setAuthenticatorOptions(dic, authenticatorType: .PASSCODE_TYPE)
    }
}
