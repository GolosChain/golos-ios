//
//  UINavigationController+Extensions.swift
//  Golos
//
//  Created by msm72 on 11.06.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

extension UINavigationController {
    func add(shadow: Bool) {
        self.navigationBar.layer.shadowColor    =   shadow ? UIColor.lightGray.cgColor : UIColor.white.cgColor
        self.navigationBar.layer.shadowOffset   =   CGSize(width: 0.0, height: 2.0)
        self.navigationBar.layer.shadowRadius   =   shadow ? 4.0 : 0.0
        self.navigationBar.layer.shadowOpacity  =   shadow ? 4.0 : 0.0
        self.navigationBar.layer.masksToBounds  =   false
        
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.navigationBar.barTintColor = UIColor.white
        }, completion: nil)

    }
}
