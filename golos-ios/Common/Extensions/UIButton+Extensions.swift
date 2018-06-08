//
//  UIButton+Extensions.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 13/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

extension UIButton {
    func setBlueButtonRoundEdges() {
        setRoundEdges(cornerRadius: self.frame.height / 2)
        backgroundColor = UIColor(hexString: "#1298FF")
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont(name: "SFUIDisplay-Regular", size: 16.0 * widthRatio)
    }
    
    func setBorderButtonRoundEdges() {
        setRoundEdges(cornerRadius: self.frame.height / 2)
        backgroundColor = .white
        layer.borderColor = UIColor(hexString: "#DBDBDB").cgColor
        layer.borderWidth = 1.0
        setTitleColor(UIColor(hexString: "#7D7D7D"), for: .normal)
        titleLabel?.font = UIFont(name: "SFUIDisplay-Regular", size: 16.0 * widthRatio)
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
