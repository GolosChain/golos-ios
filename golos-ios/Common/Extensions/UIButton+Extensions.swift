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
    func setBlueButtonRoundEdges() {
        setRoundEdges(cornerRadius: self.frame.height / 2)

        self.titleLabel?.font       =   UIFont(name: "SFUIDisplay-Regular", size: 16.0 * widthRatio)
        self.theme_backgroundColor  =   vividBlueWhiteColorPickers
        self.theme_setTitleColor(whiteColorPickers, forState: .normal)
    }
    
    func setBorderButtonRoundEdges() {
        setRoundEdges(cornerRadius: self.frame.height / 2)

        self.layer.borderColor      =   UIColor(hexString: "#DBDBDB").cgColor
        self.layer.borderWidth      =   1.0
        self.titleLabel?.font       =   UIFont(name: "SFUIDisplay-Regular", size: 16.0 * widthRatio)
        self.theme_backgroundColor  =   whiteColorPickers
        self.theme_setTitleColor(darkGrayWhiteColorPickers, forState: .normal)
    }
    
    func setProfileHeaderButton() {
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
