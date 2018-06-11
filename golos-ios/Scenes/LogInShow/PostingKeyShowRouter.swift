//
//  PostingKeyShowRouter.swift
//  golos-ios
//
//  Created by msm72 on 10.06.2018.
//  Copyright (c) 2018 golos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoloSwift

// MARK: - Input & Output protocols
@objc protocol PostingKeyShowRoutingLogic {
//    func routeToSomewhere(segue: UIStoryboardSegue?)
}

class PostingKeyShowRouter: NSObject, PostingKeyShowRoutingLogic {
    // MARK: - Properties
    weak var viewController: PostingKeyShowViewController?
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Routing
//    func routeToSomewhere(segue: UIStoryboardSegue?) {
//        if let segue = segue {
//            let destinationVC = segue.destination as! SomewhereViewController
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToSomewhere(source: dataStore!, destination: &destinationDS)
//        } else {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToSomewhere(source: dataStore!, destination: &destinationDS)
//            navigateToSomewhere(source: viewController!, destination: destinationVC)
//        }
//    }
    
    
    // MARK: - Navigation
//    func navigateToSomewhere(source: PostingKeyShowViewController, destination: SomewhereViewController) {
//        source.show(destination, sender: nil)
//    }
    
    
    // MARK: - Passing data
//    func passDataToSomewhere(source: PostingKeyShowDataStore, destination: inout SomewhereDataStore) {
//        destination.name = source.name
//    }
}
