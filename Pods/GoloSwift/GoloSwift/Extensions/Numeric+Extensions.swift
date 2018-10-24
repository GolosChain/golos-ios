//
//  Numeric+Extensions.swift
//  GoloSwift
//
//  Created by msm72 on 04.05.2018.
//  Copyright © 2018 Golos.io. All rights reserved.
//

import Foundation

public enum TimeMode {
    case days
    case hours
    case minutes
    case seconds
}

extension Numeric {
    var data: Data {
        var source = self
        // This will return 1 byte for 8-bit, 2 bytes for 16-bit, 4 bytes for 32-bit and 8 bytes for 64-bit binary integers.
        // For floating point types it will return 4 bytes for single-precision, 8 bytes for double-precision and 16 bytes for extended precision.
        return Data(bytes: &source, count: MemoryLayout<Self>.size)
    }
}


extension UInt16 {
    var bytesReverse: [Byte] {
        return [UInt8(truncatingIfNeeded: self), UInt8(truncatingIfNeeded: self >> 8)]
    }
    
    var bytesDirect: [Byte] {
        return [UInt8(truncatingIfNeeded: self >> 8), UInt8(truncatingIfNeeded: self)]
    }
}


extension UInt32 {
    var bytesReverse: [Byte] {
        return [UInt8(truncatingIfNeeded: self), UInt8(truncatingIfNeeded: self >> 8), UInt8(truncatingIfNeeded: self >> 16), UInt8(truncatingIfNeeded: self >> 24)]
    }
    
    var bytesDirect: [Byte] {
        return [UInt8(truncatingIfNeeded: self >> 24), UInt8(truncatingIfNeeded: self >> 16), UInt8(truncatingIfNeeded: self >> 8), UInt8(truncatingIfNeeded: self)]
    }
}


extension Int {
    public func localized(byTimeMode timeMode: TimeMode) -> String {
        let time = self % 20
        
        switch timeMode {
        case .days:
            switch time {
            case 1:
                return "1 Day Ago".localized()
                
            case 2...4:
                return "2-4 Days Ago".localized()
                
            case 5...20:
                return "Less 20 Days Ago".localized()
                
            default:
                return (self == 0 ? "Today Ago" : "Less 20 Days Ago").localized()
            }
            
        case .hours:
            switch time {
            case 1:
                return "1 Hour Ago".localized()
                
            case 2...4:
                return "2-4 Hours Ago".localized()
                
            case 5...20:
                return "Less 20 Hours Ago".localized()
                
            default:
                return (self == 0 ? "Today Ago" : "Less 20 Hours Ago").localized()
            }
            
        case .minutes:
            switch time {
            case 1:
                return "1 Minute Ago".localized()
                
            case 2...4:
                return "2-4 Minutes Ago".localized()
                
            case 5...20:
                return "Less 20 Minutes Ago".localized()
                
            default:
                return (self == 0 ? "Today Ago" : "Less 20 Minutes Ago").localized()
            }
            
        default:
            switch time {
            case 1:
                return "1 Second Ago".localized()
                
            case 2...4:
                return "2-4 Seconds Ago".localized()
                
            case 5...20:
                return "Less 20 Seconds Ago".localized()
                
            default:
                return (self == 0 ? "Today Ago" : "Less 20 Seconds Ago").localized()
            }
        }
    }
}
