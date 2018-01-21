//
//  FeedTabViewController.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 21/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class FeedTabViewController: UIViewController {
    
    var feedType: FeedType = .hot {
        didSet {
            let color: UIColor
            switch feedType {
            case .created: color = .red
            case .hot: color = .blue
            case .promoted: color = .green
            case .trending: color = .magenta
            }
            view.backgroundColor = color
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
}
