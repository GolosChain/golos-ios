//
//  PostsShowViewController.swift
//  golos-ios
//
//  Created by msm72 on 16.07.2018.
//  Copyright (c) 2018 golos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import CoreData
import GoloSwift
import SwiftTheme
import SJSegmentedScrollView

// MARK: - Input & Output protocols
protocol PostsShowDisplayLogic: class {
    func displayLoadPosts(fromViewModel viewModel: PostsShowModels.Items.ViewModel)
}

class PostsShowViewController: GSTableViewController, ContainerViewSupport {
    // MARK: - Properties
    var selectedSegmentIndex = 0
    var postFeedTypes: [PostsFeedType]  =   User.current == nil ?   [ .popular, .actual, .new, .promoted ] :
                                                                    [ .lenta, .popular, .actual, .new, .promoted ]

    var interactor: PostsShowBusinessLogic?
    var router: (NSObjectProtocol & PostsShowRoutingLogic & PostsShowDataPassing)?
    
    var selectedSegment: SJSegmentTab?
    var segmentedViewController: SJSegmentedViewController!
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var statusBarView: UIView! {
        didSet {
            statusBarView.tune(withThemeColorPicker: darkModerateBlueColorPickers)
        }
    }
    
    @IBOutlet weak var controlView: UIView! {
        didSet {
            controlView.tune(withThemeColorPicker: darkModerateBlueColorPickers)
        }
    }
    

