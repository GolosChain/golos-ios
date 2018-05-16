//
//  ArticleViewController.swift
//  Golos
//
//  Created by Grigory on 29/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift

class ArticleViewController: UIViewController {
    
    var authorName: String = ""
    var permalink: String = ""
    
    private var postsManager = PostsManager()
    private var post: PostModel?
    
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
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log(message: "Success", event: .severe)
        
        setupUI()
        
//        markdownView.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
        
//        let obs = markdownView.observe(\.contentSize) { (view, change) in
//            print("232")
//        }
        
//        let observation = foo.observe(\.string) { (foo, change) in
//            print("new foo.string: \(foo.string)")
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .default
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
//
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//
//
//        tableView.isHidden = false
//        let headerView = UIView()
//        headerView.addSubview(markdownView)
//        headerView.frame = markdownView.bounds
//        tableView.tableHeaderView = headerView
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        
//        postsManager.loadPost(withPermalink: permalink, authorUsername: authorName) { [weak self] postModel, error in
//            guard let strongSelf = self else { return }
//            strongSelf.post = postModel
//            strongSelf.mdView.textToMark(postModel?.body)
//            strongSelf.view.addSubview(strongSelf.mdView)
//            strongSelf.mdView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
////            strongSelf.markdownView.load(markdown: postModel?.body)
////            strongSelf.markdownView.onRendered = {height in
////                strongSelf.markdownView.isScrollEnabled = false
////
////
////                strongSelf.tableView.isHidden = false
////                let headerView = UIView()
////                headerView.addSubview(strongSelf.markdownView)
////                headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height/4)
////                strongSelf.markdownView.frame = headerView.frame
////                strongSelf.tableView.tableHeaderView = headerView
////
////            }
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    // MARK: - Custom Functions
    private func setupUI() {
        Logger.log(message: "Success", event: .severe)

        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        backButton.tintColor = UIColor.Project.backButtonBlackColor
        topBarView.addBottomShadow()
        
        mediator.configure(tableView: tableView)
        tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        
        else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
//        markdownView.isScrollEnabled = false
    }
    
    
    // MARK: - Actions
    @IBAction func backButtonPressed(_ sender: Any) {
        Logger.log(message: "Success", event: .severe)

        navigationController?.popViewController(animated: true)
    }
}
