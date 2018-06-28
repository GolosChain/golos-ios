//
//  OverScrollView.swift
//  Golos
//
//  Created by Grigory on 13/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class PassthroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        
        return view != self && view is UIControl ? view : nil
    }
}
