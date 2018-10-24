//
//  Date+Extensions.swift
//  GoloSwift
//
//  Created by msm72 on 06.05.2018.
//  Copyright © 2018 Golos.io. All rights reserved.
//

import Foundation

public enum DateFormatType: String {
    case commentDate                =   "dd-MM-yyyy"
    case expirationDateType         =   "yyyy-MM-dd'T'HH:mm:ss"
}

extension Date {
    public func convert(toStringFormat dateFormatType: DateFormatType) -> String {
        let dateFormatter           =   DateFormatter()
        dateFormatter.dateFormat    =   dateFormatType.rawValue
        dateFormatter.timeZone      =   TimeZone(identifier: "UTC")
        
        return dateFormatter.string(from: self)
    }
    
    // Issue #129
    public func convertToTimeAgo() -> String {
        let dateComponents          =   Calendar.current.dateComponents([ .year, .month, .day, .hour, .minute, .second ], from: self, to: Date())
        
        // Date in format '25-02-1972'
        if let days = dateComponents.day, days > 7, let month = dateComponents.month, let year = dateComponents.year {
            return String(format: "%d-%d-%d", days, month, year)
        }
            
        // Date in format 'N days ago'
        else if let days = dateComponents.day, 1...7 ~= days {
            return String(format: "%d %@", days, days.localized(byTimeMode: .days))
        }
        
        // Date in format 'N hours/minutes/seconds ago'
        if let days = dateComponents.day, days == 0, let hours = dateComponents.hour, let minutes = dateComponents.minute, let seconds = dateComponents.second {
            if hours > 0 {
                return String(format: "%d %@", hours, hours.localized(byTimeMode: .hours))
            }
                
            else if minutes > 0 {
                return String(format: "%d %@", minutes, minutes.localized(byTimeMode: .minutes))
            }
                
            else {
                return String(format: "%d %@", seconds, seconds.localized(byTimeMode: .seconds))
            }
        }
        
        return String(format: "%@", self.convert(toStringFormat: .commentDate))
    }
    
    
    /// Convet Date to 'days ago'
    public func convertToDaysAgo(dateFormatType: DateFormatType) -> String {
        let dateFormatter           =   DateFormatter()
        dateFormatter.dateFormat    =   dateFormatType.rawValue
        dateFormatter.timeZone      =   TimeZone(identifier: "UTC")
        let days                    =   Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
        
        return String(format: "%@", days == 0 ? "Today ago".localized() : "\(days) " + "Days ago".localized())
    }
}
