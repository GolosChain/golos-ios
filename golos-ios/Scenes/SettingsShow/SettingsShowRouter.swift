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
    func showOnlineGolosPage()
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
        DispatchQueue.main.async {
            StateMachine.load().changeState(.loggedOut)
            User.current!.setIsAuthorized(false)
            User.clearCache()
            
            // Firebase Cloud Messaging: unsubscribe from topics
            fcm.unsubscribeFromTopics()
        }
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

    func showOnlineGolosPage() {
        guard isNetworkAvailable else {
            viewController?.showAlertView(withTitle: "Info", andMessage: "No Internet Connection", needCancel: false, completion: { _ in })
            return
        }
        
        guard let stringURL = viewController?.onlinePage?.rawValue, let pageURL = URL.init(string: stringURL) else {
            viewController?.showAlertView(withTitle: "Error", andMessage: "Developer error!", needCancel: false, completion: { _ in })
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(pageURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
            
        else {
            UIApplication.shared.openURL(pageURL)
        }
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


// Helper function inserted by Swift 4.2 migrator.
private func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
