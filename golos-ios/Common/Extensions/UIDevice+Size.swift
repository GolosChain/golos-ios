//
//  Device+Size.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 24/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

enum DeviceScreenSize {
    case iPhone4s
    case iPhone5
    case iPhone6
    case iPhone6Plus
    case iPhoneX
    case unknown
}

extension UIDevice {
    class func getDeviceScreenSize() -> DeviceScreenSize {
        if UIDevice.current.userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 960:
                return DeviceScreenSize.iPhone4s
                
            case 1136:
                return DeviceScreenSize.iPhone5
            
            case 1334:
                return DeviceScreenSize.iPhone6
            
            case 2208:
                return DeviceScreenSize.iPhone6Plus
            
            case 2436:
                return DeviceScreenSize.iPhoneX
            
            default:
                return DeviceScreenSize.unknown
            }
        }
        
        else {
            return DeviceScreenSize.unknown
        }
    }
}
