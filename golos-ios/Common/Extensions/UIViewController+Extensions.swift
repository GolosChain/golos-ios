//
//  ViewController+BackButton.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 14/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

extension UIViewController {    
    static func nibInstance() -> Self {
        let nibName = String(describing: self)
        let viewController = self.init(nibName: nibName, bundle: nil)
        
        return viewController
    }
}
