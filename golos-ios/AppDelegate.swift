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
        
        
        self.setupNavigationBarAppearance()
        self.setupTabBarAppearance()
        self.setupKeyboardManager()
        self.configureMainContainer()
        
        // Run Firebase
        FirebaseApp.configure()
        
        if Messaging.messaging().fcmToken != nil {
            Messaging.messaging().subscribe(toTopic: "yuri-vlad-second")
        }
        
        Messaging.messaging().delegate = self
        
        // Run Fabric
        Fabric.with([Crashlytics.self])
        
        // APNs
        self.registerForPushNotifications()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        Logger.log(message: "Success", event: .severe)
        
        webSocket.disconnect()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Logger.log(message: "Success", event: .severe)
        
        application.applicationIconBadgeNumber = 0

        if !webSocket.isConnected {
            webSocket.connect()
            
            if webSocket.delegate == nil {
                webSocket.delegate = webSocketManager
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
        Logger.log(message: "\nAPNs device token:\n\t\(token)", event: .severe)
        
        let type: MessagingAPNSTokenType
        
        #if DEBUG
        type = .sandbox
        #else
        type = .prod
        #endif
        
        Messaging.messaging().setAPNSToken(deviceToken, type: type)
        Messaging.messaging().subscribe(toTopic: "yuri-vlad-second")
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        Messaging.messaging().subscribe(toTopic: "yuri-vlad-second")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Logger.log(message: "APNs registration failed: \(error.localizedDescription)", event: .error)
    }
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//        // If you are receiving a notification message while your app is in the background,
//        // this callback will not be fired till the user taps on the notification launching the application.
//        // TODO: Handle data of notification
//
//        // With swizzling disabled you must let Messaging know about the message, for Analytics
//        // Messaging.messaging().appDidReceiveMessage(userInfo)
//
//        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            Logger.log(message: "Received Remote Notification messageID: \(messageID)", event: .debug)
//        }
//
//        // Print full message.
//        Logger.log(message: "Received Remote Notification userInfo: \(userInfo)", event: .debug)
//    }
    
    // For iOS 9.0
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            Logger.log(message: "Received Remote Notification messageID: \(messageID)", event: .debug)
        }
        
        // Check Foreground (active) mode of App & display Local Notification
        if application.applicationState == .active {
            let localNotification           =   UILocalNotification()
            localNotification.userInfo      =   userInfo
            localNotification.soundName     =   UILocalNotificationDefaultSoundName
            localNotification.alertBody     =   "message"
            localNotification.fireDate      =   Date()
            
            // Display Remote Notification as Local when App is in Foreground mode
            if let currentVC = getCurrentViewController(forRootViewController: UIApplication.shared.keyWindow?.rootViewController) as? BaseViewController {
                currentVC.foregroundRemoteNotificationView = ForegroundRemoteNotificationView()
                currentVC.displayLocalNotification()
            }
        }
        
        // Print full message.
        Logger.log(message: "Received Remote Notification userInfo: \(userInfo)", event: .debug)
        completionHandler(UIBackgroundFetchResult.newData)
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
        appearance.titleTextAttributes =    [
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
    
    // APNs
    private func registerForPushNotifications() {
        // Register for remote notifications
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            
            center.requestAuthorization(options: [ .alert, .badge, .sound ], completionHandler: { (granted, _) in
                Logger.log(message: (granted) ? "User notifications are allowed." : "User notifications are not allowed.", event: .debug)
                
                let viewAction = UNNotificationAction(identifier: "viewActionIdentifier",
                                                      title: "View",
                                                      options: [.foreground])
                
                let newsCategory = UNNotificationCategory(identifier: "newsCategoryIdentifier",
                                                          actions: [viewAction],
                                                          intentIdentifiers: [],
                                                          options: [])
                
                UNUserNotificationCenter.current().setNotificationCategories([newsCategory])
            })
        }
            
        else {
            // Create `Restart` action
            let restartAction                       =   UIMutableUserNotificationAction()
            restartAction.identifier                =   "RESTART_ACTION"
            restartAction.isDestructive             =   true
            restartAction.title                     =   "Restart"
            restartAction.activationMode            =   .background
            restartAction.isAuthenticationRequired  =   false
            
            // Create `Snooze` action
            let snoozeAction                        =   UIMutableUserNotificationAction()
            snoozeAction.identifier                 =   "SNOOZE_ACTION"
            snoozeAction.isDestructive              =   false
            snoozeAction.title                      =   "Snooze"
            snoozeAction.activationMode             =   .background
            snoozeAction.isAuthenticationRequired   =   false
            
            // Create `Edit` action
            let editAction                          =   UIMutableUserNotificationAction()
            editAction.identifier                   =   "EDIT_ACTION"
            editAction.isDestructive                =   false
            editAction.title                        =   "Edit"
            editAction.activationMode               =   .background
            editAction.isAuthenticationRequired     =   false
            
            // Create the category
            let category                            =   UIMutableUserNotificationCategory()
            category.identifier                     =   "TEST_CATEGORY"
            
            // Set actions for the default context
            category.setActions([ restartAction, snoozeAction, editAction ], for: .default)
            
            // Set actions for the minimal context
            category.setActions([ restartAction, snoozeAction ], for: .minimal)
            
            // Notification Registration for all iOS versions
            let settings = UIUserNotificationSettings(types: [ .alert, .badge, .sound ], categories: NSSet(array: [category]) as? Set<UIUserNotificationCategory>)
            
            DispatchQueue.main.async {
                UIApplication.shared.registerUserNotificationSettings(settings)
            }
        }
        
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        if let identifier = identifier {
            switch identifier {
            case "RESTART_ACTION":
                print("1")
                
            case "SNOOZE_ACTION":
                print("2")
                
            case "EDIT_ACTION":
                print("3")
                
            default:
                print("Unrecognised Identifier")
            }
        }
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        if let identifier = identifier {
            switch identifier {
            case "RESTART_ACTION":
                print("1")
                
            case "SNOOZE_ACTION":
                print("2")
                
            case "EDIT_ACTION":
                print("3")
                
            default:
                print("Unrecognised Identifier")
            }
        }
    }
    
    private func getCurrentViewController(forRootViewController rootViewController: UIViewController?) -> UIViewController? {
        guard let rootViewController = rootViewController else {
            return nil
        }
        
        guard let presented = rootViewController.presentedViewController else {
            return rootViewController
        }
        
        switch presented {
        case is UINavigationController:
            let navigationController: UINavigationController = presented as! UINavigationController
            return getCurrentViewController(forRootViewController: navigationController.viewControllers.last)
            
        case is UITabBarController:
            let tabBarController: UITabBarController = presented as! UITabBarController
            return getCurrentViewController(forRootViewController: tabBarController.selectedViewController)
            
        default:
            return getCurrentViewController(forRootViewController: presented)
        }
    }
}


// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        Logger.log(message: "Received Firebase token: \(fcmToken)", event: .debug)
    }
    
    func application(received remoteMessage: MessagingRemoteMessage) {
        Logger.log(message: "Received Remote message: \(remoteMessage.appData)", event: .debug)
    }
    
    // For iOS 10
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage)
    }
}


// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        UIApplication.shared.applicationIconBadgeNumber += 1
        Logger.log(message: "Present User Notification, badge = \(UIApplication.shared.applicationIconBadgeNumber)", event: .debug)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        Logger.log(message: "Receive User Notification, badge = \(UIApplication.shared.applicationIconBadgeNumber)", event: .debug)
        
        // https://medium.com/@lucasgoesvalle/custom-push-notification-with-image-and-interactions-on-ios-swift-4-ffdbde1f457
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            Logger.log(message: "Dismiss Action", event: .debug)
            
        case UNNotificationDefaultActionIdentifier:
            Logger.log(message: "Open Action", event: .debug)
            
        case "Snooze":
            Logger.log(message: "Snooze Action", event: .debug)
            
        case "Delete":
            Logger.log(message: "Delete Action", event: .debug)
            
        default:
            Logger.log(message: "Default Action", event: .debug)
        }
        
        completionHandler()
    }
}
