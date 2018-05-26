//
//  BaseViewController.swift
//  ViewTest
//
//  Created by msm72 on 26.05.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    // MARK: - Properties
    var foregroundRemoteNotificationView: ForegroundRemoteNotificationView?
    

    // MARK: - Custom Functions
    func displayLocalNotification() {
        if let subview = self.foregroundRemoteNotificationView, !subview.isDisplay {
            self.view.addSubview(subview)

            UIView.animate(withDuration: 0.5,
                           animations: {
                            subview.frame.origin.y = 0.0
                            (UIApplication.shared.value(forKey: "statusBarWindow") as? UIWindow)?.alpha = 0.0
            },
                           completion: { success in
                            if success {
                                subview.isDisplay = true

                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 6.5) {
                                    self.hideLocalNotification()
                                }
                            }
            })
        }
    }
    
    func hideLocalNotification() {
        if let subview = self.foregroundRemoteNotificationView, subview.isDisplay {
            UIView.animate(withDuration: 0.5,
                           animations: {
                            subview.frame.origin.y = -100.0
                            (UIApplication.shared.value(forKey: "statusBarWindow") as? UIWindow)?.alpha = 1.0
            },
                           completion: { success in
                            if success {
                                subview.isDisplay = false
                                subview.removeFromSuperview()
                                self.foregroundRemoteNotificationView = nil
                            }
            })
        }
    }
}
