//
//  UIButton+Intro.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 13/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

extension UIButton {
    func setBlueButtonRoundEdges() {
        setRoundEdges(cornerRadius: Constants.ButtonParameters.cornerRadius)
        backgroundColor = UIColor.Project.buttonBgBlue
        setTitleColor(.white, for: .normal)
        titleLabel?.font = Fonts.shared.medium(with: 16)
    }
    
    func setBorderButtonRoundEdges() {
        setRoundEdges(cornerRadius: Constants.ButtonParameters.cornerRadius)
        backgroundColor = .white
        layer.borderColor = UIColor.Project.buttonBorderGray.cgColor
        layer.borderWidth = 1.0
        setTitleColor(UIColor.Project.buttonTextGray, for: .normal)
        titleLabel?.font = Fonts.shared.medium(with: 16)
    }
    
    func setProfileHeaderButton() {
        setRoundEdges(cornerRadius: 4.0)
        backgroundColor = .white
        setTitleColor(UIColor.Project.textBlack, for: .normal)
        titleLabel?.font = Fonts.shared.regular(with: 10)
    }
    
    private func setRoundEdges(cornerRadius: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
    }
}
