//
//  GSTabBarController.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 15/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class GSTabBarController: UITabBarController {
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
       
        configureViewControllers()
    }
    
    private func configureViewControllers() {
        let postsShowNC                     =   UIStoryboard(name: "PostsShow", bundle: nil).instantiateViewController(withIdentifier: "PostsShowNC") as! UINavigationController
        postsShowNC.tabBarItem              =   UITabBarItem(title: "", image: UIImage(named: "icon-tabbar-button-home-normal"), selectedImage: nil)
        postsShowNC.tabBarItem.tag          =   0
        postsShowNC.navigationBar.isHidden  =   true

        /*
        let vc2                     =   UIViewController()
        vc2.view.backgroundColor    =   .red
        vc2.tabBarItem              =   UITabBarItem(title: "", image: UIImage.init(named: "icon-tabbar-button-search-normal"), selectedImage: nil)
         vc2.tabBarItem.tag         =   1
         */
        
        // Create Post
        let postCreateNC            =   UIStoryboard(name: "PostCreate", bundle: nil).instantiateViewController(withIdentifier: "PostCreateNC")
        postCreateNC.tabBarItem     =   UITabBarItem(title: "", image: UIImage.init(named: "icon-tabbar-button-add-normal"), selectedImage: nil)
        postCreateNC.tabBarItem.tag =   2
        
        
        /*
        // Notifications
        let vc4                     =   UIViewController()
        vc4.view.backgroundColor    =   .orange
        vc4.tabBarItem              =   UITabBarItem(title: "", image: UIImage.init(named: "icon-tabbar-button-notifications-normal"), selectedImage: nil)
         vc4.tabBarItem.tag          =   3
        */
        
        // User Profile
        let profileViewController               =   UIStoryboard(name: "UserProfileShow", bundle: nil).instantiateViewController(withIdentifier: "UserProfileShowVC") as! UserProfileShowViewController
        profileViewController.userProfileHeaderView.showBackButton(false)
        
//        let profileViewController               =   ProfileViewController.nibInstance()
        let profileNavigationController         =   UINavigationController(rootViewController: profileViewController)
        
        profileNavigationController.tabBarItem  =   UITabBarItem(title:             "",
                                                                 image:             UIImage.init(named: "icon-tabbar-button-user-profile-normal"),
                                                                 selectedImage:     nil)
        
        profileNavigationController.tabBarItem.tag  =   4
        
        viewControllers     =   [
                                    postsShowNC,
//                                    vc2,
                                    postCreateNC,
//                                    vc4,
                                    profileNavigationController
                                ]
    }
    
    override var viewControllers: [UIViewController]? {
        didSet {
            customizeTabBarItems()
        }
    }
    
    private func customizeTabBarItems() {
        guard let items = tabBar.items else {return}
       
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 30)
        }
    }
}
