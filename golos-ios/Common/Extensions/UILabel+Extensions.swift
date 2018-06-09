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
}
