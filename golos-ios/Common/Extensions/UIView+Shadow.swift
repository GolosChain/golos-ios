//
//  UIView+Shadow.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 24/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import SwiftTheme

extension UIView {
    func tune() {
        ThemeManager.setTheme(index: isAppThemeDark ? 1 : 0)
        self.theme_backgroundColor = whiteBlackColorPickers
    }

    func addBottomShadow() {
        layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 1
        layer.masksToBounds = false
    }
}
