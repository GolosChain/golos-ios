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
        let feedViewController = FeedViewController.nibInstance()
        let feedNavigationViewController = UINavigationController(navigationBarClass: GSNavigationBar.self,
                                                                  toolbarClass: nil)
        
        feedNavigationViewController.viewControllers = [feedViewController]
        
        feedNavigationViewController.tabBarItem = UITabBarItem(title: "",
                                                     image: UIImage(named: "tab_home"),
                                                     selectedImage: nil)
       
        let vc2 = UIViewController()
        vc2.view.backgroundColor = .red
        vc2.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "tab_search"), selectedImage: nil)
        
        let vc3 = UIViewController()
        vc3.view.backgroundColor = .blue
        vc3.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "tab_add"), selectedImage: nil)
        
        let vc4 = UIViewController()
        vc4.view.backgroundColor = .orange
        vc4.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "tab_notifications"), selectedImage: nil)
        
        let profileViewController = ProfileViewController.nibInstance()
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        
        profileNavigationController.tabBarItem = UITabBarItem(title: "",
                                                              image: UIImage.init(named: "tab_profile"),
                                                              selectedImage: nil)
        
        viewControllers = [
            feedNavigationViewController,
            vc2,
            vc3,
            vc4,
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
