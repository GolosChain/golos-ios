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
    
    func tune(withThemeColorPicker themeColorPicker: ThemeColorPicker) {
        self.theme_backgroundColor  =   themeColorPicker
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
        layer.backgroundColor       =   shadow ? UIColor.lightText.cgColor : UIColor.white.cgColor
        layer.shadowColor           =   shadow ? UIColor.gray.cgColor : UIColor.white.cgColor
        layer.shadowOpacity         =   shadow ? 1.0 : 0.0
        layer.shadowRadius          =   shadow ? 1.5 : 0.0
        layer.masksToBounds         =   false
        layer.shouldRasterize       =   true
        
        guard shadow else {
            layer.shadowOffset      =   .zero
            return
        }
        
        switch onside {
        case .top:
            layer.shadowOffset      =   CGSize(width: 0.0, height: -4.0)

        case .left:
            layer.shadowOffset      =   CGSize(width: -4.0, height: 0.0)
            
        case .right:
            layer.shadowOffset      =   CGSize(width: 4.0, height: 0.0)
            
        case .bottom:
            layer.shadowOffset      =   CGSize(width: 0.0, height: 3.0)
            
        case .around:
            layer.shadowOffset      =   .zero
        }
    }
    
    /// [top, bottom].cgColor
    func setGradientBackground(colors: [CGColor], onside: SideType) {
        let gradientLayer           =   CAGradientLayer()
        gradientLayer.colors        =   colors
        gradientLayer.frame         =   self.bounds

        switch onside {
        case .top:
            gradientLayer.locations =   [0.0, 0.4]

        case .left:
            gradientLayer.locations =   [4.0, 0.0]
            
        case .right:
            gradientLayer.locations =   [0.6, 0.0]
            
        case .bottom:
            gradientLayer.locations =   [0.0, 1.0]
            
        case .around:
            gradientLayer.locations =   [0.4, 0.4]
        }
        
        self.layer.addSublayer(gradientLayer)
    }
    
    func show(constraint: NSLayoutConstraint) {
        constraint.constant = 0.0

        UIView.animate(withDuration: 0.5) {
            self.alpha = 1.0
            self.layoutIfNeeded()
        }
    }

    func hide(constraint: NSLayoutConstraint) {
        constraint.constant = -self.frame.height
        
        UIView.animate(withDuration: 0.7, animations: {
            self.layoutIfNeeded()
        }, completion: { success in
            self.alpha = 0.0
        })
    }
}
