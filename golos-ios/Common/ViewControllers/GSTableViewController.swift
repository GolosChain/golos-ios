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

class GSTableViewController: GSBaseViewController {
    // MARK: - Properties
    var reloadData: Bool        =   false
    var refreshData: Bool       =   false
    var paginanationData: Bool  =   false
    var lastIndex: Int          =   0
    var topVisibleIndexPath     =   IndexPath(row: 0, section: 0)
    
    // Handlers
    var handlerShareButtonTapped: (() -> Void)?
    var handlerAnswerButtonTapped: (() -> Void)?
    var handlerUpvotesButtonTapped: (() -> Void)?
    var handlerCommentsButtonTapped: (() -> Void)?
    var handlerReplyTypeButtonTapped: (() -> Void)?
    var handlerRefreshData: ((NSManagedObject?) -> Void)?

    private var dataSource: [NSManagedObject]?
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
            
            // Add cells from XIB
            tableView.register(UINib(nibName: tableView.cellIdentifier, bundle: nil), forCellReuseIdentifier: tableView.cellIdentifier)
            
            if #available(iOS 10.0, *) {
                tableView.refreshControl = refreshControl
            } else {
                tableView.addSubview(refreshControl)
            }
            
            self.activityIndicatorView          =   UIActivityIndicatorView.init(frame: CGRect(origin:  .zero,
                                                                                               size:    CGSize(width: tableView.frame.width, height: 64.0 * heightRatio)))
            self.activityIndicatorView.activityIndicatorViewStyle = .gray
//            self.activityIndicatorView.color    =   UIColor.blue
            self.tableView.tableHeaderView      =   self.activityIndicatorView
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
        
        if self.dataSource == nil {
            tableView.separatorStyle = .none
            self.activityIndicatorView.startAnimating()
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Custom Functions
    private func setup() {

    }
    
    func fetchUserDetails(byType type: PostsFeedType) {
        var fetchRequest: NSFetchRequest<NSFetchRequestResult>
        var primarySortDescriptor: NSSortDescriptor
        var secondarySortDescriptor: NSSortDescriptor
        
        switch type {
        // Replies
        case .reply:
            fetchRequest                =   NSFetchRequest<NSFetchRequestResult>(entityName: "Reply")
            primarySortDescriptor       =   NSSortDescriptor(key: "created", ascending: false)
            secondarySortDescriptor     =   NSSortDescriptor(key: "author", ascending: true)
            fetchRequest.predicate      =   NSPredicate(format: "parentAuthor == %@", User.current!.name)
            
        // Lenta (blogs)
        default:
            fetchRequest                =   NSFetchRequest<NSFetchRequestResult>(entityName: "Lenta")
            primarySortDescriptor       =   NSSortDescriptor(key: "created", ascending: false)
            secondarySortDescriptor     =   NSSortDescriptor(key: "author", ascending: true)
            fetchRequest.predicate      =   NSPredicate(format: "author == %@", User.current!.name)
        }
        
        fetchRequest.sortDescriptors    =   [ primarySortDescriptor, secondarySortDescriptor ]
        
        if self.lastIndex == 0 {
            fetchRequest.fetchLimit     =   Int(loadDataLimit)
        }
            
        else {
            fetchRequest.fetchLimit     =   Int(loadDataLimit) + self.lastIndex
        }
        
        fetchedResultsController        =   NSFetchedResultsController(fetchRequest:            fetchRequest,
                                                                       managedObjectContext:    CoreDataManager.instance.managedObjectContext,
                                                                       sectionNameKeyPath:      nil,
                                                                       cacheName:               nil)
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            
            // Hide activity indicator
            if self.activityIndicatorView.isAnimating {
                self.activityIndicatorView.stopAnimating()
                self.tableView.tableHeaderView = nil
            }
            
            // Refresh data
            if self.refreshData {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.9) {
                    self.refreshControl.endRefreshing()
                    self.refreshData = !self.refreshData
                    self.tableView.contentOffset = .zero
                }
            }
            
            // Reload data completion
            DispatchQueue.main.async {
                self.tableView.reloadDataWithCompletion {
                    if !self.paginanationData {
                        self.tableView.scrollToRow(at: self.topVisibleIndexPath, at: .top, animated: false)
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
        
        self.handlerRefreshData!(nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: self.tableView.cellIdentifier, for: indexPath) as! ConfigureCell
        
        let entity = fetchedResultsController.object(at: indexPath) as! NSManagedObject

        cell.setup(withItem: entity, andIndexPath: indexPath)
        
        switch entity {
        // Replies
        case let replyEntity where type(of: fetchedResultsController.object(at: indexPath)) == Reply.self:
            if let replyCell = cell as? ReplyTableViewCell {
                replyCell.setup(withItem: replyEntity, andIndexPath: indexPath)

                // Handlers comletion
                replyCell.handlerAnswerButtonTapped     =   { [weak self] in
                    self?.handlerAnswerButtonTapped!()
                }

                replyCell.handlerReplyTypeButtonTapped  =   { [weak self] in
                    self?.handlerReplyTypeButtonTapped!()
                }
            }

        // Lenta (blog)
        default:
            let lentaEntity = fetchedResultsController.object(at: indexPath) as! Lenta

            if let lentaCell = cell as? FeedArticleTableViewCell {
                lentaCell.setup(withItem: lentaEntity, andIndexPath: indexPath)

                // Handlers comletion
                lentaCell.handlerShareButtonTapped          =   { [weak self] in
                    self?.handlerShareButtonTapped!()
                }

                lentaCell.handlerUpvotesButtonTapped        =   { [weak self] in
                    self?.handlerUpvotesButtonTapped!()
                }

                lentaCell.handlerCommentsButtonTapped       =   { [weak self] in
                    self?.handlerCommentsButtonTapped!()
                }
            }
        }
        
        return cell as! UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            
            return currentSection.name
        }
        
        return nil
    }
}


// MARK: - UITableViewDelegate
extension GSTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {}
}


// MARK: - NSFetchedResultsControllerDelegate
extension GSTableViewController: NSFetchedResultsControllerDelegate {
}
