//
//  Utils.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 13/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

struct Utils {
    static func showAlert(title: String? = "Alert", message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(action)
        alertController.show()
    }
    
    static func inDevelopmentAlert() {
        showAlert(message: "In development")
    }
}
