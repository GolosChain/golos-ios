//
//  GSNavigationBar.swift
//  Golos
//
//  Created by Grigory on 29/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class GSNavigationBar: UINavigationBar {

    override func layoutSubviews() {
        super.layoutSubviews()
        for subview in subviews {
            let classString = String(describing: subview.self)
            if classString.contains("BarBackground") {
                subview.backgroundColor = barTintColor
            }
        }
    }
}
