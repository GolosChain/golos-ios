//
//  OverScrollView.swift
//  Golos
//
//  Created by Grigory on 13/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class OverScrollView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !isUserInteractionEnabled {
            return nil
        }
        
        if !self.point(inside: point, with: event) {
            return nil
        }
        
        let subviews = self.subviews
        for subview in subviews {
            let pointInSubview = convert(point, to: subview)
            let resultView = subview.hitTest(pointInSubview, with: event)
            return resultView
        }
        return nil
    }
}
