//
//  ArticleViewController.swift
//  Golos
//
//  Created by Grigory on 29/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
    
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
//        let tagsView = TagsView()
//        tagsView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(tagsView)
//
//        tagsView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        tagsView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        tagsView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//
//        tagsView.tagStringArray = ["sds", "d", "dsdsds", "sssdsdsdsadsdsd", "s", "ds", "sssdsdsdsadsdsd", "s", "ds" , "d", "dsdsds", "d", "dsdsds"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: "nav_bar_bg_white"), for: .default)
//        transitionCoordinator?.animateAlongsideTransition(in: nil, animation: { (context) in
//            self.navigationController?.navigationBar.barTintColor = UIColor.white
//        }, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.navigationBar.barTintColor = UIColor.Project.darkBlueHeader
//        navigationController?.navigationBar.layoutIfNeeded()
    }
    
    //MARK: SetupUI
    private func setupUI() {
        configureBackButton()
    }
}
