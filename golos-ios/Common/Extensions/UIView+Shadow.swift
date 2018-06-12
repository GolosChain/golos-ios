//
//  UIView+Shadow.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 24/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import SwiftTheme

enum SideType {
    case top
    case left
    case right
    case bottom
    case around
}

extension UIView {
    func tune() {
        ThemeManager.setTheme(index: isAppThemeDark ? 1 : 0)
        self.theme_backgroundColor  =   whiteBlackColorPickers
    }

    func add(shadow: Bool, onside: SideType) {
        layer.shadowColor           =   shadow ? UIColor.lightGray.cgColor : UIColor.white.cgColor
        layer.shadowOpacity         =   shadow ? 4.0 : 0.0
        layer.shadowRadius          =   shadow ? 4.0 : 0.0
        layer.masksToBounds         =   false
        layer.shouldRasterize       =   true
        
        guard shadow else {
            layer.shadowOffset      =   .zero
            return
        }
        
        switch onside {
        case .top:
            layer.shadowOffset      =   CGSize(width: 0, height: -4)

        case .left:
            layer.shadowOffset      =   CGSize(width: -4, height: 0)
            
        case .right:
            layer.shadowOffset      =   CGSize(width: 4, height: 0)
            
        case .bottom:
            layer.shadowOffset      =   CGSize(width: 0, height: 4)
            
        case .around:
            layer.shadowOffset      =   .zero
        }
    }
}
