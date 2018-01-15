//
//  GSTabBarController.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 15/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class GSTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        let v1 = UIViewController()
        v1.view.backgroundColor = .green
        v1.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "tab_home"), selectedImage: nil)
        
        let v2 = UIViewController()
        v2.view.backgroundColor = .red
        v2.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "tab_search"), selectedImage: nil)
        
        let v3 = UIViewController()
        v3.view.backgroundColor = .red
        v3.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "tab_add"), selectedImage: nil)
        
        let v4 = UIViewController()
        v4.view.backgroundColor = .red
        v4.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "tab_notifications"), selectedImage: nil)
        
        let v5 = UIViewController()
        v5.view.backgroundColor = .red
        v5.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "tab_profile"), selectedImage: nil)
        
        viewControllers = [v1, v2, v3, v4, v5]
        
        
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
        }
    }
}