    // ContainerViewSupport implementation
    @IBOutlet weak var containerView: GSContainerView! {
        didSet {
            containerView.mainVC            =   self
            
            containerView.viewControllers   =   self.getContainerViewControllers()

            containerView.setActiveViewController(index: 0)
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
    
    
    // MARK: - Setup
    private func setup() {
        let viewController          =   self
        let interactor              =   PostsShowInteractor()
        let presenter               =   PostsShowPresenter()
        let router                  =   PostsShowRouter()
        
        viewController.interactor   =   interactor
        viewController.router       =   router
        interactor.presenter        =   presenter
        presenter.viewController    =   viewController
        router.viewController       =   viewController
        router.dataStore            =   interactor
    }
    
    
    // MARK: - Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideNavigationBar()
        self.loadViewSettings()
        self.setupSegmentedControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .lightContent
     
        // Load Posts
        self.loadPosts(false)
    }
    
    
    // MARK: - Custom Functions
    private func loadViewSettings() {
        self.view.tune()
    }
    
    private func setActiveViewControllerHandlers() {
        if let activeVC = self.containerView.activeVC {
            activeVC.handlerAnswerButtonTapped      =   { [weak self] in
                self?.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
            }
            
            activeVC.handlerReplyTypeButtonTapped   =   { [weak self] in
                self?.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
            }
            
            activeVC.handlerShareButtonTapped       =   { [weak self] in
                self?.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
            }
            
            activeVC.handlerUpvotesButtonTapped     =   { [weak self] in
                self?.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
            }
            
            activeVC.handlerCommentsButtonTapped    =   { [weak self] in
                self?.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
            }
        }
    }
    
    private func getContainerViewControllers() -> [GSTableViewController] {
        let tableViewController1    =   UIStoryboard(name: "PostsShow", bundle: nil)
            .instantiateViewController(withIdentifier: "UserProfileLentaShowVC") as! GSTableViewController
        tableViewController1.title  =   "Lenta".localized()
        tableViewController1.cellIdentifier =   "FeedArticleTableViewCell"
        
        let tableViewController2    =   UIStoryboard(name: "PostsShow", bundle: nil)
            .instantiateViewController(withIdentifier: "PopularPostsShowVC") as! GSTableViewController
        tableViewController2.title              =   "Popular".localized()
        tableViewController2.cellIdentifier     =   "PopularPostTableViewCell"
        
        let tableViewController3    =   UIStoryboard(name: "PostsShow", bundle: nil)
            .instantiateViewController(withIdentifier: "UserProfileLentaShowVC") as! GSTableViewController
        tableViewController3.title              =   "Actual".localized()
        tableViewController3.cellIdentifier     =   "ActualPostTableViewCell"
        
        let tableViewController4    =   UIStoryboard(name: "PostsShow", bundle: nil)
            .instantiateViewController(withIdentifier: "NewPostsShowVC") as! GSTableViewController
        tableViewController4.title              =   "New".localized()
        tableViewController4.cellIdentifier     =   "NewPostTableViewCell"
        
        let tableViewController5    =   UIStoryboard(name: "PostsShow", bundle: nil)
            .instantiateViewController(withIdentifier: "UserProfileLentaShowVC") as! GSTableViewController
        tableViewController5.title              =   "Promoted".localized()
        tableViewController5.cellIdentifier     =   "PromoPostTableViewCell"
        
        let segmentControllers      =   User.current == nil ?   [ tableViewController2, tableViewController3, tableViewController4, tableViewController5 ] :
            [ tableViewController1, tableViewController2, tableViewController3, tableViewController4, tableViewController5 ]

        return segmentControllers
    }
    
    private func setupSegmentedControl() {
        let segmentControllers      =   self.getContainerViewControllers()
        let headerViewController    =   User.current == nil ? segmentControllers[1] : segmentControllers[0]
        
        segmentedViewController     =   SJSegmentedViewController(headerViewController:     headerViewController,
                                                                  segmentControllers:       segmentControllers)
        
        segmentedViewController.headerViewHeight                =   0.0
        segmentedViewController.segmentViewHeight               =   34.0 * heightRatio
        segmentedViewController.selectedSegmentViewHeight       =   2.0 * heightRatio
        segmentedViewController.headerViewOffsetHeight          =   0.0
        segmentedViewController.segmentTitleColor               =   UIColor(hexString: "#D6D6D6")
        segmentedViewController.selectedSegmentViewColor        =   UIColor(hexString: "#FFFFFF")
        segmentedViewController.showsHorizontalScrollIndicator  =   false
        segmentedViewController.showsVerticalScrollIndicator    =   false
        segmentedViewController.segmentBounces                  =   true
        segmentedViewController.segmentTitleFont                =   UIFont(name: "SFProDisplay-Medium", size: 13.0 * widthRatio)!
        segmentedViewController.segmentBackgroundColor          =   UIColor(hexString: "#4469AF")
        segmentedViewController.segmentShadow                   =   SJShadow.dark()
        
        segmentedViewController.delegate                        =   self
        
        controlView.addSubview(segmentedViewController.view)
    }
}


// MARK: - PostsShowDisplayLogic
extension PostsShowViewController: PostsShowDisplayLogic {
    func displayLoadPosts(fromViewModel viewModel: PostsShowModels.Items.ViewModel) {
        // NOTE: Display the result from the Presenter
        if let error = viewModel.error {
            self.showAlertView(withTitle: "Error", andMessage: error.localizedDescription, needCancel: false, completion: { _ in })
        }
        
        // CoreData
        self.fetchPosts()
    }
}


// MARK: - Load data from Blockchain by API
extension PostsShowViewController {
    private func loadPosts(_ isRefresh: Bool) {
//        if let activeVC = self.containerView.activeVC, activeVC.fetchedResultsController == nil || isRefresh {
            let loadPostsRequestModel = PostsShowModels.Items.RequestModel(postFeedType: self.postFeedTypes[self.selectedSegmentIndex])
            interactor?.loadPosts(withRequestModel: loadPostsRequestModel)
//        }
    }
}


// MARK: - Fetch data from CoreData
extension PostsShowViewController {
    // User Profile
    private func fetchPosts() {
        if let activeVC = self.containerView.activeVC {
            // Add cells from XIB
            activeVC.tableView.register(UINib(nibName: activeVC.cellIdentifier, bundle: nil), forCellReuseIdentifier: activeVC.cellIdentifier)
            activeVC.fetchPosts(byType: postFeedTypes[self.selectedSegmentIndex])
            
            // Handler Refresh/Upload data
            activeVC.handlerRefreshData  =   { [weak self] lastItem in
                self?.interactor?.save(lastItem: lastItem)
                self?.loadPosts(lastItem == nil)
            }
        }
    }
}


// MARK: - SJSegmentedViewControllerDelegate
extension PostsShowViewController: SJSegmentedViewControllerDelegate {
    func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {
        if self.selectedSegment != nil {
            selectedSegment?.titleColor(UIColor(hexString: "#D6D6D6"))
        }
        
        if self.segmentedViewController.segments.count > 0 {
            selectedSegment = self.segmentedViewController.segments[index]
            selectedSegment?.titleColor(UIColor(hexString: "#FFFFFF"))
        }
        
        // Scroll content to first row
        if self.selectedSegmentIndex == index {
            if let activeVC = self.containerView.activeVC, activeVC.fetchedResultsController != nil, self.containerView.activeVC!.lastIndex >= loadDataLimit / 2 {
                activeVC.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
            
        else {
            self.selectedSegmentIndex = index
            self.containerView.setActiveViewController(index: index)
            
//            if let activeVC = self.containerView.activeVC, activeVC.fetchedResultsController.sections == nil {
            self.loadPosts(false)
//            }
        }
        
        self.setActiveViewControllerHandlers()
    }
}
