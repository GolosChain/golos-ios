//
//  UILabel+Extensions.swift
//  Golos
//
//  Created by msm72 on 09.06.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import SwiftTheme

extension UILabel {
    func tune(withText text: String, hexColors: ThemeColorPicker?, font: UIFont?, alignment: NSTextAlignment, isMultiLines: Bool) {
        ThemeManager.setTheme(index: isAppThemeDark ? 1 : 0)
        
        self.text               =   text.localized()
        self.font               =   font
        self.theme_textColor    =   hexColors
        
        self.numberOfLines      =   isMultiLines ? 0 : 1
        self.textAlignment      =   alignment
    }
    
    func tune(withAttributedText text: String, hexColors: ThemeColorPicker?, font: UIFont?, alignment: NSTextAlignment, isMultiLines: Bool) {
        ThemeManager.setTheme(index: isAppThemeDark ? 1 : 0)
        
        let attributedString    =   NSMutableAttributedString(string:      text.localized(),
                                                              attributes:  [ NSAttributedString.Key.font: font! ])
        
        let style               =   NSMutableParagraphStyle()
        style.lineSpacing       =   1.5 * widthRatio
        style.minimumLineHeight =   20.0 * widthRatio
        
        attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: style], range: NSRange(location: 0, length: text.localized().count))
        self.attributedText     =   attributedString
        
        self.font               =   font
        self.theme_textColor    =   hexColors
        
        self.numberOfLines      =   isMultiLines ? 0 : 1
        self.textAlignment      =   alignment
    }
}
