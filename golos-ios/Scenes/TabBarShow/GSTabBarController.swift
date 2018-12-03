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
        
        self.delegate = self
        
        configureViewControllers()
    }
    
    func setup() {
        UITabBar.appearance().shadowImage       =   UIImage.colorForNavBar(color: UIColor(hexString: (AppSettings.isAppThemeDark ? "#5A5A5A" : "#000000")))
        UITabBar.appearance().backgroundImage   =   UIImage.colorForNavBar(color: UIColor(hexString: (AppSettings.isAppThemeDark ? "#393636" : "#FFFFFF")))
    }
    
    private func configureViewControllers() {
//        self.setup()
        
        let postsShowNC                         =   UIStoryboard(name: "PostsShow", bundle: nil).instantiateViewController(withIdentifier: "PostsShowNC") as! UINavigationController
        postsShowNC.tabBarItem                  =   UITabBarItem(title: "", image: UIImage(named: "icon-tabbar-button-home-normal"), selectedImage: nil)
        postsShowNC.tabBarItem.tag              =   0
        postsShowNC.navigationBar.isHidden      =   true

        // Create Post
        let postCreateNC                        =   UIStoryboard(name: "PostCreate", bundle: nil).instantiateViewController(withIdentifier: "PostCreateNC")
        postCreateNC.tabBarItem                 =   UITabBarItem(title: "", image: UIImage.init(named: "icon-tabbar-button-add-normal"), selectedImage: nil)
        postCreateNC.tabBarItem.tag             =   1
        
        // User Profile
        let profileViewController               =   UIStoryboard(name: "UserProfileShow", bundle: nil).instantiateViewController(withIdentifier: "UserProfileShowVC") as! UserProfileShowViewController
        profileViewController.userProfileHeaderView.showBackButton(false)
        
        let profileNavigationController         =   UINavigationController(rootViewController: profileViewController)
        
        profileNavigationController.tabBarItem  =   UITabBarItem(title:             "",
                                                                 image:             UIImage.init(named: "icon-tabbar-button-user-profile-normal"),
                                                                 selectedImage:     nil)
        
        profileNavigationController.tabBarItem.tag  =   2
        
        viewControllers     =   [
                                    postsShowNC,
                                    postCreateNC,
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


// MARK: - UITabBarControllerDelegate
extension GSTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        selectedTabBarItem = tabBarController.selectedIndex
        self.setNeedsStatusBarAppearanceUpdate()
    }
}
