//
//  Device+Size.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 24/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

enum DeviceScreenSize {
    case iphone5
    case iphone6
    case iphone6Plus
    case iphoneX
    case unknown
}

extension UIDevice {
    
    class func getDeviceScreenSize() -> DeviceScreenSize {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                return DeviceScreenSize.iphone5
            case 1334:
                return DeviceScreenSize.iphone6
            case 2208:
                return DeviceScreenSize.iphone6Plus
            case 2436:
                return DeviceScreenSize.iphoneX
            default:
                return DeviceScreenSize.unknown
            }
        } else {
            return DeviceScreenSize.unknown
        }
    }
}
