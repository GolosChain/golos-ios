//
//  MainContainerMediator.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 15/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class MainContainerMediator: NSObject {
    func getViewController(forState state: AppState) -> UIViewController {
        let viewController: UIViewController
        
        switch state {
        case .loggedIn:
            viewController              =   GSTabBarController()
            
        case .loggedOut:
            let introViewController     =   IntroViewController.nibInstance()
            viewController              =   UINavigationController(rootViewController: introViewController)
        }
        
        return viewController
    }
}
