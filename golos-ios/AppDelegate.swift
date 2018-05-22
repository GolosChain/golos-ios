//
//  AppDelegate.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 10/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import Fabric
import GoloSwift
import Crashlytics
import FirebaseCore
import IQKeyboardManagerSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - Properties
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    
    
    // MARK: - Class Functions
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Logger.log(message: "Success", event: .severe)

        
        // TODO: - TEST POST REQUEST
        self.testGETRequest()
//        self.testPOSTRequest()

        
//        self.setupNavigationBarAppearance()
//        self.setupTabBarAppearance()
//        self.setupKeyboardManager()
//        self.configureMainContainer()
        
        // Run Firebase
        FirebaseApp.configure()
        
        // Run Fabric
        Fabric.with([Crashlytics.self])
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        Logger.log(message: "Success", event: .severe)
        
        webSocket.disconnect()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Logger.log(message: "Success", event: .severe)
       
        if !webSocket.isConnected {
            webSocket.connect()
            
            if webSocket.delegate == nil {
                webSocket.delegate = webSocketManager
            }
        }
    }
}


// MARK: - Extensions
extension AppDelegate {
    // RootViewController
    private func configureMainContainer() {
        if window != nil {
            Logger.log(message: "Success", event: .severe)

            let mainContainerViewController = MainContainerViewController()
            window!.rootViewController = mainContainerViewController
            window!.makeKeyAndVisible()
        }
    }
    
    // IQKeyboardManagerSwift
    private func setupKeyboardManager() {
        Logger.log(message: "Success", event: .severe)
       
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
    }

    // Setup Appearance
    private func setupNavigationBarAppearance() {
        Logger.log(message: "Success", event: .severe)

        let appearance = UINavigationBar.appearance()
        appearance.barTintColor = .white
        appearance.tintColor = UIColor.Project.backButtonBlackColor
        appearance.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.Project.navigationBarTextBlack,
            NSAttributedStringKey.font: Fonts.shared.regular(with: 16.0)
        ]
        
        appearance.isTranslucent = false
        appearance.shadowImage = UIImage()
        appearance.setBackgroundImage(UIImage(), for: .default)
    }
    
    private func setupTabBarAppearance() {
        Logger.log(message: "Success", event: .severe)

        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().tintColor = UIColor.Project.darkBlueTabSelected
        UITabBar.appearance().isTranslucent = false
    }
    
    
    /// GET
    func testGETRequest() {
        // Create MethodAPIType
        let methodAPIType = MethodAPIType.getAccounts(names: ["qwerty"])
        
        // API 'get_accounts'
        broadcast.executeGET(byMethodAPIType: methodAPIType,
                             onResult: { [weak self] result in
                                Logger.log(message: "\nresponse Result = \(result)\n", event: .debug)
            },
                             onError: { [weak self] errorAPI in
                                Logger.log(message: "nresponse ErrorAPI = \(errorAPI.caseInfo.message)\n", event: .error)
        })
    }

    /// POST
    func testPOSTRequest() {
        // Create OperationType
        let operationType: OperationAPIType = OperationAPIType.vote(fields: (voter: voter, author: author, permlink: permlink, weight: weight))
        
        // POST Request
        broadcast.executePOST(byOperationAPIType: operationType,
                              onResult: { [weak self] result in
                                Logger.log(message: "\nresponse Result = \(result)\n", event: .debug)
            },
                              onError: { [weak self] errorAPI in
                                Logger.log(message: "nresponse ErrorAPI = \(errorAPI.caseInfo.message)\n", event: .error)
        })
    }
}
