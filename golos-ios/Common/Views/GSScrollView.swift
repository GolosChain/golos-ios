//
//  GSScrollView.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 24/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class GSScrollView: UIScrollView {
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIButton {
            return true
        }
        
        return super.touchesShouldCancel(in: view)
    }
   
}
