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
import Localize_Swift

typealias LoadDataCondition = (isRefreshData: Bool, isInfiniteScrolling: Bool)

// MARK: - Input & Output protocols
protocol PostsShowDisplayLogic: class {
    func displayLoadPosts(fromViewModel viewModel: PostsShowModels.Items.ViewModel)
    func displayUpvote(fromViewModel viewModel: PostsShowModels.ActiveVote.ViewModel)
}

class PostsShowViewController: GSTableViewController, ContainerViewSupport {
    // MARK: - Properties
    var selectedIndex: Int = 0
    var selectedButton: UIButton!
    var postFeedTypes: [PostsFeedType]  =   User.current == nil ?   [ .new, .actual, .popular, .promo ] :
                                                                    [ .lenta, .new, .actual, .popular, .promo ]

    var interactor: PostsShowBusinessLogic?
    var router: (NSObjectProtocol & PostsShowRoutingLogic & PostsShowDataPassing)?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var lentaButton: UIButton!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var lineViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            
            // Handler horizontal scrolling
            self.handlerHorizontalScrolling     =   { [weak self] contentOffsetX in
                self?.lineView.transform = CGAffineTransform(translationX: (self?.selectedButton.frame.minX)! - (self?.buttonsStackView.spacing)! - contentOffsetX, y: 0)
            }
        }
    }
    
    @IBOutlet weak var lineView: UIView! {
        didSet {
            self.lineView.frame.origin = CGPoint(x: self.buttonsStackView.spacing, y: lineView.frame.minY)
        }
    }
    
    @IBOutlet weak var lineViewWidthConstraint: NSLayoutConstraint! {
        didSet {
            self.selectedButton = self.buttonsStackView.arrangedSubviews.filter({ type(of: $0) == UIButton.self && !$0.isHidden })[self.selectedIndex] as? UIButton
            lineViewWidthConstraint.constant = self.selectedButton.frame.width
        }
    }

    @IBOutlet weak var statusBarView: UIView! {
        didSet {
            statusBarView.tune(withThemeColorPicker: darkModerateBlueColorPickers)
        }
    }
    
    @IBOutlet var buttonsCollection: [UIButton]! {
        didSet {
            self.buttonsCollection.forEach({ actionButton in
                actionButton.tune(withTitle:        actionButton.titleLabel?.text ?? "XXX",
                                  hexColors:        [veryLightGrayColorPickers, veryLightGrayColorPickers, veryLightGrayColorPickers, veryLightGrayColorPickers],
                                  font:             UIFont(name: "SFProDisplay-Regular", size: 13.0),
                                  alignment:        .center)
            })
        }
    }
    
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            shadowView.setGradientBackground(colors: [UIColor.lightGray.cgColor, UIColor.lightText.cgColor], onside: .bottom)
        }
    }
    
    // ContainerViewSupport implementation
    @IBOutlet weak var containerView: GSContainerView! {
        didSet {
            self.containerView.mainVC            =   self
            self.containerView.viewControllers   =   self.getContainerViewControllers()

            self.containerView.setActiveViewController(index: 0)
        }
    }
    
    @IBOutlet var heightsCollection: [NSLayoutConstraint]! {
        didSet {
            self.heightsCollection.forEach({ $0.constant *= heightRatio })
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

        NotificationCenter.default.removeObserver(self)
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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.lineViewWidthConstraint.constant   =   self.selectedButton.frame.width
        self.lineView.transform                 =   CGAffineTransform(translationX: self.selectedButton.frame.minX - self.buttonsStackView.spacing - self.scrollView.contentOffset.x, y: 0)
            
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.scrollHorizontalTo(sender: self.selectedButton)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.tune()
        self.containerView.mainVC = self
        self.containerView.setActiveViewController(index: self.selectedIndex)
        
        self.lentaButton.isHidden = User.current == nil

        self.selectedButton = self.buttonsStackView.arrangedSubviews.filter({ type(of: $0) == UIButton.self && !$0.isHidden })[self.selectedIndex] as? UIButton
        self.lineViewWidthConstraint.constant = self.selectedButton.frame.width

        self.localizeTitles()
        
        NotificationCenter.default.addObserver(self, selector: #selector(localizeTitles), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .lightContent
        self.hideNavigationBar()
    }
    
    
    // MARK: - Custom Functions
    override func localizeTitles() {
        self.buttonsCollection.forEach({ $0.setTitle($0.titleLabel!.text!.localized(), for: .normal) })
//        self.buttonsStackView.layoutIfNeeded()
        
        // Set UIStackView spacing
        if self.buttonsStackView.frame.width < UIScreen.main.bounds.width {
            self.buttonsStackView.spacing               +=  (UIScreen.main.bounds.width - self.buttonsStackView.frame.width) / 6
            self.lineViewLeadingConstraint.constant     =   self.buttonsStackView.spacing
        }
        
        // Load/Reload Posts
        self.loadPosts(byCondition: (isRefreshData: true, isInfiniteScrolling: false))
    }
    
    private func scrollHorizontalTo(sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.selectedButton.theme_setTitleColor(whiteColorPickers, forState: .normal)
            _ = self.buttonsCollection.filter({ $0 != sender }).map({ $0.theme_setTitleColor(veryLightGrayColorPickers, forState: .normal )})
            
            let offsetMinX = sender.frame.minX - self.scrollView.contentOffset.x
            let offsetMaxX = sender.frame.maxX - self.scrollView.contentOffset.x
            
            UIView.animate(withDuration: 0.2, animations: {
                self.lineView.transform = CGAffineTransform(translationX: self.selectedButton.frame.minX - self.buttonsStackView.spacing - self.scrollView.contentOffset.x, y: 0)
                self.lineViewWidthConstraint.constant = sender.frame.width
                
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            })
            
            if !self.statusBarView.frame.contains(CGPoint(x: offsetMinX, y: 0)) || !self.statusBarView.frame.contains(CGPoint(x: offsetMaxX, y: 0)) {
                switch sender.tag {
                case 0, 1:
                    self.scrollView.scrollRectToVisible(CGRect(origin: .zero, size: sender.frame.size), animated: true)
                    
                // 3, 4
                default:
                    let lastView    =   self.buttonsStackView.arrangedSubviews.first(where: { $0.tag == 6 })
                    let visibleRect =   CGRect(origin:  lastView!.frame.origin,
                                               size:    CGSize(width: lastView!.frame.width + self.buttonsStackView.spacing, height: lastView!.frame.height))
                    
                    self.scrollView.scrollRectToVisible(visibleRect, animated: true)
                }
            }
        }
    }
    
    private func setActiveViewControllerHandlers() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
            if let activeVC = self.containerView.activeVC {
                activeVC.fetchPosts(byParameters: (author: User.current?.nickName, postFeedType: self.postFeedTypes[self.selectedIndex], permlink: nil, sortBy: nil))
                
                // Handler Pull Refresh/Infinite Scrolling data
                activeVC.handlerPushRefreshData                     =   { [weak self] lastItem in
                    self?.interactor?.save(lastItem: lastItem)
                    
                    if lastItem == nil {
                        self?.loadPosts(byCondition: (isRefreshData: true, isInfiniteScrolling: false))
                    } else {
                        self?.loadPosts(byCondition: (isRefreshData: false, isInfiniteScrolling: true))
                    }
                }
                
                activeVC.handlerAnswerButtonTapped                  =   { [weak self] postShortInfo in
                    self?.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
                }
                
                activeVC.handlerReplyTypeButtonTapped               =   { [weak self] isOperationAvailable in
                    if isOperationAvailable {
                        self?.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
                    } else {
                        _ = self?.isCurrentOperationPossible()
                    }
                }
                
                activeVC.handlerShareButtonTapped                   =   { [weak self] in
                    self?.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
                }
                
                activeVC.handlerActiveVoteButtonTapped                 =   { [weak self] (isVote, postShortInfo) in
                    // Check network connection
                    guard isNetworkAvailable else {
                        self?.showAlertView(withTitle: "Info", andMessage: "No Internet Connection", needCancel: false, completion: { _ in })
                        return
                    }
                    
                    guard (self?.isCurrentOperationPossible())! else { return }
                    
                    self?.interactor?.save(postShortInfo: postShortInfo)
 
                    let postCell        =   activeVC.postsTableView.cellForRow(at: postShortInfo.indexPath!) as! PostCellActiveVoteSupport
                    let requestModel    =   PostsShowModels.ActiveVote.RequestModel(isVote: isVote, isFlaunt: false)

                    guard isVote else {
                        self?.showAlertView(withTitle: "Voting Verb", andMessage: "Cancel Vote Message", actionTitle: "ActionChange", needCancel: true, completion: { success in
                            if success {
                                postCell.activeVoteButton.startVote(withSpinner: postCell.activeVoteActivityIndicator)
                                self?.interactor?.upvote(withRequestModel: requestModel)
                            } else {
                                postCell.activeVoteButton.breakVote(withSpinner: postCell.activeVoteActivityIndicator)
                            }
                        })
                        
                        return
                    }
                    
                    postCell.activeVoteButton.startVote(withSpinner: postCell.activeVoteActivityIndicator)
                    self?.interactor?.upvote(withRequestModel: requestModel)
                }
                
                activeVC.handlerCommentsButtonTapped                =   { [weak self] postShortInfo in
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                        self?.interactor?.save(postShortInfo: postShortInfo)
                        self?.router?.routeToPostShowScene(withScrollToComments: true)
                    })
                 }
                
                activeVC.handlerSelectItem                          =   { [weak self] postShortInfo in
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                        self?.interactor?.save(postShortInfo: postShortInfo)
                        self?.router?.routeToPostShowScene(withScrollToComments: false)
                    })
                }
                
                activeVC.handlerAuthorProfileImageButtonTapped      =   { [weak self] userName in
                    self?.router?.routeToUserProfileScene(byUserName: userName)
                }
            }
        })
    }
    
    private func getContainerViewControllers() -> [GSTableViewController] {
        let lentaPostsShowVC    =   UIStoryboard(name: "PostsShow", bundle: nil)
                                        .instantiateViewController(withIdentifier: "LentaPostsShowVC") as! GSTableViewController
        
        let popularPostsShowVC  =   UIStoryboard(name: "PostsShow", bundle: nil)
                                        .instantiateViewController(withIdentifier: "PopularPostsShowVC") as! GSTableViewController
       
        let actualPostsShowVC   =   UIStoryboard(name: "PostsShow", bundle: nil)
                                        .instantiateViewController(withIdentifier: "ActualPostsShowVC") as! GSTableViewController
        
        let newPostsShowVC      =   UIStoryboard(name: "PostsShow", bundle: nil)
                                        .instantiateViewController(withIdentifier: "NewPostsShowVC") as! GSTableViewController
       
        let promoPostsShowVC    =   UIStoryboard(name: "PostsShow", bundle: nil)
                                        .instantiateViewController(withIdentifier: "PromoPostsShowVC") as! GSTableViewController
        

        let segmentControllers  =   User.current == nil ?   [ popularPostsShowVC, actualPostsShowVC, newPostsShowVC, promoPostsShowVC ] :
                                                            [ lentaPostsShowVC, popularPostsShowVC, actualPostsShowVC, newPostsShowVC, promoPostsShowVC ]
        
        return segmentControllers
    }
    
    
    // MARK: - Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        // Scroll content to first row
        if self.selectedButton == sender {
            if let activeVC = self.containerView.activeVC, let tableView = activeVC.postsTableView, tableView.contentOffset.y > 0.0 {
                activeVC.postsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
        
        // Load posts or not
        else {
            self.selectedIndex      =   User.current == nil ? sender.tag - 1 : sender.tag
            self.selectedButton     =   sender
            
            self.containerView.setActiveViewController(index: self.selectedIndex)
            self.loadPosts(byCondition: (isRefreshData: self.containerView.activeVC?.fetchedResultsController == nil, isInfiniteScrolling: false))
        }
        
        self.scrollHorizontalTo(sender: sender)
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
    
    func displayUpvote(fromViewModel viewModel: PostsShowModels.ActiveVote.ViewModel) {
        // NOTE: Display the result from the Presenter
        if let activeVC = self.containerView.activeVC, let postShortInfo = self.router?.dataStore?.postShortInfo, let indexPath = postShortInfo.indexPath {
            guard viewModel.errorAPI == nil else {
                if let message = viewModel.errorAPI?.caseInfo.message {
                    self.showAlertView(withTitle:   viewModel.errorAPI!.caseInfo.title,
                                       andMessage:  message.translate(),
                                       needCancel:  false,
                                       completion:  { _ in
                                        activeVC.postsTableView.reloadRows(at: [indexPath], with: .automatic)
                    })
                }
                
                return
            }
            
            // Reload & refresh current cell content by indexPath
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                RestAPIManager.loadModifiedPost(author: postShortInfo.author ?? "XXX", permlink: postShortInfo.permlink ?? "XXX", postType: activeVC.postType, completion: { model in
                    if let postEntity = model {
                        activeVC.postsList![indexPath.row] = postEntity
                        activeVC.postsTableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                })
            }
        }
    }
}


// MARK: - Load data from Blockchain by API
extension PostsShowViewController {
    func loadPosts(byCondition condition: LoadDataCondition) {
        guard condition.isRefreshData == true || condition.isInfiniteScrolling == true else {
            return
        }
        
        // Load data
        let loadPostsRequestModel = PostsShowModels.Items.RequestModel(postFeedType: self.postFeedTypes[self.selectedIndex])
        self.interactor?.loadPosts(withRequestModel: loadPostsRequestModel)
    }
}


// MARK: - Fetch data from CoreData
extension PostsShowViewController {
    // User Profile
    private func fetchPosts() {
        self.setActiveViewControllerHandlers()
    }
}
