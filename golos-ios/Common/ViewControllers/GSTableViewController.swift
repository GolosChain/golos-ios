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

typealias FetchPostParameters   =   (author: String?, postFeedType: PostsFeedType, permlink: String?, sortBy: String?)

class GSTableViewController: GSBaseViewController {
    // MARK: - Properties
    var commentsViewHeight: CGFloat = 0.0 {
        didSet {
            self.tableView.frame.size = CGSize(width: self.tableView.bounds.width, height: self.tableView.frame.height + commentsViewHeight)
        }
    }
    
    var reloadData: Bool        =   false
    var refreshData: Bool       =   false
    var paginanationData: Bool  =   false
    var lastIndex: Int          =   0
    var topVisibleIndexPath     =   IndexPath(row: 0, section: 0)
    var cellIdentifier: String  =   "PostFeedTableViewCell"
    
    var itemsCount: Int {
        guard let fetchedResultsController = self.fetchedResultsController, let sections = fetchedResultsController.sections, let first = sections.first else {
            return 0
        }
        
        return first.numberOfObjects
    }
    
    // Handlers
    var handlerShareButtonTapped: (() -> Void)?
    var handlerAnswerButtonTapped: (() -> Void)?
    var handlerUpvotesButtonTapped: (() -> Void)?
    var handlerCommentsButtonTapped: (() -> Void)?
    var handlerReplyTypeButtonTapped: (() -> Void)?
    var handlerRefreshData: ((NSManagedObject?) -> Void)?
    var handlerSelectItem: ((NSManagedObject?) -> Void)?
    var handlerUsersButtonTapped: (() -> Void)?
    var handlerAuthorProfileAddButtonTapped: (() -> Void)?
    var handlerAuthorProfileImageButtonTapped: (() -> Void)?

    // Markdown completions
    var completionCommentShowSafariURL: ((URL) -> Void)?
    var completionCommentAuthorTapped: ((String) -> Void)?

    var activityIndicatorView: UIActivityIndicatorView!

    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handlerTableViewRefresh), for: .valueChanged)
        
        return refreshControl
    }()

    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: GSTableViewWithReloadCompletion! {
        didSet {
            tableView.delegate              =   self
            tableView.dataSource            =   self
            
            tableView.tune()
            
            // Set automatic dimensions for row height
            tableView.rowHeight             =   UITableViewAutomaticDimension
            tableView.estimatedRowHeight    =   320.0 * heightRatio
            
            if #available(iOS 10.0, *) {
                tableView.refreshControl = refreshControl
            }
            
            else {
                tableView.addSubview(refreshControl)
            }
        }
    }
    
    @IBOutlet weak var commentsTableViewHeightConstraint: NSLayoutConstraint!

    
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
        
        if self.tableView != nil {
            self.displaySpinner(true)

            UIView.animate(withDuration: 0.7) {
                self.tableView.alpha = 1.0
            }
        }        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
        if self.tableView != nil {
            UIView.animate(withDuration: 0.5) {
                self.tableView.alpha = 0.0
            }
            
            self.tableView.tableHeaderView = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Custom Functions
    private func setup() {

    }
    
    private func displaySpinner(_ show: Bool) {
        guard self.activityIndicatorView == nil else {
            return
        }

        guard show else {
            self.activityIndicatorView.stopAnimating()
            self.tableView.tableHeaderView = nil
            return
        }
        
        self.activityIndicatorView      =   UIActivityIndicatorView.init(frame: CGRect(origin:  .zero,
                                                                                       size:    CGSize(width: tableView.frame.width, height: 64.0 * heightRatio)))
        self.activityIndicatorView.activityIndicatorViewStyle = .gray
//            self.activityIndicatorView.color    =   UIColor.blue
        self.tableView.separatorStyle   =   .none
        self.activityIndicatorView.startAnimating()
        
        self.tableView.tableHeaderView  =   self.activityIndicatorView
    }
    
    private func displayEmptyTitle(byType type: PostsFeedType) {
        // Add header with title
        if self.fetchedResultsController.sections![0].numberOfObjects == 0 {
            let headerView = UIView.init(frame: tableView.frame)
            headerView.tune()
            
            let titleLabel = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 200.0, height: 30.0)))
            
            titleLabel.tune(withText:       String(format: "%@ List is empty", type.caseTitle()).localized(),
                            hexColors:      darkGrayWhiteColorPickers,
                            font:           UIFont(name: "SFProDisplay-Medium", size: 13.0 * widthRatio),
                            alignment:      .center,
                            isMultiLines:   true)
            
            headerView.addSubview(titleLabel)
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20.0 * heightRatio).isActive = true
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
            
            tableView.tableHeaderView = headerView
        }
    }
    
    func fetchPosts(byParameters parameters: FetchPostParameters) {
        var fetchRequest: NSFetchRequest<NSFetchRequestResult>
        var primarySortDescriptor: NSSortDescriptor
        var secondarySortDescriptor: NSSortDescriptor

        fetchRequest    =   NSFetchRequest<NSFetchRequestResult>(entityName: parameters.postFeedType.caseTitle())

        switch parameters.postFeedType {
        // Replies
        case .reply:
            if let author = parameters.author {
                fetchRequest.predicate  =   NSPredicate(format: "parentAuthor == %@", author)
            }
            
        // Blog
        case .blog:
            if let author = parameters.author {
                fetchRequest.predicate  =   NSPredicate(format: "author == %@", author)
            }

        case .lenta:
            if let author = parameters.author {
                fetchRequest.predicate  =   NSPredicate(format: "userName == %@", author)
            }
            
        // Popular, Actual, New, Promo
        default:
            break
        }
        
        primarySortDescriptor           =   NSSortDescriptor(key: parameters.sortBy ?? "created", ascending: false)
        secondarySortDescriptor         =   NSSortDescriptor(key: "author", ascending: true)
        fetchRequest.sortDescriptors    =   [ primarySortDescriptor, secondarySortDescriptor ]
        
        if self.lastIndex == 0 {
            fetchRequest.fetchLimit     =   Int(loadDataLimit)            
        }
            
        else {
            fetchRequest.fetchLimit     =   Int(loadDataLimit) + self.lastIndex
        }
     
        self.run(fetchRequest: fetchRequest, postType: parameters.postFeedType)
    }
        
    private func run(fetchRequest: NSFetchRequest<NSFetchRequestResult>, postType: PostsFeedType) {
        fetchedResultsController        =   NSFetchedResultsController(fetchRequest:            fetchRequest,
                                                                       managedObjectContext:    CoreDataManager.instance.managedObjectContext,
                                                                       sectionNameKeyPath:      nil,
                                                                       cacheName:               nil)
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            
            // Refresh data
            if self.refreshData {                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.9) {
                    self.refreshData = !self.refreshData
                    self.tableView.contentOffset = .zero
                    self.refreshControl.endRefreshing()
                }
            }
            
            // Reload data completion
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                self.tableView?.reloadDataWithCompletion {
                    Logger.log(message: "Load data is finished!!!", event: .debug)
                    
                    // Hide activity indicator
                    self.displaySpinner(false)
                    self.tableView.layoutIfNeeded()
                    
                    if self.fetchedResultsController.sections![0].numberOfObjects == 0 {
                        self.displayEmptyTitle(byType: postType)
                    }

                    else {
                        self.tableView.tableHeaderView = nil
                    }
                }
            }
        } catch {
            Logger.log(message: error.localizedDescription, event: .error)
        }
    }

    func clearTableView() {
        self.reloadData = !self.reloadData
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    
    // MARK: - Actions
    @objc func handlerTableViewRefresh(refreshControl: UIRefreshControl) {
        self.refreshData            =   !self.refreshData
        self.paginanationData       =   false
        self.lastIndex              =   0
        self.topVisibleIndexPath    =   IndexPath(row: 0, section: 0)
        
        if self.handlerRefreshData != nil {
            self.handlerRefreshData!(nil)
        }
    }
}


