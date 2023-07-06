//
//  StyleColor.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import Foundation
import UIKit

// MARK: - Color
// swiftlint:disable identifier_name

enum StyleColor: String, Style {
    /// rgb(47, 55, 79)
    case darkGreyBlue = "2f374f"
    /// rgb(67, 67, 67)
    case black_434343 = "434343"
    /// rgb(0, 0, 0)
    case black_000000 = "000000"
    /// rgb(34, 34, 34)
    case black_222222 = "222222"
    /// rgb(43, 43, 43)
    case black_2B2B2B = "2B2B2B"
    /// rgb(255, 255, 255)
    case white_FFFFFF = "ffffff"
    /// rgb(255, 58, 68)
    case red_FF3A44 = "Ff3A44"
    /// rgb(255, 55, 4)
    case red_FF3704 = "ff3704"
    /// rgb(255, 0, 8)
    case red_FF0008 = "ff0008"
    /// rgb(238, 121, 108)
    case red_EE796C = "ee796c"
    /// rgb(219, 20, 37)
    case lipstickRed_DB1425 = "db1425"
    /// rgb(0, 204, 108)
    case green_00CC6C = "00cc6c"
    /// rgb(36, 200, 117)
    case green_24C875 = "24c875"
    /// rgb(178, 235, 206)
    case green_B2EBCE = "B2Ebce"
    /// rgb(30, 170, 99)
    case green_1EAA63 = "1eaa63"
    /// rgb(0, 184, 197)
    case green_00B8C5 = "00b8c5"
    /// rgb(2, 191, 95)
    case green_02BF5F = "02BF5F"
    /// rgb(76, 217, 100)
    case green_4CD964 = "4CD964"
    /// rgb(97, 221, 177)
    case green_61DDB1 = "61DDB1"
    /// rgb(0, 122, 255)
    case blue_007AFF = "007aff"
    /// rgb(78, 147, 243)
    case blue_4E93F3 = "4E93F3"
    /// rgb(32, 164, 249)
    case blue_20A4F9 = "20a4f9"
    /// rgb(143, 180, 223)
    case blue_8FB4DF = "8FB4DF"
    /// rgb(80, 120, 242)
    case blue_5078F2 = "5078f2"
    /// rgb(127, 205, 255)
    case blue_7FCDFF = "7fcdff"
    /// rgb(93, 106, 141)
    case blue_5C6A8D = "5C6A8D"
    /// rgb(32, 164, 249)
    case blue_20a4f9 = "20A4F9"
    /// rgb(43, 0, 147)
    case blue_2B0093 = "2B0093"
    /// rgb(144, 96, 239)
    case purple_9060EF = "9060ef"
    /// rgb(255, 109, 193)
    case pink_FF6DC1 = "ff6dc1"
    /// rgb(255, 112, 102)
    case pink_FF7066 = "ff7066"
    /// rgb(155, 0, 255)
    case pink_9B00FF = "9b00ff"
    /// rgb(255, 126, 75)
    case orange_FF7E4B = "ff7e4b"
    /// rgb(254, 159, 58)
    case orange_FE9F3A = "fe9f3a"
    /// rgb(253, 205, 18)
    case yellow_FDCD12 = "fdcd12"
    /// rgb(188, 129, 97)
    case brown_BC8161 = "Bc8161"
    /// rgb(116, 95, 83)
    case brown_745F53 = "745F53"
    /// rgb(208, 208, 215)
    case gray_D0D0D7 = "d0d0d7"
    /// rgb(123, 127, 129)
    case gray_7B7F81 = "7B7F81"
    /// rgb(73, 76, 78)
    case gray_494C4E = "494C4E"
    /// rgb(242, 243, 250)
    case gray_F2F7FA = "F2F7FA"
    /// rgb(242, 243, 247)
    case gray_F2F3F7 = "F2F3F7"
    /// rgb(236, 236, 236)
    case gray_ECECEC = "Ececec"
    /// rgb(250, 250, 253)
    case gray_FAFAFD = "fafafd"
    /// rgb(151, 153, 158)
    case gray_97999E = "97999E"
    /// rgb(152, 151, 158)
    case gray_98979E = "98979E"
    /// rgb(208, 208, 213)
    case gray_D0D0D5 = "D0D0D5"
    /// rgb(193, 193, 193)
    case gray_C1C1C1 = "C1C1C1"
    /// rgb(199, 199, 205)
    case gray_C7C7CD = "C7C7CD"
    /// rgb(233, 233, 233)
    case gray_E9E9E9 = "E9E9E9"
    case gray_E7DFF1 = "E7DFF1"
    /// rgb(128, 130, 136)
    case gray_808288 = "808288"
    /// rgb(247, 248, 250), paleGreyFive
    case gray_F7F8FA = "F7F8FA"
    /// rgb(179, 181, 185)
    case gray_B3B5B9 = "B3B5B9"
    /// rgb(236, 237, 243)
    case gray_ECEDF3 = "ECEDF3"
    /// rgb(116, 118, 125)
    case gray_74767D = "74767d"
    /// rgb(122, 122, 122)
    case gray_7A7A7A = "7a7a7a"
    /// rgb(118, 118, 118)
    case gray_767676 = "767676"
    /// rgb(132, 132, 130)
    case gray_848482 = "848482"
    /// rgb(133, 144, 155)
    case gray_85909B = "85909B"
    /// rgb(231, 233, 241)
    case gray_B4B4BF = "B4B4BF"
    case paleLilac_E7E9F1 = "E7E9F1"
    /// rgb(238, 239, 242)
    case gray_EEEFF2 = "EEEFF2"
    /// rgb(229, 229, 229)
    case gray_E5E5E5 = "E5E5E5"
    /// rgb(239, 239, 241)
    case gray_EFEFF1 = "EFEFF1"
    /// rgb(248,248,248)
    case gray_F8F8F8 = "F8F8F8"
    /// rgb(240, 243, 245)
    case gray_F0F3F5 = "F0F3F5"
    /// rgb(93, 92, 99)
    case gray_5D5C63 = "5D5C63"
    /// rgb(237, 244, 250)
    case gray_EDF4FA = "EDF4FA"
    /// rgb(241, 241, 241)
    case lightgray_F1F1F1 = "F1F1F1"
    /// rgb(227, 229, 236)
    case paleLilac_E3E5EC = "e3e5ec"
    /// rgb(242, 243, 247)
    case paleGreyFour = "f2f3f7"
    case slateGray = "646569"
    /// rgb(255, 125, 127)
    case pink_FF7D7F = "ff7d7f"
    /// rgb(235, 235, 235)
    case gray_EBEBEB = "ebebeb"
    /// rgb(209, 211, 216)
    case bordergray_D1D3D8 = "d1d3d8"
    /// rgb(119, 130, 149)
    case steel_778295 = "778295"
    /// rgb (245, 247, 251)
    case blue_F5F7FB = "F5F7FB"
    /// rgb (232, 233, 236)
    case blue_E8E9EC = "E8E9EC"
    /// rgb (68 136 241)
    case dodgerBlue_4488F1 = "4488F1"
    /// amount cursor Color
    case amountCursor_278CFF = "5078F2"
    /// rgb(36, 200, 117)
    case algaeGreen_24C875 = "24C875"
    /// rgb(34,34,34)
    case black_343434 = "343434"
    /// rgb(51,51,51)
    case black_333333 = "333333"
    /// clear
    case clear = ""
    case offWhithe = "FDFEFD"
    var apply: UIColor {
        if case .clear = self { return .clear }
        return .hexadecimal(rawValue)
    }
    
    func apply(alpha: CGFloat) -> UIColor {
        if case .clear = self { return .clear }
        return .hexadecimal(rawValue, alpha)
        
    }
}
