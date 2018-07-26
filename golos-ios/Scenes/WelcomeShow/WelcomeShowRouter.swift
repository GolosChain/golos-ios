//
//  WelcomeShowRouter.swift
//  golos-ios
//
//  Created by msm72 on 08.06.2018.
//  Copyright (c) 2018 golos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoloSwift

// MARK: - Input & Output protocols
@objc protocol WelcomeShowRoutingLogic {
    func routeToLoginShowScene()
    func showRegisterFormOnline()
    func showMoreInfoPageOnline()
}

protocol WelcomeShowDataPassing {}

class WelcomeShowRouter: NSObject, WelcomeShowRoutingLogic, WelcomeShowDataPassing {
    // MARK: - Properties
    weak var viewController: WelcomeShowViewController?
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Routing
    func routeToLoginShowScene() {
        let storyboard      =   UIStoryboard(name: "LogInShow", bundle: nil)
        let destinationVC   =   storyboard.instantiateViewController(withIdentifier: "LogInShowVC") as! LogInShowViewController

        viewController?.show(destinationVC, sender: nil)
        viewController?.showNavigationBar()
     }
    
    func showRegisterFormOnline() {
        guard isNetworkAvailable else {
            viewController?.showAlertView(withTitle: "Info", andMessage: "No Internet Connection", needCancel: false, completion: { _ in })
            return
        }
        
        guard let moreUrl = URL.init(string: ConstantsApp.Urls.registration) else {
            viewController?.showAlertView(withTitle: "Error", andMessage: "Developer error!", needCancel: false, completion: { _ in })
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(moreUrl, options: [:], completionHandler: nil)
        }
            
        else {
            UIApplication.shared.openURL(moreUrl)
        }
    }
    
    func showMoreInfoPageOnline() {
        guard isNetworkAvailable else {
            viewController?.showAlertView(withTitle: "Info", andMessage: "No Internet Connection", needCancel: false, completion: { _ in })
            return
        }
        
        guard let moreUrl = URL.init(string: ConstantsApp.Urls.moreInfoAbout) else {
            viewController?.showAlertView(withTitle: "Error", andMessage: "Developer error!", needCancel: false, completion: { _ in })
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(moreUrl, options: [:], completionHandler: nil)
        }
            
        else {
            UIApplication.shared.openURL(moreUrl)
        }
    }
}
