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

    func display(withTopConstraint topConstraint: NSLayoutConstraint, height: CGFloat, isShow: Bool) {
//        guard (self.alpha == 0.0 && isShow) || (self.alpha == 1.0 && !isShow) else {
//            return
//        }
        
        UIView.animate(withDuration: 0.3, animations: {
            topConstraint.constant  =   height * (isShow ? 1 : -1)
            self.alpha              =   isShow ? 1.0 : 0.0
        })
    }
    
    func add(shadow: Bool, onside: SideType) {
        layer.shadowColor           =   shadow ? UIColor.lightGray.cgColor : UIColor.white.cgColor
        layer.shadowOpacity         =   Float((shadow ? 4.0 : 0.0) * heightRatio)
        layer.shadowRadius          =   (shadow ? 4.0 : 0.0) * heightRatio
        layer.masksToBounds         =   false
        layer.shouldRasterize       =   true
        
        guard shadow else {
            layer.shadowOffset      =   .zero
            return
        }
        
        switch onside {
        case .top:
            layer.shadowOffset      =   CGSize(width: 0, height: -4.0 * heightRatio)

        case .left:
            layer.shadowOffset      =   CGSize(width: -4, height: 0.0)
            
        case .right:
            layer.shadowOffset      =   CGSize(width: 4, height: 0.0)
            
        case .bottom:
            layer.shadowOffset      =   CGSize(width: 0, height: 4.0 * heightRatio)
            
        case .around:
            layer.shadowOffset      =   .zero
        }
    }
}
