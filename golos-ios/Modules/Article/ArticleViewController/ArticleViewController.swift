//
//  ArticleViewController.swift
//  Golos
//
//  Created by Grigory on 29/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
    
    //Outlets properties
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var articleHeaderView: ArticleHeaderView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    

    //Module properties
    lazy var mediator: ArticleMediator = {
        let mediator = ArticleMediator()
//        mediator.feedTabPresenter = presenter
//        mediator.delegate = self
        return mediator
    }()
    
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    //MARK: SetupUI
    private func setupUI() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        backButton.tintColor = UIColor.Project.backButtonBlackColor
        topBarView.addBottomShadow()
        
        mediator.configure(tableView: tableView)
        tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    
    //MARK: Actions
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
