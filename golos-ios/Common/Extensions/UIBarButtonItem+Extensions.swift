//
//  UIBarButton+Extensions.swift
//  Golos
//
//  Created by msm72 on 14.06.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class BlockBarButtonItem: UIBarButtonItem {
    private var actionHandler: ((Int) -> Void)?
    
    convenience init(title: String?, style: UIBarButtonItem.Style, tag: Int, actionHandler: ((Int) -> Void)?) {
        self.init(title: title, style: style, target: nil, action: #selector(barButtonItemPressed))

        self.target         =   self
        self.tag            =   tag
        self.actionHandler  =   actionHandler
    }
    
    convenience init(image: UIImage?, style: UIBarButtonItem.Style, tag: Int, actionHandler: ((Int) -> Void)?) {
        self.init(image: image, style: style, target: nil, action: #selector(barButtonItemPressed))
        
        self.target         =   self
        self.tag            =   tag
        self.actionHandler  =   actionHandler
    }
    
    @objc func barButtonItemPressed(sender: UIBarButtonItem) {
        actionHandler?(sender.tag)
    }
}
