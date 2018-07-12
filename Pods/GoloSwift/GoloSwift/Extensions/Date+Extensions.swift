//
//  Date+Extensions.swift
//  GoloSwift
//
//  Created by msm72 on 06.05.2018.
//  Copyright © 2018 Golos.io. All rights reserved.
//

import Foundation

public enum DateFormatType: String {
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
        let daysString              =   dateComponents.day == 0 ?   "Today ago".localized() :
            String(format: "%i %@", dateComponents.day!, "Days ago".localized())
        
        return daysString
    }
}
