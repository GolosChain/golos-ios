//
//  UIColor+Extensions.swift
//  Golos
//
//  Created by msm72 on 26.05.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//  https://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values

import Foundation
import SwiftTheme

let whiteColorPickers: ThemeColorPicker             =   [ "#ffffff", "#ffffff" ]
let whiteBlackColorPickers: ThemeColorPicker        =   [ "#ffffff", "#000000" ]
let blackWhiteColorPickers: ThemeColorPicker        =   [ "#000000", "#ffffff" ]
let darkGrayWhiteColorPickers: ThemeColorPicker     =   [ "#7d7d7d", "#ffffff" ]
let veryDarkGrayWhiteColorPickers: ThemeColorPicker =   [ "#333333", "#ffffff" ]
let vividBlueWhiteColorPickers: ThemeColorPicker    =   [ "#1298ff", "#1298ff" ]
let darkModerateBlueColorPickers: ThemeColorPicker  =   [ "#4469af", "#4469af" ]



extension UIColor {
    static var myAppRed: UIColor {
        return UIColor(red: 1, green: 0.1, blue: 0.1, alpha: 1)
    }
    static var myAppGreen: UIColor {
        return UIColor(red: 0, green: 1, blue: 0, alpha: 1)
    }
    static var myAppBlue: UIColor {
        return UIColor(red: 0, green: 0.2, blue: 0.9, alpha: 1)
    }

    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        
        Scanner(string: hex).scanHexInt32(&int)
        let alpha, red, green, blue: UInt32
        
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha) / 255)
    }
}
