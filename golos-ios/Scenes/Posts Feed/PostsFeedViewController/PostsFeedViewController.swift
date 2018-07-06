//  FeedTabViewController.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 21/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift

class PostsFeedViewController: BaseViewController {
    // MARK: - Properties
    var spinner: UIActivityIndicatorView!
    
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
            return presenter.getFeedPostsType()
        }
        
        set {
            presenter.setPostsFeedType(newValue)
        }
    }
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: GSTableView!
    

    // MARK: - Class Functions
    class func nibInstance(with feedType: PostsFeedType) -> PostsFeedViewController {
        Logger.log(message: "Success", event: .severe)

        let viewController              =   super.nibInstance() as! PostsFeedViewController
        viewController.postsFeedType    =   feedType
        
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log(message: "Success", event: .severe)

        self.setupUI()
        
        // Load PostsFeed by User state
        let type        =   presenter.getFeedPostsType()
        
        let discussion  =   (User.current != nil && type == .lenta) ?   RequestParameterAPI.Discussion.init(limit:          loadDataLimit,
                                                                                                            truncateBody:   0,
                                                                                                            selectAuthors:  [ User.current!.name ]) :
                                                                        RequestParameterAPI.Discussion.init(limit:          loadDataLimit)

        self.presenter.loadPostsFeed(withType: type, andDiscussion: discussion)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Logger.log(message: "Success", event: .severe)

        self.hideNavigationBar()
        self.showSpinner()
        tableView.reloadData()
    }
    
    
    // MARK: - Custom Functions
    private func setupUI() {
        Logger.log(message: "Success", event: .severe)

        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior    =   .never
        }
        
        else {
            self.automaticallyAdjustsScrollViewInsets   =   false
        }
        
        mediator.configure(tableView: tableView)
        
//        // Create TableViewHeader/Footer with spinner
//        let spinner                 =   UIActivityIndicatorView(activityIndicatorStyle: .gray)
//        spinner.frame               =   CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: 44.0 * heightRatio)
//        tableView.tableFooterView   =   spinner
//
//        spinner.startAnimating()
        
//        self.showSpinner()
    }
    
    private func showSpinner() {
        if self.spinner == nil {
            self.spinner                =   UIActivityIndicatorView(activityIndicatorStyle: .gray)
            spinner.frame               =   CGRect(origin: .zero, size: CGSize(width: tableView.bounds.width, height: 44.0 * heightRatio))
            tableView.tableFooterView   =   self.spinner
            
            spinner.startAnimating()
        }
        
        else {
            spinner.stopAnimating()
        }
    }
    
    func loadingStarted() {
        Logger.log(message: "Success", event: .severe)

        let spinner                             =   UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.frame                           =   CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: 44.0 * heightRatio)
        tableView.tableFooterView?.isHidden     =   false
        
        spinner.startAnimating()
    }
}


// MARK: - PostsFeedViewProtocol
extension PostsFeedViewController: PostsFeedViewProtocol {
    func didFetchPosts() {
        Logger.log(message: "Success", event: .severe)
    }
    
    func didLoadPosts() {
        Logger.log(message: "Success", event: .severe)
        
        self.tableView.reloadData()
        self.tableView.tableFooterView?.isHidden = true
    }
    
    func didLoadPostsAuthors() {
        Logger.log(message: "Success", event: .severe)

        let visibleCellsIndex = tableView.visibleCells.compactMap { cell -> IndexPath? in
            self.tableView.indexPath(for: cell)
        }
        
        tableView.beginUpdates()
        tableView.reloadRows(at: visibleCellsIndex, with: .none)
        tableView.endUpdates()
    }
    
    func didLoadPostReplies(at index: Int) {
        Logger.log(message: "Success", event: .severe)

        let indexPath = IndexPath(row: index, section: 0)
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()
    }
}


// MARK: - PostsFeedMediatorDelegate
extension PostsFeedViewController: PostsFeedMediatorDelegate {
    func didSelectArticle(at index: Int) {
        Logger.log(message: "Success", event: .severe)

        let articleViewController = ArticleViewController.nibInstance()
        let tuple = presenter.getPostPermalinkAndAuthorName(at: index)
        articleViewController.permalink = tuple.0
        articleViewController.authorName = tuple.1

        navigationController?.pushViewController(articleViewController, animated: true)
    }
    
    func didPressAuthor(at index: Int) {
        Logger.log(message: "Success", event: .severe)
        
//        let user = presenter.getUser(at: index)
//        let profileViewController = ProfileViewController.nibInstance()
//        profileViewController.user = user
//        profileViewController.username = user?.name
        
//        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func didPressReblogAuthor(at index: Int) {
        Logger.log(message: "Success", event: .severe)
        
        let profileViewController = ProfileViewController.nibInstance()
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func didPressUpvote(at index: Int) {
        Logger.log(message: "Success", event: .severe)
        
        self.inDevelopmentAlert()
    }
    
    func didPressComments(at index: Int) {
        Logger.log(message: "Success", event: .severe)
        
        self.inDevelopmentAlert()
    }
    
    func didPressExpand(at index: Int) {
        Logger.log(message: "Success", event: .severe)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            self.tableView.layer.removeAllAnimations()
            self.tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .top, animated: true)
        }) { (_) in }
    }
    
    func didScroll(tableView: UITableView) {
        Logger.log(message: "Success", event: .severe)
        
        delegate?.didScrollItem(self)
    }
    
    func didStartLoadingNextPage() {
        Logger.log(message: "Success", event: .severe)
        
        loadingStarted()
    }
}
