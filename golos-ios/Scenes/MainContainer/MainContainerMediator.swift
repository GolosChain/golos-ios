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
            viewController  =   GSTabBarController()
            
        case .loggedOut:
            // Storyboard
            let storyboard  =   UIStoryboard(name: "WelcomeShow", bundle: nil)
            viewController  =   storyboard.instantiateViewController(withIdentifier: "WelcomeShowNC") as! UINavigationController
        }
        
        return viewController
    }
}
