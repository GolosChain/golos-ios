//
//  Utils.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 13/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import Localize_Swift

struct Utils {
    static func showAlertView(withTitle title: String, andMessage message: String, needCancel cancel: Bool, completion: @escaping ((Bool) -> Void)) {
        let alertViewController = UIAlertController.init(title: title.localized(), message: message.localized(), preferredStyle: .alert)
        
        let alertViewControllerOkAction = UIAlertAction.init(title: (cancel ? "ActionYes".localized() : "ActionOk".localized()), style: .default, handler: { _ in
            return completion(true)
        })
        
        alertViewController.addAction(alertViewControllerOkAction)
        
        if cancel {
            let alertViewControllerCancelAction = UIAlertAction.init(title: "ActionCancel".localized(), style: .default, handler: { _ in
                return completion(false)
            })
            
            alertViewController.addAction(alertViewControllerCancelAction)
        }
        
        alertViewController.show()
    }

    static func inDevelopmentAlert() {
        self.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
    }
}
