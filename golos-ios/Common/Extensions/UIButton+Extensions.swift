//
//  UIButton+Extensions.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 13/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftTheme

extension UIButton {
    /// hexColors: [normal, highlighted, selected, disabled]
    func tune(withTitle title: String, hexColors: [ThemeColorPicker], font: UIFont?, alignment: NSTextAlignment) {
        ThemeManager.setTheme(index: isAppThemeDark ? 1 : 0)
        
        self.titleLabel?.font               =   font
        self.titleLabel?.textAlignment      =   alignment

        self.setTitle(title.localized(), for: .normal)
        self.theme_setTitleColor(hexColors[0], forState: .normal)
        self.theme_setTitleColor(hexColors[1], forState: .highlighted)
        self.theme_setTitleColor(hexColors[2], forState: .selected)
        self.theme_setTitleColor(hexColors[3], forState: .disabled)
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
    
    func setBorder(color: CGColor, cornerRadius: CGFloat) {
        self.layoutIfNeeded()
        setRoundEdges(cornerRadius: cornerRadius)
        
        self.layer.borderColor      =   color
        self.layer.borderWidth      =   1.0
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
        titleLabel?.font = UIFont(name: "SFUIDisplay-Regular", size: 12.0 * widthRatio)
    }
    
    private func setRoundEdges(cornerRadius: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
    }
    
    // Upload image
    func uploadImage(byStringPath path: String, andSize size: CGSize) {
        let imagePath = path.addImageProxy(withSize: size)

        self.kf.setImage(with:              ImageResource(downloadURL: URL(string: imagePath)!, cacheKey: imagePath), for: .normal,
                         placeholder:       UIImage.init(named: "image-placeholder"),
                         options:           [.transition(ImageTransition.fade(1)),
                                             .processor(ResizingImageProcessor(referenceSize:       size,
                                                                               mode:                .aspectFill))],
                         completionHandler: { _, error, _, _ in
                            if error == nil {
                                self.imageView?.kf.cancelDownloadTask()
                            }
        })
    }
}
