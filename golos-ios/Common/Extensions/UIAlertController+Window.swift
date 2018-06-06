//
//  UIAlertController+Window.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 13/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

private var kAlertControllerWindow = "kAlertControllerWindow"

extension UIAlertController {
    private var alertWindow: UIWindow? {
        get {
            return objc_getAssociatedObject(self, &kAlertControllerWindow) as? UIWindow
        }
        
        set {
            objc_setAssociatedObject(self, &kAlertControllerWindow, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        alertWindow?.isHidden = true
        alertWindow = nil
    }
    
    func show() {
        show(animated: true)
    }
    
    func show(animated: Bool) {
        alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow?.rootViewController = UIViewController()
        alertWindow?.windowLevel = UIWindowLevelAlert + 1
        alertWindow?.makeKeyAndVisible()
        alertWindow?.rootViewController?.present(self,
                                                 animated: animated,
                                                 completion: nil)
    }
}
