//
//  MainContainerMediator.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 15/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class MainContainerMediator: NSObject {
    func getViewController() -> UIViewController {
        let viewController: UIViewController
        
        switch User.isAnonymous {
        case false:
            viewController      =   GSTabBarController()
            
        case true:
            if AppSettings.instance().startWithWelcomeScene {
                let storyboard  =   UIStoryboard(name: "WelcomeShow", bundle: nil)
                viewController  =   storyboard.instantiateViewController(withIdentifier: "WelcomeShowNC") as! UINavigationController
            }
            
            else {
                viewController  =   GSTabBarController()
            }
        }
        
        return viewController
    }
}
