//
//  AppDelegate.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 10/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupNavigationBarAppearance()
        setupTabBarAppearance()
        setupKeyboardManager()
        setupHockeyApp()
        
        configureMainContainer()
        window?.makeKeyAndVisible()
        
        return true
    }
}
