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
    
    public func convertToDaysAgo() -> String {
        let dateComponents          =   Calendar.current.dateComponents([ .day ], from: self, to: Date())
        
        guard let day = dateComponents.day, day > 0 else {
            return "Today ago".localized()
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
