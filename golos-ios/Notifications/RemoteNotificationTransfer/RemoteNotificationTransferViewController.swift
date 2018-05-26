//
//  NotificationViewController.swift
//  RemoteNotificationTransfer
//
//  Created by msm72 on 23.05.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class RemoteNotificationTransferViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet var messageLabel: UILabel?
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
}


// MARK: - UNNotificationContentExtension
extension RemoteNotificationTransferViewController: UNNotificationContentExtension {
    func didReceive(_ notification: UNNotification) {
        if let number = notification.request.content.userInfo["customNumber"] as? Int {
            messageLabel?.text = "\(number)"
        }

//        self.label?.text = notification.request.content.body
    }
    
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Swift.Void) {
        
    }
}
