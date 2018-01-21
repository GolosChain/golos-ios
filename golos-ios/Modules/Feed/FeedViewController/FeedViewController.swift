//
//  FeedViewController.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 15/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    //MARK: UI Outlets
    @IBOutlet weak var horizontalSelector: HorizontalSelectorView!
    
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    
    //MARK: Setup UI
    private func setupUI() {
        let items = [
            HorizontalSelectorItem(title: "Популярное"),
            HorizontalSelectorItem(title: "Актуальное"),
            HorizontalSelectorItem(title: "Новое"),
            HorizontalSelectorItem(title: "Промо")
        ]
        horizontalSelector.items = items 
        navigationController?.navigationBar.barTintColor = UIColor.Project.darkBlueHeader
//        if let navigationBar = navigationController?.navigationBar {
//            let dropDownMenu = NavigationDropDownView()
//            dropDownMenu.frame = CGRect(x: 0,
//                                        y: 0,
//                                        width: navigationBar.bounds.width,
//                                        height: navigationBar.bounds.height)
//            navigationItem.titleView = dropDownMenu
//        }
        
    //        let dropDownViewController = DropDownViewController()
    //        dropDownViewController.view.frame = dropDownViewController.view.frame.offsetBy(dx: 0, dy: 100)
    //        navigationController?.addChildViewController(dropDownViewController)
    //        navigationController?.view.addSubview(dropDownViewController.view)
    //        dropDownViewController.didMove(toParentViewController: self)
        
    }
    
}
