//
//  UILabel+Extensions.swift
//  Golos
//
//  Created by msm72 on 09.06.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

extension UILabel {
    func tune(withText text: String, color: UIColor, font: UIFont?, alignment: NSTextAlignment, isMultiLines: Bool) {
        self.text           =   text.localized()
        self.font           =   font
        self.textColor      =   color
        self.numberOfLines  =   isMultiLines ? 0 : 1
        self.textAlignment  =   alignment
    }
}
