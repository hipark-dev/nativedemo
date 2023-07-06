//
//  DateFormatUtil+Constants.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import Foundation

enum DateStringFormat: String {
    case yyyyMMdd = "yyyyMMdd"
    case yyyyMMddWithDot = "yyyy.MM.dd"
    case yyyyMMddHHmmWithDot = "yyyy.MM.dd HH:mm"
    case yyyyMMddHHmmssWithDot = "yyyy.MM.dd HH:mm:ss"
    case yyyy年MM月dd日 = "yyyy年MM月dd日"
    case yyyy年MM月dd日HHmm = "yyyy年MM月dd日HH:mm"
    case yyyyMM = "yyyyMM"
    case yyyyMMWithDot = "yyyy.MM"
    case yyyy = "yyyy"
    case yyMMdd = "yyMMdd"
    case mmdd = "MMdd"
    case mmddWithDot = "MM.dd"
    case mmddWithColon = "MM:dd"
    case mmddWithSlash = "MM/dd"
    case HH = "HH"
    case MM = "MM"
    case MMM = "MMM"
    case mm = "mm"
    case dd = "dd"
    case mWithoutZero = "M"
    case dWithoutZero = "d"
    case m月d日 = "M月d日"
    case m月 = "M月"
    case normal = "yyyy-MM-dd hh:mm:ss"
    case yyyyMMddhhmmss = "yyyyMMddhhmmss"
    case yyyyMMddHHmmss = "yyyyMMddHHmmss"
    case yyyyMMddHHmmddWithTimezone = "yyyy-MM-dd'T'HH:mm:ddZZZZZ"
    case hhmmWithColon = "HH:mm"
    case cardExpirry = "MM / YY"
    var localizedString: String {
        rawValue
    }
    
}

enum WeekDay: EnumCollection {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}
