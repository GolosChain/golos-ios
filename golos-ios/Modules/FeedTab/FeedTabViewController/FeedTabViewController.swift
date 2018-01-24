//
//  FeedTabViewController.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 21/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class FeedTabViewController: UIViewController {
    
    //MARK: Outlets properties
    @IBOutlet weak var tableView: UITableView!
    

    //MARK: Module properties
    lazy var presenter: FeedTabPresenterProtocol = {
        let presenter = FeedTabPresenter()
        presenter.feedTabView = self
        return presenter
    }()
    
    lazy var mediator: FeedTabMediator = {
        let mediator = FeedTabMediator()
        mediator.feedTabPresenter = presenter
        mediator.delegate = self
        return mediator
    }()
    
    var feedTab: FeedTab {
        get {
            return presenter.getFeedTab()
        }
        set {
            presenter.setFeedTab(newValue)
        }
    }
    
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let color: UIColor
        switch feedTab.type {
        case .hot: color = .red
        case .new: color = .blue
        case .popular: color = .green
        case .promoted: color = .magenta
        }
        view.backgroundColor = color
        
//        tableView.isHidden
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.fetchArticles()
    }

    
    //MARK: SetupUI
    private func setupUI() {
        mediator.configure(tableView: tableView)
    }
}


//MARK: FeedTabViewProtocol
extension FeedTabViewController: FeedTabViewProtocol {
    func didFetchArticles() {
        
    }
    
    func didLoadArticles() {
        
    }
}

extension FeedTabViewController: FeedTabMediatorDelegate {
    func didPressAuthor(at index: Int) {
        let profileViewController = ProfileViewController.nibInstance()
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func didPressReblogAuthor(at index: Int) {
        let profileViewController = ProfileViewController.nibInstance()
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func didPressUpvote(at index: Int) {
        Utils.inDevelopmentAlert()
    }
    
    func didPressComments(at index: Int) {
        Utils.inDevelopmentAlert()
    }
    
    func didPressExpand(at index: Int) {
        let isExpanded = presenter.isExpanded(at: index)
        presenter.makeExpanded(!isExpanded, at: index)
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
