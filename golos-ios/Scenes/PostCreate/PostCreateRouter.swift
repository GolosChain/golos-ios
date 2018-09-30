//
//  PostCreateRouter.swift
//  golos-ios
//
//  Created by msm72 on 11.06.2018.
//  Copyright (c) 2018 golos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoloSwift

// MARK: - Input & Output protocols
@objc protocol PostCreateRoutingLogic {
    func routeToNextScene()
    func save(success: Bool)
    func routeToUserProfileScene(byUserName name: String)
}

protocol PostCreateDataPassing {
    var createItem: Bool? { get set }
    var dataStore: PostCreateDataStore? { get }
}

class PostCreateRouter: NSObject, PostCreateRoutingLogic, PostCreateDataPassing {
    // MARK: - Properties
    weak var viewController: PostCreateViewController?
    var createItem: Bool?
    var dataStore: PostCreateDataStore?
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Routing
    func save(success: Bool) {
        self.createItem = success
    }
    
    func routeToNextScene() {
        self.viewController!.sceneType == .createPost ? self.routeToMainScene() : self.routeToPreviousScene()
    }

    func routeToUserProfileScene(byUserName name: String) {
        let storyboard          =   UIStoryboard(name: "UserProfileShow", bundle: nil)
        let destinationVC       =   storyboard.instantiateViewController(withIdentifier: "UserProfileShowVC") as! UserProfileShowViewController
        destinationVC.sceneMode =   .preview
        var destinationDS       =   destinationVC.router!.dataStore!
        destinationDS.userNickName  =   name
        
        navigateToUserProfileScene(source: viewController!, destination: destinationVC)
    }

    private func routeToMainScene() {
        let fromView: UIView    =   self.viewController!.view
        let toView: UIView      =   (self.viewController!.navigationController!.tabBarController?.viewControllers?.first!.view)!
        
        // Clean all tags only by tapped Cancel button
        viewController?.tagsVC.createFirstTab()
        
        UIView.animate(withDuration: 0.3,
                       animations: {
                            self.viewController!.navigationController!.navigationBar.barTintColor = UIColor(hexString: "#4469af")
                            self.viewController!.navigationController!.navigationBar.isHidden = true
        }, completion: { _ in
            UIView.transition(from: fromView, to: toView, duration: 0.5, options: .transitionCrossDissolve) { [weak self] _ in
                self?.viewController!.navigationController!.tabBarController!.selectedIndex = (self?.createItem)! ? 2 : 0
            }
        })
    }

    private func routeToPreviousScene() {
        self.viewController!.navigationController!.popViewController(animated: true)
        self.viewController!.handlerSuccessCreatedItem!((self.createItem)!)
    }
    

    // MARK: - Navigation
    func navigateToUserProfileScene(source: PostCreateViewController, destination: UserProfileShowViewController) {
        source.show(destination, sender: nil)
    }
}
