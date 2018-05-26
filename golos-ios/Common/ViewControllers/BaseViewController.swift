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

    var statusBarHidden = false {
        didSet {
            UIView.animate(withDuration: 0.5) { () -> Void in
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    
    // MARK: - Class Functions
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    

    // MARK: - Custom Functions
    func displayLocalNotification() {
        if let subview = self.foregroundRemoteNotificationView, !subview.isDisplay {
            self.view.addSubview(subview)
            self.statusBarHidden = true
            
            UIView.animate(withDuration: 0.5,
                           animations: {
                            subview.frame.origin.y = 0
            },
                           completion: { success in
                            if success {
                                subview.isDisplay = true
                                
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.5) {
                                    self.hideLocalNotification()
                                }
                            }
            })
        }
    }
    
    func hideLocalNotification() {
        if let subview = self.foregroundRemoteNotificationView, subview.isDisplay {
            self.statusBarHidden = false
            
            UIView.animate(withDuration: 0.5,
                           animations: {
                            subview.frame.origin.y = -100
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
