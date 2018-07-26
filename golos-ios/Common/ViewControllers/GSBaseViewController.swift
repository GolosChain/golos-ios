//
//  BaseViewController.swift
//  ViewTest
//
//  Created by msm72 on 26.05.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class GSBaseViewController: UIViewController {
    // MARK: - Properties
    var foregroundRemoteNotificationView: ForegroundRemoteNotificationView?
    

    // MARK: - Custom Functions
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

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
                                    self.hide(localNotification: subview)
                                }
                            }
            })
        }
    }
    
    func hide(localNotification: ForegroundRemoteNotificationView) {
        if let subview = self.foregroundRemoteNotificationView, subview.isDisplay, subview === localNotification {
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
    
    func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func showNavigationBar(withBackButtonTitle title: String? = nil) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        self.configureBackButton(withTitle: title)
    }
    
    private func configureBackButton(withTitle title: String? = nil) {
        let backImage = UIImage(named: "back_button")
        
        self.navigationController?.navigationBar.backIndicatorImage                 =   backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage   =   backImage
        
        self.navigationItem.backBarButtonItem   =   UIBarButtonItem(title:      title == nil ? "" : title!.localized(),
                                                                    style:      .plain,
                                                                    target:     nil,
                                                                    action:     nil)
    }

    func showAlertView(withTitle title: String, andMessage message: String, needCancel cancel: Bool, completion: @escaping ((Bool) -> Void)) {
        let alertViewController = UIAlertController.init(title: title.localized(), message: message.localized(), preferredStyle: .alert)
        
        let alertViewControllerOkAction = UIAlertAction.init(title: (cancel ? "ActionYes".localized() : "ActionOk".localized()), style: .default, handler: { _ in
            return completion(true)
        })
        
        alertViewController.addAction(alertViewControllerOkAction)
        
        if cancel {
            let alertViewControllerCancelAction = UIAlertAction.init(title: "ActionCancel".localized(), style: .destructive, handler: { _ in
                return completion(false)
            })
            
            alertViewController.addAction(alertViewControllerCancelAction)
        }
        
        alertViewController.show()
    }
    
    
    // MARK: - Actions
    @objc func adjustForKeyboard(notification: Notification) {
    }
}
