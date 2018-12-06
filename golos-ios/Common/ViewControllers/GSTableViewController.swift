//
//  GSTableViewController.swift
//  Golos
//
//  Created by msm72 on 16.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import CoreData
import GoloSwift
import SwiftTheme
import SafariServices

typealias FetchPostParameters = (author: String?, postFeedType: PostsFeedType, permlink: String?, sortBy: String?, entries: [BlogEntry]?)

class GSTableViewController: GSBaseViewController, HandlersCellSupport {
    // MARK: - Properties
    var postsTableView: GSTableViewWithReloadCompletion! {
        didSet {
            self.postsTableView.register(UINib(nibName: self.cellIdentifier, bundle: nil), forCellReuseIdentifier: self.cellIdentifier)

            self.postsTableView.delegate    =   self
            self.postsTableView.dataSource  =   self
            
            self.postsTableView.tableFooterView?.isHidden = true
            
            self.postsTableView.tune()

            // Set automatic dimensions for row height
            self.postsTableView.rowHeight = UITableView.automaticDimension
            self.postsTableView.estimatedRowHeight = 320.0 * heightRatio
            
            if #available(iOS 10.0, *) {
                self.postsTableView.refreshControl = refreshControl
            }
                
            else {
                self.postsTableView.addSubview(refreshControl)
            }
        }
    }
    
    var refreshData: Bool       =   false
    var infiniteScrollingData   =   false
    var lastIndex: Int          =   0
    var topVisibleIndexPath     =   IndexPath(row: 0, section: 0)
    var cellIdentifier: String  =   "PostFeedTableViewCell"
    
    var postType: PostsFeedType!
    var postsList: [NSManagedObject]?
    var blogEntries: [BlogEntry]?
    
    // Handlers
    var handlerAnswerButtonTapped: ((PostShortInfo?) -> Void)?
    var handlerReplyTypeButtonTapped: ((Bool) -> Void)?
    var handlerPushRefreshData: ((NSManagedObject?) -> Void)?
    var handlerSelectItem: ((PostShortInfo) -> Void)?
    var handlerUsersButtonTapped: (() -> Void)?
    var handlerAuthorProfileAddButtonTapped: (() -> Void)?
    var handlerAuthorProfileImageButtonTapped: ((String) -> Void)?
    var handlerHorizontalScrolling: ((CGFloat) -> Void)?

    // HandlersCellSupport
    var handlerLikeButtonTapped: ((Bool, PostShortInfo) -> Void)?
    var handlerRepostButtonTapped: (() -> Void)?
    var handlerDislikeButtonTapped: ((Bool, PostShortInfo) -> Void)?
    var handlerCommentsButtonTapped: ((PostShortInfo) -> Void)?
    var handlerLikeCountButtonTapped: ((PostShortInfo) -> Void)?
    var handlerDislikeCountButtonTapped: ((PostShortInfo) -> Void)?

    
    // Markdown completions
    var completionCommentShowSafariURL: ((URL) -> Void)?
    var completionCommentAuthorTapped: ((String) -> Void)?

    var activityIndicatorView: UIActivityIndicatorView!
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        refreshControl.tintColor = UIColor(hexString: AppSettings.isAppThemeDark ? "#FFFFFF" : "#DBDBDB")
        refreshControl.addTarget(self, action: #selector(handlerTableViewRefreshData), for: .valueChanged)

        return refreshControl
    }()

    
    // MARK: - IBOutlets
    @IBOutlet weak var commentsTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var infiniteScrollingView: UIView! {
        didSet {
            self.infiniteScrollingView.tune()
            self.infiniteScrollingView.isHidden = true
        }
    }
    
    @IBOutlet weak var infiniteScrollingActivityIndicatorView: UIActivityIndicatorView! {
        didSet {
            self.infiniteScrollingActivityIndicatorView.stopAnimating()
        }
    }
    
    @IBOutlet weak var infiniteScrollingViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            self.infiniteScrollingViewHeightConstraint.constant = 44.0 * heightRatio
        }
    }


    // MARK: - Class Initialization
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.postsTableView != nil {
            self.displaySpinner(self.activityIndicatorView == nil)
            
            UIView.animate(withDuration: 0.7) {
                self.postsTableView.alpha = 1.0
            }
        }        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
        if self.postsTableView != nil {
            UIView.animate(withDuration: 0.5) {
                self.postsTableView.alpha = 0.0
            }
            
            self.postsTableView.tableHeaderView?.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Custom Functions
    private func setup() {

    }
    
    private func displaySpinner(_ show: Bool) {
        DispatchQueue.main.async {
            guard show else {
                self.activityIndicatorView.stopAnimating()
                self.postsTableView.tableHeaderView?.isHidden = true
                self.postsTableView.tableHeaderView = nil

                return
            }
            
            self.activityIndicatorView  =   UIActivityIndicatorView.init(frame: CGRect(origin:  .zero,
                                                                                       size:    CGSize(width: self.postsTableView.frame.width, height: 64.0 * heightRatio)))
            self.activityIndicatorView.style                =   AppSettings.isAppThemeDark ? .white : .gray
            self.postsTableView.separatorStyle              =   .none
            self.postsTableView.tableHeaderView             =   self.activityIndicatorView
            self.postsTableView.tableHeaderView?.isHidden   =   false

            self.activityIndicatorView.startAnimating()
        }
    }
    
    private func displayEmptyTitle(byType type: PostsFeedType) {
        // Add header with title
        if self.fetchedResultsController.sections![0].numberOfObjects == 0 {
            let headerView = UIView.init(frame: self.postsTableView.frame)
            headerView.tune()
            
            let titleLabel = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 200.0, height: 30.0)))
            
            titleLabel.tune(withText:       String(format: "%@ List is empty", type.caseTitle()).localized(),
                            hexColors:      darkGrayWhiteColorPickers,
                            font:           UIFont(name: "SFProDisplay-Medium", size: 13.0),
                            alignment:      .center,
                            isMultiLines:   true)
            
            headerView.addSubview(titleLabel)
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20.0 * heightRatio).isActive = true
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
            
            self.postsTableView.tableHeaderView = headerView
        }
    }
    
    func fetchPosts(byParameters parameters: FetchPostParameters) {
        var fetchRequest: NSFetchRequest<NSFetchRequestResult>

        self.blogEntries    =   parameters.entries
        self.postType       =   parameters.postFeedType
        fetchRequest        =   NSFetchRequest<NSFetchRequestResult>(entityName: parameters.postFeedType.caseTitle())

        switch parameters.postFeedType {
        // Replies
        case .reply:
            if let author = parameters.author {
                fetchRequest.predicate = NSPredicate(format: "parentAuthor == %@", author)
            }
            
        // Blog
        case .blog:
            if let author = parameters.author {
                fetchRequest.predicate = NSPredicate(format: "authorReblog == %@", author)
            }

        // Lenta
        case .lenta:
            if let author = parameters.author {
                fetchRequest.predicate = NSPredicate(format: "userNickName == %@", author)
            }

        // Popular, Actual, New, Promo
        default:
            break
        }

        fetchRequest.sortDescriptors = []

        if self.lastIndex == 0 {
            fetchRequest.fetchLimit = Int(loadDataLimit)
        }
            
        else {
            fetchRequest.fetchLimit = Int(loadDataLimit) + self.lastIndex
        }
     
        self.run(fetchRequest: fetchRequest)
    }
        
    private func run(fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        fetchedResultsController    =   NSFetchedResultsController(fetchRequest:            fetchRequest,
                                                                   managedObjectContext:    CoreDataManager.instance.managedObjectContext,
                                                                   sectionNameKeyPath:      nil,
                                                                   cacheName:               nil)
        
        fetchedResultsController.delegate = self
        
        // Pull to refresh data
        do {
            try self.fetchedResultsController.performFetch()
            
            if self.refreshData {
                self.postsTableView.contentOffset = .zero
                self.refreshControl.endRefreshing()
                
                self.loadDataFinished()
            }
                
                // Infinite scrolling data
            else {
                self.loadDataFinished()
            }
        } catch {
            Logger.log(message: error.localizedDescription, event: .error)
        }
    }

    func loadDataFinished() {
        DispatchQueue.main.async {
            self.postsTableView?.reloadDataWithCompletion {
                Logger.log(message: "Load data is finished!!!", event: .debug)
                
                guard self.fetchedResultsController != nil else {
                    return
                }
                
                // Hide activity indicator
                self.displaySpinner(false)
                
                if self.fetchedResultsController.fetchedObjects?.count == 0 {
                    self.displayEmptyTitle(byType: self.postType)
                }
                
                // Infinite scrolling: update new cells
//                if self.lastIndex > 0 {
//                    self.postsTableView.beginUpdates()
//
//                    for index in 0 ..< (loadDataLimit - 1) {
//                        self.postsTableView.insertRows(at: [IndexPath(row: self.lastIndex + Int(index), section: 0)], with: .none)
//                    }
//
//                    self.postsTableView.endUpdates()
//                }
                
                self.refreshData            =   false
                self.infiniteScrollingData  =   false                
            }
        }
    }
    
    func clearTableView() {
        self.refreshData = true

        DispatchQueue.main.async {
            self.postsTableView.reloadData()
        }
    }
    
    
    // MARK: - Actions
    @objc func handlerTableViewRefreshData(refreshControl: UIRefreshControl) {
        guard isNetworkAvailable else {
            return
        }

        self.refreshData            =   true
        self.infiniteScrollingData  =   false
        self.lastIndex              =   0
        self.topVisibleIndexPath    =   IndexPath(row: 0, section: 0)
        
        // Clean CoreData entities
        DispatchQueue.main.async {
            CoreDataManager.instance.deleteEntities(withName: self.postType.rawValue.uppercaseFirst, andPredicateParameters: nil, completion: { [weak self] success in
                if success && self?.handlerPushRefreshData != nil {
                    self?.handlerPushRefreshData!(nil)
                }
            })
        }
    }
}


