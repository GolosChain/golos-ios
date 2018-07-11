//
//  UIButton+Extensions.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 13/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import SwiftTheme

extension UIButton {
    func tune(withTitle title: String, hexColors: ThemeColorPicker?, font: UIFont?, alignment: NSTextAlignment) {
        ThemeManager.setTheme(index: isAppThemeDark ? 1 : 0)
        
        self.titleLabel?.font               =   font
        self.titleLabel?.textAlignment      =   alignment

        self.setTitle(title.localized(), for: .normal)
        self.theme_setTitleColor(hexColors, forState: .normal)
    }
    
    func setBlueButtonRoundEdges() {
        self.layoutIfNeeded()
        setRoundEdges(cornerRadius: self.frame.height / 2)

        self.titleLabel?.font       =   UIFont(name: "SFUIDisplay-Regular", size: 16.0 * widthRatio)
        self.theme_backgroundColor  =   vividBlueWhiteColorPickers
        self.theme_setTitleColor(whiteColorPickers, forState: .normal)
    }
    
    func setBlueButtonRoundCorners() {
        self.layoutIfNeeded()
        setRoundEdges(cornerRadius: 4.0)
        
        self.titleLabel?.font       =   UIFont(name: "SFProDisplay-Regular", size: 16.0 * widthRatio)
        self.theme_backgroundColor  =   vividBlueWhiteColorPickers
        self.theme_setTitleColor(whiteColorPickers, forState: .normal)
    }
    
    func setBorderButtonRoundEdges() {
        self.layoutIfNeeded()
        setRoundEdges(cornerRadius: self.frame.height / 2)

        self.layer.borderColor      =   UIColor(hexString: "#DBDBDB").cgColor
        self.layer.borderWidth      =   1.0
        self.titleLabel?.font       =   UIFont(name: "SFUIDisplay-Regular", size: 16.0 * widthRatio)
        self.theme_backgroundColor  =   whiteColorPickers
        self.theme_setTitleColor(darkGrayWhiteColorPickers, forState: .normal)
    }
    
    func setProfileHeaderButton() {
        self.layoutIfNeeded()
        setRoundEdges(cornerRadius: 4.0)
        backgroundColor = .white
        setTitleColor(UIColor.Project.textBlack, for: .normal)
        titleLabel?.font = Fonts.shared.regular(with: 12)
    }
    
    private func setRoundEdges(cornerRadius: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
    }
}
