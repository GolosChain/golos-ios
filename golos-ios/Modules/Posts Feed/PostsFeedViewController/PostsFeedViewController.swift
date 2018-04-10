//
//  FeedTabViewController.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 21/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class PostsFeedViewController: UIViewController {
    
    // MARK: Outlets properties
    @IBOutlet weak var tableView: UITableView!
    

    // MARK: Module properties
    lazy var presenter: PostsFeedPresenterProtocol = {
        let presenter = PostsFeedPresenter()
        presenter.postsFeedView = self
        return presenter
    }()
    
    lazy var mediator: PostsFeedMediator = {
        let mediator = PostsFeedMediator()
        mediator.postsFeedPresenter = presenter
        mediator.delegate = self
        return mediator
    }()
    
    var postsFeedType: PostsFeedType {
        get {
            return presenter.getPostsFeedType()
        }
        set {
            presenter.setPostsFeedType(newValue)
        }
    }
    
    class func nibInstance(with feedType: PostsFeedType) -> PostsFeedViewController {
        let viewController = super.nibInstance() as! PostsFeedViewController
        viewController.postsFeedType = feedType
        return viewController
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.fetchPosts()
        presenter.loadPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: SetupUI
    private func setupUI() {
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        mediator.configure(tableView: tableView)
        
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        tableView.tableFooterView = spinner
    }
    
    func loadingStarted() {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        
        tableView.tableFooterView?.isHidden = false
    }
}


// MARK: PostsFeedViewProtocol
extension PostsFeedViewController: PostsFeedViewProtocol {
    func didFetchPosts() {
        
    }
    
    func didLoadPosts() {
        tableView.reloadData()
        tableView.tableFooterView?.isHidden = true
    }
    
    func didLoadPostsAuthors() {
        let visibleCellsIndex = tableView.visibleCells.compactMap { cell -> IndexPath? in
            self.tableView.indexPath(for: cell)
        }
        
        tableView.beginUpdates()
        tableView.reloadRows(at: visibleCellsIndex, with: .none)
        tableView.endUpdates()
    }
    
    func didLoadPostReplies(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()
    }
    
}

extension PostsFeedViewController: PostsFeedMediatorDelegate {
    func didSelectArticle(at index: Int) {
        let articleViewController = ArticleViewController.nibInstance()
        let tuple = presenter.getPostPermalinkAndAuthorName(at: index)
        articleViewController.permalink = tuple.0
        articleViewController.authorName = tuple.1
        navigationController?.pushViewController(articleViewController, animated: true)
    }
    
    func didPressAuthor(at index: Int) {
        let user = presenter.getUser(at: index)
        let profileViewController = ProfileViewController.nibInstance()
        profileViewController.user = user
        profileViewController.username = user?.name
        
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
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            self.tableView.layer.removeAllAnimations()
            self.tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .top, animated: true)
        }) { (_) in
            
        }
    }
    
    func didScroll(tableView: UITableView) {
        delegate?.didScrollItem(self)
    }
    
    func didStartLoadingNextPage() {
        loadingStarted()
    }
}
