//
//  PostsShowRouter.swift
//  golos-ios
//
//  Created by msm72 on 16.07.2018.
//  Copyright (c) 2018 golos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoloSwift

// MARK: - Input & Output protocols
@objc protocol PostsShowRoutingLogic {
    func routeToUserProfileScene(byUserName name: String)
    func routeToPostCreateScene(withType sceneType: SceneType)
    func routeToPostShowScene(withScrollToComments needScrolling: Bool)
}

protocol PostsShowDataPassing {
    var dataStore: PostsShowDataStore? { get }
}

class PostsShowRouter: NSObject, PostsShowRoutingLogic, PostsShowDataPassing {
    // MARK: - Properties
    weak var viewController: PostsShowViewController?
    var dataStore: PostsShowDataStore?
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Routing
    func routeToPostShowScene(withScrollToComments needScrolling: Bool) {
        let storyboard                  =   UIStoryboard(name: "PostShow", bundle: nil)
        let destinationVC               =   storyboard.instantiateViewController(withIdentifier: "PostShowVC") as! PostShowViewController
        destinationVC.scrollToComment   =   needScrolling
        var destinationDS               =   destinationVC.router!.dataStore!
        
        passDataToPostShowScene(source: dataStore!, destination: &destinationDS)
        navigateToPostShowScene(source: viewController!, destination: destinationVC)
    }
    
    func routeToUserProfileScene(byUserName name: String) {
        let storyboard                  =   UIStoryboard(name: "UserProfileShow", bundle: nil)
        let destinationVC               =   storyboard.instantiateViewController(withIdentifier: "UserProfileShowVC") as! UserProfileShowViewController
        destinationVC.sceneMode         =   .preview
        var destinationDS               =   destinationVC.router!.dataStore!
        
        passDataToUserProfileScene(userName: name, destination: &destinationDS)
        navigateToUserProfileScene(source: viewController!, destination: destinationVC)
    }

    func routeToPostCreateScene(withType sceneType: SceneType) {
        let storyboard                  =   UIStoryboard(name: "PostCreate", bundle: nil)
        let destinationVC               =   storyboard.instantiateViewController(withIdentifier: "PostCreateVC") as! PostCreateViewController
        destinationVC.sceneType         =   sceneType
        var destinationDS               =   destinationVC.router!.dataStore!
        
        passDataToPostCreateScene(selectedPost: self.dataStore!.postShortInfo as! PostCellSupport, destination: &destinationDS)
        navigateToPostCreateScene(source: viewController!, destination: destinationVC)
    }

    
    // MARK: - Navigation
    func navigateToPostShowScene(source: PostsShowViewController, destination: PostShowViewController) {
        viewController?.hideNavigationBar()
        source.show(destination, sender: nil)
    }
    
    func navigateToUserProfileScene(source: PostsShowViewController, destination: UserProfileShowViewController) {
        source.show(destination, sender: nil)
    }

    func navigateToPostCreateScene(source: PostsShowViewController, destination: PostCreateViewController) {
        source.show(destination, sender: nil)
    }
    
    
    // MARK: - Passing data
    func passDataToPostShowScene(source: PostsShowDataStore, destination: inout PostShowDataStore) {
        destination.postShortInfo           =   source.postShortInfo
        destination.postType                =   viewController!.postFeedTypes[viewController!.selectedIndex]
    }
    
    func passDataToUserProfileScene(userName: String, destination: inout UserProfileShowDataStore) {
        destination.userName    =   userName
    }
    
    func passDataToPostCreateScene(selectedPost: PostCellSupport, destination: inout PostCreateDataStore) {
        destination.commentTitle            =   selectedPost.title
        destination.commentParentTag        =   selectedPost.tags!.first!
        destination.commentParentAuthor     =   selectedPost.parentAuthor
        destination.commentParentPermlink   =   selectedPost.parentPermlink
    }
}
