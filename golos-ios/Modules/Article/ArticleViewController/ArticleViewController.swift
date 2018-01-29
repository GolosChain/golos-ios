//
//  ArticleViewController.swift
//  Golos
//
//  Created by Grigory on 29/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
<<<<<<< HEAD
    
    
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
=======

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

>>>>>>> 6efd99ac9d383223a8580aec85b47d0dc660df6a
}
