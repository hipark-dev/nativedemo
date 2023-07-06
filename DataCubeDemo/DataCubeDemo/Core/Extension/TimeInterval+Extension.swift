//
//  TimeInterval+Extension.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import UIKit

extension TimeInterval {
    enum Precision {
        case hours, minutes, seconds, milliseconds
    }
    
    var convertDate: Date {
       Date(timeIntervalSince1970: self / 1000)
    }
    
    func toString(precision: Precision) -> String? {
        guard self > 0 && self < Double.infinity else {
            assertionFailure("wrong value")
            return nil
        }

        let time = NSInteger(self)

        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)

        switch precision {
        case .hours:
            return String(format: "%0.2d", hours)
        case .minutes:
            return String(format: "%0.2d:%0.2d", hours, minutes)
        case .seconds:
            return String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
        case .milliseconds:
            return String(format: "%0.2d:%0.2d:%0.2d.%0.3d", hours, minutes, seconds, ms)
        }
    }
}
