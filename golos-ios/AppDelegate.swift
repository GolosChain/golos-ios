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
//import Starscream
import Crashlytics
import IQKeyboardManagerSwift

//import CoreBitcoin

//let webSocket = WebSocket(url: URL(string: Bundle.main.infoDictionary![ConstantsApp.InfoDictionaryKey.webSocketUrlKey] as! String)!)
//let webSocketManager = WebSocketManager()

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
    
    
    // TESTED
    func testGETRequest() {
        
    }
    
    func testPOSTRequest() {
        // Create OperationType
        let operationType: OperationType = OperationType.vote(fields: (voter: voter, author: author, permlink: permlink, weight: weight))
        
        // POST Request
        broadcast.executePOST(byOperationType: operationType, completion: { responseAPIType in
            if  let responseModel = responseAPIType?.responseAPI as? ResponseAPIVerifyAuthorityResult, let result = responseModel.result {
                if responseModel.error == nil {
                    Logger.log(message: "\nresponse Result = \(result)\n", event: .debug)
                }
            }
                
            else {
                Logger.log(message: "nresponse ErrorAPI = \((responseAPIType!.responseAPI as! ResponseAPIVerifyAuthorityResult).error!.message)\n", event: .error)
            }
        })
    }
}
