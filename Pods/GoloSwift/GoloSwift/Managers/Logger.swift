//
//  Logger.swift
//  GoloSwift
//
//  Created by msm72 on 27.02.2018.
//  Copyright © 2018 Golos.io. All rights reserved.
//
//  https://medium.com/@sauvik_dolui/developing-a-tiny-logger-in-swift-7221751628e6
//

import Foundation

public enum LogEvent: String {
    case error      =   "[‼️]"
    case info       =   "[ℹ️]"          // for guard & alert & route
    case debug      =   "[💬]"          // tested values & local notifications
    case verbose    =   "[🔬]"          // current values
    case warning    =   "[⚠️]"
    case severe     =   "[🔥]"          // tokens & keys & init & deinit
}

public class Logger {
    // MARK: - Properties
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    
    static var dateFormatter: DateFormatter {
        let formatter           =   DateFormatter()
        formatter.dateFormat    =   dateFormat
        formatter.locale        =   Locale.current
        formatter.timeZone      =   TimeZone.current
        
        return formatter
    }
    
    
    // MARK: - Class Functions
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        
        return components.isEmpty ? "" : components.last!
    }
    
    // message:     This will be the debug message to appear on the debug console.
    // event:       Type of event as cases of LogEvent enum.
    // fileName:    The file name from where the log will appear.
    // line:        The line number of the log message.
    // column:      The same will happen for this parameter too.
    // funcName:    The default value of this parameter is the signature of the function from where the log function is getting called.
    public class func log(message: String, event: LogEvent, fileName: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if appBuildConfig != .release {
            print("\(Date().toString()) \(event.rawValue)[\(sourceFileName(filePath: fileName))]:\(line) \(column) \(funcName) -> \(message)")
        }
    }
}


extension Date {
    func toString() -> String {
        return Logger.dateFormatter.string(from: self as Date)
    }
}
