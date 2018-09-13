//
//  SettingsShowRouter.swift
//  golos-ios
//
//  Created by msm72 on 24.07.2018.
//  Copyright (c) 2018 golos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoloSwift

// MARK: - Input & Output protocols
@objc protocol SettingsShowRoutingLogic {
    func routeToLoginShowScene()
    func routeToSettingsNotificationsScene()
    func routeToSettingsUserProfileEditScene()
}

protocol SettingsShowDataPassing {
    var dataStore: SettingsShowDataStore? { get }
}

class SettingsShowRouter: NSObject, SettingsShowRoutingLogic, SettingsShowDataPassing {
    // MARK: - Properties
    weak var viewController: SettingsShowViewController?
    var dataStore: SettingsShowDataStore?
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Routing
    func routeToLoginShowScene() {
        StateMachine.load().changeState(.loggedOut)
//        User.current!.clearCache()
//        CoreDataManager.instance.clearCache()

        User.current!.setIsAuthorized(false)
        
        // Firebase Cloud Messaging: unsubscribe from topics
        fcm.unsubscribeFromTopics()
    }
    
    func routeToSettingsNotificationsScene() {
        let storyboard      =   UIStoryboard(name: "SettingsNotificationsShow", bundle: nil)
        let destinationVC   =   storyboard.instantiateViewController(withIdentifier: "SettingsNotificationsShowVC") as! SettingsNotificationsShowViewController
        
        navigateToSettingsNotificationsScene(source: viewController!, destination: destinationVC)
    }

    func routeToSettingsUserProfileEditScene() {
        let storyboard      =   UIStoryboard(name: "SettingsUserProfileEdit", bundle: nil)
        let destinationVC   =   storyboard.instantiateViewController(withIdentifier: "SettingsUserProfileEditVC") as! SettingsUserProfileEditViewController
        
        navigateToSettingsUserProfileEditScene(source: viewController!, destination: destinationVC)
    }

    
    // MARK: - Navigation
    func navigateToSettingsNotificationsScene(source: SettingsShowViewController, destination: SettingsNotificationsShowViewController) {
        UIApplication.shared.statusBarStyle = .default

        source.show(destination, sender: nil)
        viewController?.showNavigationBar()
    }

    func navigateToSettingsUserProfileEditScene(source: SettingsShowViewController, destination: SettingsUserProfileEditViewController) {
        UIApplication.shared.statusBarStyle = .default
        
        source.show(destination, sender: nil)
        viewController?.showNavigationBar()
    }
}
