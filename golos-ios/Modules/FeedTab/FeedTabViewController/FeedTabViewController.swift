//
//  FeedTabViewController.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 21/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class FeedTabViewController: UIViewController {
    
    var feedTab = FeedTab(type: .popular)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let color: UIColor
        switch feedTab.type {
        case .hot: color = .red
        case .new: color = .blue
        case .popular: color = .green
        case .promoted: color = .magenta
        }
        view.backgroundColor = color
    }
}
