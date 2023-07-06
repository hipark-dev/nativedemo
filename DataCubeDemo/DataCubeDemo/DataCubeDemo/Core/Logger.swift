//
//  Logger.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/14.
//

import SwiftyBeaver
import SwiftyUserDefaults
import FirebaseCrashlytics

class Logger: SwiftyBeaver {
    static func configurations() {
        var minLevel: (console: Level, file: Level, crashlytics: Level) {
            switch BuildConfig.type {
            case .real:
                return (console: .error, file: .error, crashlytics: .error)
            default:
                return (console: .debug, file: .debug, crashlytics: .info)
            }
        }
        
        let consoleDestination = ConsoleDestination()
        consoleDestination.minLevel = minLevel.console
        Logger.addDestination(consoleDestination)

        let crashlyticsDestination = CrashlyticsDestination()
        crashlyticsDestination.minLevel = minLevel.crashlytics
        Logger.addDestination(crashlyticsDestination)
        
    }
}

class CrashlyticsDestination: BaseDestination {
    override func send(
        _ level: SwiftyBeaver.Level,
        msg traceMessage: String,
        thread traceThread: String,
        file traceFile: String,
        function traceFunction: String,
        line traceLine: Int,
        context _: Any? = nil
    ) -> String? {
        if level.rawValue >= SwiftyBeaver.Level.info.rawValue {
            let userInfo: [String: Any] = [
                "Level": level.rawValue,
                "Msg": traceMessage,
                "File": traceFile,
                "Function": traceFunction,
                "Line": traceLine
            ]
            //CLSLogv("%@", getVaList([userInfo]))
        }
        return super.send(
            level,
            msg: traceMessage,
            thread: traceThread,
            file: traceFile,
            function: traceFunction,
            line: traceLine
        )
    }
}

