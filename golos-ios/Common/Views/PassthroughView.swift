//
//  OverScrollView.swift
//  Golos
//
//  Created by Grigory on 13/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class PassthroughView: UIView {
    // MARK: - IBOutlets
    @IBOutlet var labelsForAnimationCollection: [UILabel]! {
        didSet {
            _ = labelsForAnimationCollection.map({ $0.alpha = 0 })
        }
    }
    
    
    // MARK: - Custom Functions
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        
        return view != self && view is UIControl ? view : nil
    }
    
    func showLabelsForAnimationCollection() {
        _ = self.labelsForAnimationCollection.map({ label in
            UIView.animate(withDuration: 0.3, animations: {
                label.alpha = 1.0
            })
        })
    }
}
