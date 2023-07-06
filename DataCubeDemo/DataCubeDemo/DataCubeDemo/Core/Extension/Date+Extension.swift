//
//  Date+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit
import Foundation

extension Date {
    var millisecondsSince1970: TimeInterval {
        (timeIntervalSince1970 * 1000.0).rounded()
    }
}

extension Date {
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date? {
        get(.forward, weekday, considerToday: considerToday)
    }
    
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date? {
        get(.backward, weekday, considerToday: considerToday)
    }
    
    func get(_ direction: Calendar.SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date? {
        
        let weekdayIndex = weekDay.rawValue
        let calendar = Calendar.current
        
        if consider && calendar.component(.weekday, from: self) == weekdayIndex {
            return self
        }
        
        var nextDateComponent = DateComponents()
        nextDateComponent.weekday = weekdayIndex
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction)
        return date
    }
    
    enum Weekday: Int {
        case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    }
    
    enum Constants {
        static let hourIntervalValue: Double = 60
        static let minuteIntervalValue: Double = 3600
        static let dayIntervalValue: Double = 86400
    }
}
extension Date: HasLet, HasApply {    
}

extension Date {
    var day: Int {
        Calendar.current.component(.day, from: self)
    }
   
    var month: Int {
        Calendar.current.component(.month, from: self)
    }
    
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
    
    var hour: Int {
        Calendar.current.component(.hour, from: self)
    }
    
    var minute: Int {
        Calendar.current.component(.minute, from: self)
    }
    
    var second: Int { Calendar.current.component(.second, from: self) }
    
    var sunday: Bool {
        weekDay() == .sunday
    }
    
    var laterThanToday: Bool {
        self > Date() ? true : false
    }
    
    func earlierThanToday(by limit: Int) -> Bool {
        guard let distance = totalDistance(from: Date(), resultIn: .day) else { return false }
        return limit < distance
    }
    
    func string(_ format: DateStringFormat = DateStringFormat.yyyyMMddHHmmWithDot) -> String {
        DateFormatUtil.string(self, format)
    }
    
    func weekDay() -> WeekDay {
        var calendar = Calendar.current
        calendar.timeZone = DateFormatUtil.currentTimeZone
        let weekday = calendar.component(.weekday, from: self) - 1
        
        return WeekDay.allCases[weekday]
    }
    
    func after(month: Int) -> Date? {
        Calendar.current.date(byAdding: .month, value: month, to: self)
    }
    
    func after(day: Int) -> Date? {
        Calendar.current.date(byAdding: .day, value: day, to: self)
    }
    
    func before(month: Int) -> Date? {
        Calendar.current.date(byAdding: .month, value: -month, to: self)
    }
    
    func before(day: Int) -> Date? {
        Calendar.current.date(byAdding: .day, value: -day, to: self)
    }
        
    func dDay() -> String {
        let diff = self.timeIntervalSince(Date())
        let day = Date(timeIntervalSinceNow: diff)
        return DateFormatUtil.string(day, DateStringFormat.dWithoutZero) 
    }
    
    func isDaySinceNow(_ distanceDay: Int) -> Bool {
        let interval = self.timeIntervalSince(Date())
        let day = abs(Int(interval / Constants.dayIntervalValue))
        return (day < distanceDay ? true : false)
    }
    
    var firstDayOfMonth: Date? {
        before(day: day - 1)
    }
    
    var lastDayOfMonth: Date? {
        after(month: 1)?.firstDayOfMonth?.before(day: 1)
    }
}

extension Date {
    func startOfMonth(_ calendar: Calendar = Calendar.current) -> Date? {
        calendar.date(from: calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: self)))
    }
    
    func endOfMonth(_ calendar: Calendar = Calendar.current) -> Date? {
        guard let startOfMonth = self.startOfMonth(calendar) else {
            return nil
        }
        return calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)
    }
    
    func nextMonth(_ calendar: Calendar = Calendar.current) -> Date? {
        calendar.date(byAdding: DateComponents(month: 1), to: self)
    }
    
    func nextMonth(to: Int) -> Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: DateComponents(month: to), to: self)
    }
    
    func previousMonth(_ calendar: Calendar = Calendar.current) -> Date? {
        calendar.date(byAdding: DateComponents(month: -1), to: self)
    }
    
    func previousMonth(previousMonth: Int) -> Date? {
        let calendar: Calendar = Calendar.current
        return calendar.date(byAdding: DateComponents(month: -previousMonth), to: self)
    }
    
    func sameDayWith(date: Date, _ calendar: Calendar = Calendar.current) -> Bool {
        calendar.isDate(self, inSameDayAs: date)
    }
    
    func sameMonthWith(date: Date, _ calendar: Calendar = Calendar.current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: .month)
    }
    
    func compare(with date: Date, only component: Calendar.Component) -> Int {
        let days1 = Calendar.current.component(component, from: self)
        let days2 = Calendar.current.component(component, from: date)
        return days1 - days2
    }
    
    func totalDistance(from date: Date, resultIn component: Calendar.Component) -> Int? {
        Calendar.current.dateComponents([component], from: self, to: date).value(for: component)
    }
    
    func adjustEndDayOfMonth(_ day: Int) -> Int {
        guard let endOfMonth = self.endOfMonth() else {
            return day
        }
        
        guard let lastDay: Int = Calendar.current.dateComponents([.day], from: endOfMonth).day else {
            return day
        }
        
        if day > lastDay {
            return lastDay
        }
        return day
    }
    
    func daysInMonth(_ monthNumber: Int? = nil, _ year: Int? = nil) -> Int {
        var dateComponents = DateComponents()
        dateComponents.year = year ?? Calendar.current.component(.year, from: self)
        dateComponents.month = monthNumber ?? Calendar.current.component(.month, from: self)
        if
            let day = Calendar.current.date(from: dateComponents),
            let interval = Calendar.current.dateInterval(of: .month, for: day),
            let days = Calendar.current.dateComponents([.day], from: interval.start, to: interval.end).day
        { return days } else { return -1 }
    }
}

extension Date {

    var stringD: String {
        "\(day)"
    }

    var stringDD: String {
        String(format: "%02d", day)
    }
    
    var stringM: String {
        "\(month)"
    }

    var stringMM: String {
        String(format: "%02d", month)
    }
    
    var stringYYYY: String {
        "\(year)"
    }
    
    var stringHH: String {
        String(format: "%02d", hour)
    }

    var stringmm: String {
        String(format: "%02d", minute)
    }
    
    var stringss: String { "\(second)" }

    var monthShortName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }

    var monthFullName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    
    var suffixMonth: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        numberFormatter.locale = Locale.current

        return numberFormatter.string(for: month) ?? ""
    }
}