// MARK: - UIScrollViewDelegate
extension GSTableViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let indexPathsForVisibleRows = self.tableView.indexPathsForVisibleRows, scrollView == tableView, indexPathsForVisibleRows.count > 0 {
            self.topVisibleIndexPath    =   indexPathsForVisibleRows[0]
            self.paginanationData       =   false
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
        guard !reloadData else {
            reloadData = !reloadData
            return 0
        }
        
        let sectionInfo = fetchedResultsController.sections![section]
        
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard self.fetchedResultsController.sections![indexPath.section].numberOfObjects > 0 else {
            return UITableViewCell()
        }
        
        let entity  =   fetchedResultsController.object(at: indexPath) as! NSManagedObject
        let cell    =   tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)

        (cell as! ConfigureCell).setup(withItem: entity, andIndexPath: indexPath)

        // Handlers Reply comletion
        if type(of: entity) == Reply.self {
            (cell as! ReplyTableViewCell).handlerAnswerButtonTapped         =   { [weak self] in
                self?.handlerAnswerButtonTapped!()
            }
            
            (cell as! ReplyTableViewCell).handlerReplyTypeButtonTapped      =   { [weak self] in
                self?.handlerReplyTypeButtonTapped!()
            }
        }
        
        // Handlers Lenta, Blog, Popular, Actual, New, Promo comletion
        else {
            (cell as! PostFeedTableViewCell).handlerShareButtonTapped       =   { [weak self] in
                self?.handlerShareButtonTapped!()
            }
            
            (cell as! PostFeedTableViewCell).handlerUpvotesButtonTapped     =   { [weak self] in
                self?.handlerUpvotesButtonTapped!()
            }
            
            (cell as! PostFeedTableViewCell).handlerCommentsButtonTapped    =   { [weak self] in
                self?.handlerCommentsButtonTapped!()
            }
        }
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension GSTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard self.fetchedResultsController.sections![indexPath.section].numberOfObjects > 0 else {
            return
        }
        
        let lastItemIndex   =   tableView.numberOfRows(inSection: indexPath.section) - 1
        let lastElement     =   fetchedResultsController.sections![indexPath.section].objects![lastIndex] as! NSManagedObject
        
        // Pagination
        if lastItemIndex == indexPath.row && lastItemIndex > self.lastIndex {
            if let indexPathsForVisibleRows = self.tableView.indexPathsForVisibleRows, indexPathsForVisibleRows.count > 0 {
                self.topVisibleIndexPath    =   indexPathsForVisibleRows[0]
            }
            
            self.lastIndex          =   lastItemIndex
            self.paginanationData   =   true
            
            self.handlerRefreshData!(lastElement)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedElement = fetchedResultsController.sections![indexPath.section].objects![indexPath.row] as? NSManagedObject {
            self.handlerSelectItem!(selectedElement)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {}
}


// MARK: - NSFetchedResultsControllerDelegate
extension GSTableViewController: NSFetchedResultsControllerDelegate {
}
