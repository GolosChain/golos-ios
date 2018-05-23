//
//  AppDelegate.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 10/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import Fabric
import Firebase
import GoloSwift
import Crashlytics
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import FirebaseInstanceID
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - Properties
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    
    
    // MARK: - Class Functions
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Logger.log(message: "Success", event: .severe)

        
        // TODO: - TEST POST REQUEST
//        self.testGETRequest()
//        self.testPOSTRequest()

        
//        self.setupNavigationBarAppearance()
//        self.setupTabBarAppearance()
//        self.setupKeyboardManager()
//        self.configureMainContainer()
        
        // Run Firebase
        FirebaseApp.configure()
        Messaging.messaging().delegate                      =   self

        // Run Fabric
        Fabric.with([Crashlytics.self])
        
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate     =   self
            let authOptions: UNAuthorizationOptions         =   [ .alert, .badge, .sound ]
            
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        }
        
        else {
            let settings: UIUserNotificationSettings        =   UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        // [END register_for_notifications]

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
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
        Logger.log(message: "\ndeviceToken:\n\t\(token)", event: .severe)
        
//        if Token.current == nil {
//            _ = CoreDataManager.instance.createEntity("Token")
//        }
//
//        Token.current!.device = token
//        Token.current!.save()
        
        let type: MessagingAPNSTokenType
        #if DEBUG
            type = .sandbox
        #else
            type = .prod
        #endif
        
        Messaging.messaging().setAPNSToken(deviceToken, type: type)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Logger.log(message: "Register for Remote Notifications failed: \(error.localizedDescription)", event: .error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // App in Active mode & after tap on notification
        Logger.log(message: "Received Remote Notification message: \(userInfo)", event: .severe)
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



// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//        if Token.current == nil {
//            _ = CoreDataManager.instance.createEntity("Token")
//        }
//
//        Token.current!.firebase = fcmToken
//        Token.current!.lastMessageID = 0
//        Token.current!.save()
        Logger.log(message: "Received Firebase token: \(fcmToken)", event: .severe)
    }
    
    func application(received remoteMessage: MessagingRemoteMessage) {
        Logger.log(message: "Received Remote message: \(remoteMessage.appData)", event: .severe)
    }
}


// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        UIApplication.shared.applicationIconBadgeNumber += 1
        Logger.log(message: "Present User Notification, badge = \(UIApplication.shared.applicationIconBadgeNumber)", event: .severe)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        Logger.log(message: "Receive User Notification, badge = \(UIApplication.shared.applicationIconBadgeNumber)", event: .severe)
    }
}