// MARK: - UIScrollViewDelegate
extension GSTableViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.postsTableView else {
            self.handlerHorizontalScrolling!(scrollView.contentOffset.x)
            return
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == self.postsTableView else {
            self.handlerHorizontalScrolling!(scrollView.contentOffset.x)
            return
        }
        
        if let indexPathsForVisibleRows = self.postsTableView.indexPathsForVisibleRows, indexPathsForVisibleRows.count > 0 {
            self.topVisibleIndexPath    =   indexPathsForVisibleRows[0]
            self.infiniteScrollingData  =   false
        }
    }
}


// MARK: - UITableViewDataSource
extension GSTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard fetchedResultsController != nil else {
            return 0
        }
        
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo =   fetchedResultsController.sections![section]
        
        guard let posts = sectionInfo.objects as? [NSManagedObject], posts.count > 0 else {
            return 0
        }
       
        self.postsList = posts
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell    =   self.postsTableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        let entity  =   self.postsList![indexPath.row]
        
        // Blog entries
        if type(of: entity) == Blog.self, let entries = self.blogEntries, entries.count > 0, let blog = entity as? Blog, let entry = entries.first(where: { $0.permlink == blog.permlink }) {
            (cell as! ConfigureCell).setup(withItem: entity, andIndexPath: indexPath, blogEntry: entry)
        }
            
        else {
            (cell as! ConfigureCell).setup(withItem: entity, andIndexPath: indexPath, blogEntry: nil)
        }
        
        // Handlers Reply comletion
        if type(of: entity) == Reply.self {
            (cell as! ReplyTableViewCell).handlerAnswerButtonTapped         =   { [weak self] postShortInfo in
                self?.handlerAnswerButtonTapped!(postShortInfo)
            }
            
            (cell as! ReplyTableViewCell).handlerReplyTypeButtonTapped      =   { [weak self] isOperationAvailable in
                self?.handlerReplyTypeButtonTapped!(isOperationAvailable)
            }

            (cell as! ReplyTableViewCell).handlerAuthorCommentReplyTapped   =   { [weak self] authorName in
                self?.handlerAuthorProfileImageButtonTapped!(authorName)
            }
            
            // Markdown handlers
            (cell as! ReplyTableViewCell).handlerMarkdownError              =   { [weak self] errorMessage in
                self?.showAlertView(withTitle: "Error", andMessage: errorMessage, needCancel: false, completion: { _ in })
            }
            
            (cell as! ReplyTableViewCell).handlerMarkdownURLTapped          =   { [weak self] url in
                self?.openExternalLink(byURL: url.absoluteString)
            }

            (cell as! ReplyTableViewCell).handlerMarkdownAuthorNameTapped   =   { [weak self] authorName in
                self?.handlerAuthorProfileImageButtonTapped!(authorName)
            }
        }
        
        // Handlers Lenta, Blog, Popular, Actual, New, Promo comletion
        else {
            (cell as! PostFeedTableViewCell).handlerRepostButtonTapped      =   { [weak self] in
                self?.handlerRepostButtonTapped!()
            }
            
            (cell as! PostFeedTableViewCell).handlerLikeButtonTapped        =   { [weak self] (isLike, postShortInfo) in
                let model = self?.fetchedResultsController.object(at: postShortInfo.indexPath!) as! PostCellSupport

                self?.handlerLikeButtonTapped!(isLike, PostShortInfo(id:                        model.id,
                                                                     title:                     model.title,
                                                                     author:                    model.author,
                                                                     permlink:                  model.permlink,
                                                                     parentTag:                 model.tags?.first,
                                                                     indexPath:                 postShortInfo.indexPath,
                                                                     parentAuthor:              model.parentAuthor,
                                                                     parentPermlink:            model.parentPermlink,
                                                                     activeVotes:               model.likeCount,
                                                                     nsfwPath:                  postShortInfo.nsfwPath,
                                                                     isPosted:                  postShortInfo.isPosted))
            }

            (cell as! PostFeedTableViewCell).handlerLikeCountButtonTapped   =   { [weak self] postShortInfo in
                let model = self?.fetchedResultsController.object(at: postShortInfo.indexPath!) as! PostCellSupport
                
                self?.handlerLikeCountButtonTapped!(PostShortInfo(id:                           model.id,
                                                                  title:                        model.title,
                                                                  author:                       model.author,
                                                                  permlink:                     model.permlink,
                                                                  parentTag:                    model.tags?.first,
                                                                  indexPath:                    postShortInfo.indexPath,
                                                                  parentAuthor:                 model.parentAuthor,
                                                                  parentPermlink:               model.parentPermlink,
                                                                  activeVotes:                  model.likeCount,
                                                                  nsfwPath:                     postShortInfo.nsfwPath,
                                                                  isPosted:                     postShortInfo.isPosted))
            }

            (cell as! PostFeedTableViewCell).handlerDislikeButtonTapped     =   { [weak self] (isDislike, postShortInfo) in
                let model = self?.fetchedResultsController.object(at: postShortInfo.indexPath!) as! PostCellSupport
                
                self?.handlerDislikeButtonTapped!(isDislike, PostShortInfo(id:                  model.id,
                                                                           title:               model.title,
                                                                           author:              model.author,
                                                                           permlink:            model.permlink,
                                                                           parentTag:           model.tags?.first,
                                                                           indexPath:           postShortInfo.indexPath,
                                                                           parentAuthor:        model.parentAuthor,
                                                                           parentPermlink:      model.parentPermlink,
                                                                           activeVotes:         model.likeCount,
                                                                           nsfwPath:            postShortInfo.nsfwPath,
                                                                           isPosted:            postShortInfo.isPosted))
            }
            
            (cell as! PostFeedTableViewCell).handlerDislikeCountButtonTapped =   { [weak self] postShortInfo in
                let model = self?.fetchedResultsController.object(at: postShortInfo.indexPath!) as! PostCellSupport
                
                self?.handlerDislikeCountButtonTapped!(PostShortInfo(id:                        model.id,
                                                                     title:                     model.title,
                                                                     author:                    model.author,
                                                                     permlink:                  model.permlink,
                                                                     parentTag:                 model.tags?.first,
                                                                     indexPath:                 postShortInfo.indexPath,
                                                                     parentAuthor:              model.parentAuthor,
                                                                     parentPermlink:            model.parentPermlink,
                                                                     activeVotes:               model.likeCount,
                                                                     nsfwPath:                  postShortInfo.nsfwPath,
                                                                     isPosted:                  postShortInfo.isPosted))
            }
            
            (cell as! PostFeedTableViewCell).handlerCommentsButtonTapped    =   { [weak self] postShortInfo in
                let model = self?.postsList![indexPath.row] as! PostCellSupport

                self?.handlerCommentsButtonTapped!(PostShortInfo(id:                            model.id,
                                                                 title:                         model.title,
                                                                 author:                        model.author,
                                                                 permlink:                      model.permlink,
                                                                 parentTag:                     model.tags?.first,
                                                                 indexPath:                     postShortInfo.indexPath,
                                                                 parentAuthor:                  model.parentAuthor,
                                                                 parentPermlink:                model.parentPermlink,
                                                                 activeVotes:                   model.likeCount,
                                                                 nsfwPath:                      postShortInfo.nsfwPath,
                                                                 isPosted:                      postShortInfo.isPosted))
            }

            (cell as! PostFeedTableViewCell).handlerAuthorPostSelected      =   { [weak self] userName in
                self?.handlerAuthorProfileImageButtonTapped!(userName)
            }
        }
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension GSTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let posts = self.postsList, posts.count > 0 else {
            return
        }
        
        let lastItemIndex = self.postsTableView.numberOfRows(inSection: indexPath.section) - 1
        
        // Pagination: Infinite scrolling data
        if lastItemIndex == indexPath.row && lastItemIndex > self.lastIndex {
            if let indexPathsForVisibleRows = self.postsTableView.indexPathsForVisibleRows, indexPathsForVisibleRows.count > 0 {
                self.topVisibleIndexPath    =   indexPathsForVisibleRows[0]
            }
            
            self.lastIndex                  =   lastItemIndex
            let lastElement                 =   posts[self.lastIndex]
            self.infiniteScrollingData      =   true

            self.handlerPushRefreshData!(lastElement)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = self.postsList?[indexPath.row] as? PostCellSupport, type(of: model) != Reply.self {
            let cellSelected = tableView.cellForRow(at: indexPath) as! PostFeedTableViewCell
            
            self.handlerSelectItem!(PostShortInfo(id:               model.id,
                                                  title:            model.title,
                                                  author:           model.author,
                                                  permlink:         model.permlink,
                                                  parentTag:        model.tags?.first,
                                                  indexPath:        indexPath,
                                                  parentAuthor:     model.parentAuthor,
                                                  parentPermlink:   model.parentPermlink,
                                                  activeVotes:      model.likeCount,
                                                  nsfwPath:         cellSelected.postImageView.accessibilityIdentifier,
                                                  isPosted:         cellSelected.postShortInfo.isPosted))
        }
    }
}


// MARK: - NSFetchedResultsControllerDelegate
extension GSTableViewController: NSFetchedResultsControllerDelegate {
}
