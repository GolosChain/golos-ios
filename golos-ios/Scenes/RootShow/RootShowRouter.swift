//
//  RootShowRouter.swift
//  golos-ios
//
//  Created by msm72 on 02.06.2018.
//  Copyright (c) 2018 golos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoloSwift

// MARK: - Input & Output protocols
@objc protocol RootShowRoutingLogic {
    func routeToNextScene()
}

protocol RootShowDataPassing {
    var dataStore: RootShowDataStore? { get }
}

class RootShowRouter: NSObject, RootShowRoutingLogic, RootShowDataPassing {
    // MARK: - Properties
    weak var viewController: RootShowViewController?
    var dataStore: RootShowDataStore?
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Routing
    func routeToNextScene() {
        let destinationVC: MainContainerViewController      =   MainContainerViewController()
        destinationVC.modalTransitionStyle                  =   .crossDissolve
        
        // Pass displayedPosts
        if appState == .loggedIn {
            //        let destinationDS                                   =   destinationVC.router!.dataStore!
            //            passDataToSomewhere(source: dataStore!, destination: &destinationDS)
        }

        (UIApplication.shared.delegate as! AppDelegate).window?.addSubview(destinationVC.view)
        
        navigateToNextScene(source: viewController!, destination: destinationVC)
    }
    
    
    // MARK: - Navigation
    func navigateToNextScene(source: RootShowViewController, destination: MainContainerViewController) {
        DispatchQueue.main.async {
            source.present(destination, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Passing data
//    func passDataToSomewhere(source: RootShowDataStore, destination: inout SomewhereDataStore) {
//        destination.name = source.name
//    }
}
