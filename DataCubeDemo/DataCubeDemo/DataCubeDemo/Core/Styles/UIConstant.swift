//
//  UIConstant.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import Foundation
import UIKit

protocol ConstantProtocol {}
enum UIConstant: ConstantProtocol {
    static let enter: String = "\n"
    static let divide: String = "/"
    static let space: String = " "
    static let empty: String = ""
    static let dDay: String = "D-"
    static let leftParentheses: String = "("
    static let rightParentheses: String = ")"
    static let percent: String = "%"
    static let feeFree: String  = "0"
    static let monetary: String = "$"
    static let middleDot: String = " · "
    static let comma: String = ","
    static let plus: String = "+"
    static let minus: String = "-"
    static let tilde: String = "~"
    static let separator: String  = "#"
    static let bottomDot: String = "."
    static let bottomDotZero: String = ".0"
    static let astar: String = "*"
    static let bigCircle = "●"
    static let unknown = "__unknown__"
    static let null = "null"
    static let meter = "M"
    static let no = "N"
    static let numberZero: String = "0"
    static let point: String = "P"
    static let number1: String = "1"
    static let zeroPercent: String = "0%"
    static let zeroMontary: String = "$0"
    static let preset: String = "preset%d"
    static let autoDot: String = ". "
    static let inputMaxLength: Int = 100
    static let annualIncomeMaxLength: Int = 12
    static let ellipsisThree: String = "..."
    static let next: String = "Next"
}

extension UIConstant {
    static let hotKeyMoneyFirst: Int = 100
    static let hotKeyMoneySecond: Int = 500
    static let hotKeyMoneyThird: Int = 1000
    static let hotKeyMoneyFour: Int = 10000
    static let transferNoteMessageMax: Int = 10
    static let colorMax: Int = 10
    static let twoDigitCheck: Int = 10
    static let YearDay = 365
    static let YearDayNegative = -365
    static let bankCodeDivideCount: Int = 3
    static let fullbuttonThrottleTime: Int = 3
    static let transferScheduledTitleMax: Int = 10
    static let NinetyDay = 90
    static let NinetyDayNegative = -90
    static let maxAmount: Int = 1000000000
    static let keyBoardUpDelayTime: Double = 0.5
    static let accountLimitNumber = 5
}

extension UIConstant {
    static let zeroInsets: UIEdgeInsets = .zero
}

extension UIConstant {
    static let accountColorList = [
        StyleColor.green_24C875.apply, StyleColor.green_00B8C5.apply, StyleColor.blue_20A4F9.apply,
        StyleColor.blue_5078F2.apply, StyleColor.purple_9060EF.apply, StyleColor.pink_FF6DC1.apply,
        StyleColor.pink_FF7066.apply, StyleColor.orange_FF7E4B.apply, StyleColor.orange_FE9F3A.apply,
        StyleColor.yellow_FDCD12.apply, StyleColor.brown_BC8161.apply, StyleColor.brown_745F53.apply,
        StyleColor.gray_7B7F81.apply, StyleColor.gray_494C4E.apply
    ]
}
