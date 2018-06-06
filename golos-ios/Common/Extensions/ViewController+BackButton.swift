//
//  ViewController+BackButton.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 14/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

extension UIViewController {
    func configureBackButton() {
        let backImage = UIImage(named: "back_button")
        
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
                                                                title:      "",
                                                                style:      UIBarButtonItemStyle.plain,
                                                                target:     nil,
                                                                action:     nil)
    }
}
