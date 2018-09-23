//
//  UserProfileShowRouter.swift
//  golos-ios
//
//  Created by msm72 on 29.06.2018.
//  Copyright (c) 2018 golos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoloSwift

// MARK: - Input & Output protocols
@objc protocol UserProfileShowRoutingLogic {
    func routeToPostShowScene()
    func routeToSettingsShowScene()
    func routeToUserProfileScene(byUserName name: String)
    func routeToPostCreateScene(withType sceneType: SceneType)
}

protocol UserProfileShowDataPassing {
    var dataStore: UserProfileShowDataStore? { get }
}

class UserProfileShowRouter: NSObject, UserProfileShowRoutingLogic, UserProfileShowDataPassing {
    // MARK: - Properties
    weak var viewController: UserProfileShowViewController?
    var dataStore: UserProfileShowDataStore?
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Routing
    func routeToPostShowScene() {
        let storyboard              =   UIStoryboard(name: "PostShow", bundle: nil)
        let destinationVC           =   storyboard.instantiateViewController(withIdentifier: "PostShowVC") as! PostShowViewController
        var destinationDS           =   destinationVC.router!.dataStore!
        
        passDataToPostShowScene(source: dataStore!, destination: &destinationDS)
        navigateToPostShowScene(source: viewController!, destination: destinationVC)
    }

    func routeToSettingsShowScene() {
        let storyboard              =   UIStoryboard(name: "SettingsShow", bundle: nil)
        let destinationVC           =   storyboard.instantiateViewController(withIdentifier: "SettingsShowVC") as! SettingsShowViewController

        navigateToSettingsShowScene(source: viewController!, destination: destinationVC)
    }
    
    func routeToPostCreateScene(withType sceneType: SceneType) {
        let storyboard              =   UIStoryboard(name: "PostCreate", bundle: nil)
        let destinationVC           =   storyboard.instantiateViewController(withIdentifier: "PostCreateVC") as! PostCreateViewController
        destinationVC.sceneType     =   sceneType
        var destinationDS           =   destinationVC.router!.dataStore!
        
        passDataToPostCreateScene(postShortInfo: sceneType == .createComment ? self.dataStore!.selectedBlog! : self.dataStore!.commentReply!, destination: &destinationDS)
        navigateToPostCreateScene(source: viewController!, destination: destinationVC)
    }
    
    func routeToUserProfileScene(byUserName name: String) {
        let storyboard              =   UIStoryboard(name: "UserProfileShow", bundle: nil)
        let destinationVC           =   storyboard.instantiateViewController(withIdentifier: "UserProfileShowVC") as! UserProfileShowViewController
        destinationVC.sceneMode     =   .preview
        var destinationDS           =   destinationVC.router!.dataStore!
        destinationDS.userName      =   name
        
        navigateToUserProfileScene(source: viewController!, destination: destinationVC)
    }

    
    // MARK: - Navigation
    func navigateToSettingsShowScene(source: UserProfileShowViewController, destination: SettingsShowViewController) {
        UIApplication.shared.statusBarStyle = .default
        
        source.show(destination, sender: nil)
        viewController?.showNavigationBar()
    }
    
    func navigateToPostShowScene(source: UserProfileShowViewController, destination: PostShowViewController) {
        viewController?.hideNavigationBar()
        source.show(destination, sender: nil)
    }
    
    func navigateToPostCreateScene(source: UserProfileShowViewController, destination: PostCreateViewController) {
        source.show(destination, sender: nil)
    }

    func navigateToUserProfileScene(source: UserProfileShowViewController, destination: UserProfileShowViewController) {
        source.show(destination, sender: nil)
    }

    
    // MARK: - Passing data
    func passDataToPostShowScene(source: UserProfileShowDataStore, destination: inout PostShowDataStore) {
        destination.postShortInfo        =   source.selectedBlog
        destination.postType    =   PostsFeedType.blog
    }
    
    func passDataToPostCreateScene(postShortInfo: PostShortInfo, destination: inout PostCreateDataStore) {
        destination.commentTitle            =   postShortInfo.title
        destination.commentParentAuthor     =   postShortInfo.parentAuthor
        destination.commentParentPermlink   =   postShortInfo.parentPermlink
    }
}
