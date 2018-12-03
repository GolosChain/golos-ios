//
//  UITextField+Extensions.swift
//  Golos
//
//  Created by msm72 on 11.06.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import SwiftTheme

extension UITextField {
    func tune(withPlaceholder placeholder: String, textColors: ThemeColorPicker?, font: UIFont?, alignment: NSTextAlignment) {
        self.font                   =   font
        self.theme_textColor        =   textColors
        self.textAlignment          =   alignment
        
        self.attributedPlaceholder  =   NSAttributedString(string:      placeholder.localized(),
                                                           attributes:  [ NSAttributedString.Key.foregroundColor: UIColor(hexString: "#7d7d7d") ])
    }    
}
