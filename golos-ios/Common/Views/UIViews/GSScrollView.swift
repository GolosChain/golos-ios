//
//  GSScrollView.swift
//  Golos
//
//  Created by msm72 on 14.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class GSScrollView: UIScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    private func setup() {
        delaysContentTouches = false
    }
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIButton {
            return true
        }
        
        return super.touchesShouldCancel(in: view)
    }
}
