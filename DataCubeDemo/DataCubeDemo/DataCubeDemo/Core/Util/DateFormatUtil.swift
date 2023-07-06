//
//  DateFormatter.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import Foundation

class DateFormatUtil {
    //issue: invalid TimeZone.current on ios 10
    // TODO: check line 82 issues on iOS ver >= 11.0
    enum Constants {
        static let yearInMonthMax: Int = 12
        static let limitYear: Int = 10
        static let monthInDayMax: Int = 31
        static let monthInit: Int = 1
        static let weekExceptionDay: Int = 8
        static let DateInit: Int = 1
        static let DateAdd: Int = 1
        static let weekDayAdd: Int = 7
    }
    
    static var currentTimeZone: TimeZone {
        TimeZone.current
    }
    
    static var dateFormatter: DateFormatter {
        DateFormatter().apply {
            $0.calendar = Calendar(identifier: .gregorian)
            $0.timeZone = DateFormatUtil.currentTimeZone
        }
    }
    static func string(_ date: Date, _ format: DateStringFormat) -> String {
        let dateFormatter = DateFormatUtil.dateFormatter
        dateFormatter.dateFormat = format.localizedString
        return dateFormatter.string(from: date)
    }
    static func date(_ string: String, _ format: DateStringFormat) -> Date {
        let dateFormatter = DateFormatUtil.dateFormatter
        dateFormatter.dateFormat = format.localizedString
        guard let date = dateFormatter.date(from: string) else {
            assertionFailure("Date format doesn't match. Check your date type or API.")
            return Date()
        }
        return date
    }

    static func isValidDate(_ date: Date) -> Bool {
        if date < minimumDate || date > maximumDate {
            return false
        }
        
        return true
    }
    
    static var calendarMaximumYear: Int {
        let maxDisplayYear = 82
        let calendar = Calendar(identifier: .gregorian)
        let currentYear = calendar.component(.year, from: Date())
        return currentYear + maxDisplayYear
    }
    
    static let minimumDate = "20000101".date(.yyyyMMdd)
    static let maximumDate = "\(DateFormatUtil.calendarMaximumYear)1231".date(.yyyyMMdd)
}
