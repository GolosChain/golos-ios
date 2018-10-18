//
//  UserProfileShowViewController.swift
//  golos-ios
//
//  Created by msm72 on 29.06.2018.
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
import MXParallaxHeader

enum UserProfileSceneMode {
    case edit
    case preview
}

// MARK: - Input & Output protocols
protocol UserProfileShowDisplayLogic: class {
    func displayUserInfo(fromViewModel viewModel: UserProfileShowModels.UserInfo.ViewModel)
    func displayUserDetails(fromViewModel viewModel: UserProfileShowModels.UserDetails.ViewModel)
    func displayUpvote(fromViewModel viewModel: UserProfileShowModels.ActiveVote.ViewModel)
}

class UserProfileShowViewController: GSBaseViewController, ContainerViewSupport {
    // MARK: - Properties
    var sceneMode: UserProfileSceneMode =   .edit
    
    var selectedButton: UIButton!
    let postFeedTypes: [PostsFeedType]  =   [ .blog, .reply ]
    var settingsShow: Bool              =   false
    
    var interactor: UserProfileShowBusinessLogic?
    var router: (NSObjectProtocol & UserProfileShowRoutingLogic & UserProfileShowDataPassing)?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var blogButton: UIButton!
    @IBOutlet weak var segmentedControlView: UIView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var lineViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var buttonsScrollView: UIScrollView! {
        didSet {
            buttonsScrollView.delegate = self
        }
    }
    
    @IBOutlet weak var lineView: UIView! {
        didSet {
            self.lineView.frame.origin = CGPoint(x: self.buttonsStackView.spacing, y: lineView.frame.minY)
        }
    }

    @IBOutlet weak var lineViewWidthConstraint: NSLayoutConstraint! {
        didSet {
            self.selectedButton                 =   self.buttonsStackView.arrangedSubviews.first(where: { $0.tag == 0 }) as? UIButton
            lineViewWidthConstraint.constant    =   self.selectedButton.frame.width
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

    @IBOutlet weak var containerView: GSContainerView! {
        didSet {
            self.containerView.mainVC            =   self
            self.containerView.viewControllers   =   self.getContainerViewControllers()
            
            self.containerView.setActiveViewController(index: 0)
        }
    }
    
    @IBOutlet var userProfileHeaderView: UserProfileHeaderView! {
        didSet {
            // Handlers
            userProfileHeaderView.handlerBackButtonTapped       =   { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            
            userProfileHeaderView.handlerEditButtonTapped       =   { [weak self] in
                self?.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
            }
            
            userProfileHeaderView.handlerWriteButtonTapped      =   { [weak self] in
                self?.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
            }

            userProfileHeaderView.handlerSettingsButtonTapped   =   { [weak self] in
                self?.settingsShow = true
                self?.router?.routeToSettingsShowScene()                
            }
            
            userProfileHeaderView.handlerSubscribeButtonTapped  =   { [weak self] in 
                self?.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
            }
        }
    }
    
    @IBOutlet weak var userProfileInfoTitleView: UserProfileInfoTitleView! {
        didSet {
            userProfileInfoTitleView.tune()
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            // Parallax Header
            scrollView.parallaxHeader.view              =   userProfileHeaderView
            scrollView.parallaxHeader.height            =   180.0
            scrollView.parallaxHeader.mode              =   MXParallaxHeaderMode.fill
            scrollView.parallaxHeader.minimumHeight     =   20.0

            scrollView.parallaxHeader.delegate          =   self
            scrollView.delegate                         =   self
        }
    }
    
    @IBOutlet weak var walletBalanceView: UIView! {
        didSet {
            walletBalanceView.isHidden = true
            walletBalanceView.tune()
        }
    }

    @IBOutlet weak var walletBalanceViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            walletBalanceViewHeightConstraint.constant = 44.0
        }
    }
    
    @IBOutlet weak var walletBalanceViewTopConstraint: NSLayoutConstraint! {
        didSet {
            walletBalanceViewTopConstraint.constant = walletBalanceView.isHidden ? -walletBalanceViewHeightConstraint.constant : 0.0
        }
    }

    @IBOutlet weak var scrollViewTopConstraint: NSLayoutConstraint! {
        didSet {
            self.scrollViewTopConstraint.constant = UIDevice.getDeviceScreenSize() == .iPhone4s ? -40.0 : -20.0
        }
    }
    
    @IBOutlet var heightsCollection: [NSLayoutConstraint]! {
        didSet {
            self.heightsCollection.forEach({ $0.constant *= heightRatio })
        }
    }
    
    @IBOutlet var widthsCollection: [NSLayoutConstraint]! {
        didSet {
            self.widthsCollection.forEach({ $0.constant *= widthRatio })
        }
    }
    
    @IBOutlet weak var userProfileInfoControlViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var userProfileInfoTitleViewHeightConstraint: NSLayoutConstraint!
    

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
        let interactor              =   UserProfileShowInteractor()
        let presenter               =   UserProfileShowPresenter()
        let router                  =   UserProfileShowRouter()
        
        viewController.interactor   =   interactor
        viewController.router       =   router
        interactor.presenter        =   presenter
        presenter.viewController    =   viewController
        router.viewController       =   viewController
        router.dataStore            =   interactor
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
        
        self.loadViewSettings()
        
        self.containerView.mainVC = self
        self.containerView.setActiveViewController(index: 0)
        
        // Load User info
        self.loadUserInfo()
        
        // Load User details
        self.loadUserDetails(byCondition: (isRefreshData: true, isInfiniteScrolling: false))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        self.hideNavigationBar()
        self.settingsShow = false
        
        UIApplication.shared.statusBarStyle     =   User.fetch(byNickName: self.router!.dataStore!.userNickName ?? "")?.coverImageURL == nil ? .default : (scrollView.parallaxHeader.progress == 0.0 ? .default : .lightContent)

        self.localizeTitles()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
        self.userProfileHeaderView.showLabelsForAnimationCollection(false)
        self.userProfileInfoTitleView.showLabelsForAnimationCollection(false)
    }
    
    
    // MARK: - Custom Functions
    private func loadViewSettings() {
        // Wallet Balance View show/hide
        if !walletBalanceView.isHidden {
            view.bringSubviewToFront(walletBalanceView)
            walletBalanceViewTopConstraint.constant             =   0.0
            userProfileInfoControlViewTopConstraint.constant    =   10.0
            walletBalanceView.add(shadow: true, onside: .bottom)
        }
        
        self.userProfileHeaderView.editProfileButton.isHidden   =   self.sceneMode == .edit ? false : true
        self.userProfileHeaderView.backButton.isHidden          =   self.sceneMode == .preview ? false : true
    }
    
    private func getContainerViewControllers() -> [GSTableViewController] {
        let blogPostsShowVC     =   UIStoryboard(name: "UserProfileShow", bundle: nil)
                                        .instantiateViewController(withIdentifier: "UserProfileBlogShowVC") as! GSTableViewController
        
        let replyPostsShowVC    =   UIStoryboard(name: "UserProfileShow", bundle: nil)
                                        .instantiateViewController(withIdentifier: "UserProfileReplyShowVC") as! GSTableViewController
        
        
        let segmentControllers  =   [ blogPostsShowVC, replyPostsShowVC ]
        
        return segmentControllers
    }

    private func scrollHorizontalTo(sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.selectedButton.theme_setTitleColor(blackWhiteColorPickers, forState: .normal)
            _ = self.buttonsCollection.filter({ $0 != sender }).map({ $0.theme_setTitleColor(veryLightGrayColorPickers, forState: .normal )})
            
            let offsetMinX = sender.frame.minX - self.buttonsScrollView.contentOffset.x
            let offsetMaxX = sender.frame.maxX - self.buttonsScrollView.contentOffset.x
            
            UIView.animate(withDuration: 0.2, animations: {
                self.lineView.transform = CGAffineTransform(translationX: self.selectedButton.frame.minX - self.buttonsStackView.spacing - self.buttonsScrollView.contentOffset.x, y: 0)
                self.lineViewWidthConstraint.constant = sender.frame.width
                
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            })
            
            if !self.segmentedControlView.frame.contains(CGPoint(x: offsetMinX, y: 0)) || !self.segmentedControlView.frame.contains(CGPoint(x: offsetMaxX, y: 0)) {
                switch sender.tag {
                case 0, 1:
                    self.buttonsScrollView.scrollRectToVisible(CGRect(origin: .zero, size: sender.frame.size), animated: true)
                    
                // 3, 4
                default:
                    let lastView    =   self.buttonsStackView.arrangedSubviews.first(where: { $0.tag == 6 })
                    let visibleRect =   CGRect(origin:  lastView!.frame.origin,
                                               size:    CGSize(width: lastView!.frame.width + self.buttonsStackView.spacing, height: lastView!.frame.height))
                    
                    self.buttonsScrollView.scrollRectToVisible(visibleRect, animated: true)
                }
            }
        }
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
            self.selectedButton = sender
            
            self.containerView.setActiveViewController(index: sender.tag)
            self.loadUserDetails(byCondition: (isRefreshData: self.containerView.activeVC?.fetchedResultsController == nil, isInfiniteScrolling: false))
        }
        
        self.scrollHorizontalTo(sender: sender)
    }
    
    override func localizeTitles() {
        self.buttonsCollection.forEach({ $0.setTitle($0.titleLabel!.text!.localized(), for: .normal) })
        self.buttonsStackView.layoutIfNeeded()
        
        // TODO: - RECOMMENT FOR ALL SEGMENTED TITLES!!!
        // Set UIStackView spacing
        //        if self.buttonsStackView.frame.width < UIScreen.main.bounds.width {
        //            self.buttonsStackView.spacing               +=  (UIScreen.main.bounds.width - self.buttonsStackView.frame.width) / 6
        //            self.lineViewLeadingConstraint.constant     =   self.buttonsStackView.spacing
        //        }
        
        self.selectedButton = self.buttonsStackView.arrangedSubviews.filter({ $0.isHidden == false })[self.selectedButton.tag + 1] as? UIButton
        self.userProfileInfoTitleView.labelsCollection.forEach({ $0.text = $0.accessibilityIdentifier!.localized() })
        
        self.userProfileHeaderView.showLabelsForAnimationCollection(true)
        self.userProfileInfoTitleView.showLabelsForAnimationCollection(true)
    }
}


// MARK: - Load data from Blockchain by API
extension UserProfileShowViewController {
    // User Profile
    private func loadUserInfo() {
        let userInfoRequestModel = UserProfileShowModels.UserInfo.RequestModel()
        interactor?.loadUserInfo(withRequestModel: userInfoRequestModel)
    }
    
    // Blogs
    func loadUserDetails(byCondition condition: LoadDataCondition) {
        guard condition.isRefreshData == true || condition.isInfiniteScrolling == true else {
            return
        }
        
        let userDetailsRequestModel = UserProfileShowModels.UserDetails.RequestModel(postFeedType: postFeedTypes[self.selectedButton.tag])
        interactor?.loadUserDetails(withRequestModel: userDetailsRequestModel)
    }
}


// MARK: - Fetch data from CoreData
extension UserProfileShowViewController {
    // User Profile
    private func fetchUserInfo() {
        if let userEntity = User.fetch(byNickName: self.router!.dataStore!.userNickName ?? "XXX") {
            self.userProfileInfoTitleViewHeightConstraint.constant = 58.0
            self.userProfileHeaderView.updateUI(fromUserInfo: userEntity)
            self.userProfileInfoTitleView.updateUI(fromUserInfo: userEntity)
            
            // Change profileInfoView height
            if let info = userEntity.about, !info.isEmpty {
                userProfileInfoTitleViewHeightConstraint.constant *= 2
            }
        }
    }
    
    // User Details
    private func fetchUserDetails() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
            if let activeVC = self.containerView.activeVC {
                activeVC.fetchPosts(byParameters: (author: self.router?.dataStore?.userNickName, postFeedType: self.postFeedTypes[self.selectedButton.tag], permlink: nil, sortBy: nil))
                
                // Handler Pull Refresh/Infinite Scrolling data
                activeVC.handlerPushRefreshData         =   { [weak self] lastItem in
                    self?.interactor?.save(lastItem: lastItem)
                    
                    if lastItem == nil {
                        self?.loadUserDetails(byCondition: (isRefreshData: true, isInfiniteScrolling: false))
                    } else {
                        self?.loadUserDetails(byCondition: (isRefreshData: false, isInfiniteScrolling: true))
                    }
                }
                
                activeVC.handlerAnswerButtonTapped      =   { [weak self] postShortInfo in
                    guard (self?.isCurrentOperationPossible())! else {
                        return
                    }
                    
                    self?.interactor?.save(commentReply: postShortInfo!)
                    self?.router?.routeToPostCreateScene(withType: .createCommentReply)
                }
                
                activeVC.handlerReplyTypeButtonTapped   =   { [weak self] isOperationAvailable in
                    if isOperationAvailable {
                        self?.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
                    } else {
                        _ = self?.isCurrentOperationPossible()
                    }
                }
                
                activeVC.handlerShareButtonTapped       =   { [weak self] in
                    self?.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
                }
                
                activeVC.handlerActiveVoteButtonTapped  =   { [weak self] (isVote, postShortInfo) in
                    // Check network connection
                    guard isNetworkAvailable else {
                        self?.showAlertView(withTitle: "Info", andMessage: "No Internet Connection", needCancel: false, completion: { _ in })
                        return
                    }
                    
                    guard (self?.isCurrentOperationPossible())! else { return }

                    self?.interactor?.save(blogShortInfo: postShortInfo)
                    
                    let blogCell        =   activeVC.postsTableView.cellForRow(at: postShortInfo.indexPath!) as! PostCellActiveVoteSupport
                    let requestModel    =   UserProfileShowModels.ActiveVote.RequestModel(isVote: isVote, isFlaunt: false)

                    guard isVote else {
                        self?.showAlertView(withTitle: "Voting Verb", andMessage: "Cancel Vote Message", actionTitle: "ActionChange", needCancel: true, completion: { success in
                            if success {
                                blogCell.activeVoteButton.startVote(withSpinner: blogCell.activeVoteActivityIndicator)
                                self?.interactor?.upvote(withRequestModel: requestModel)
                            } else {
                                blogCell.activeVoteButton.breakVote(withSpinner: blogCell.activeVoteActivityIndicator)
                            }
                        })
                        
                        return
                    }
                    
                    blogCell.activeVoteButton.startVote(withSpinner: blogCell.activeVoteActivityIndicator)
                    self?.interactor?.upvote(withRequestModel: requestModel)
                }
                
                activeVC.handlerCommentsButtonTapped    =   { [weak self] postShortInfo in
                    self?.settingsShow = true
                    self?.interactor?.save(blogShortInfo: postShortInfo)
                    self?.router?.routeToPostShowScene(withScrollToComments: true)
                }
                
                // Select Blog
                activeVC.handlerSelectItem              =   { [weak self] postShortInfo in
                    self?.interactor?.save(blogShortInfo: postShortInfo)
                    self?.router?.routeToPostShowScene(withScrollToComments: false)
                    self?.settingsShow = true
                }
                
                // Reply handlers
                activeVC.handlerAuthorProfileImageButtonTapped    =   { [weak self] authorName in
                    guard (self?.isCurrentOperationPossible())! else {
                        return
                    }

                    self?.router?.routeToUserProfileScene(byUserName: authorName!)
                }
            }
        })
    }
}


// MARK: - UserProfileShowDisplayLogic
extension UserProfileShowViewController: UserProfileShowDisplayLogic {
    func displayUserInfo(fromViewModel viewModel: UserProfileShowModels.UserInfo.ViewModel) {
        // NOTE: Display the result from the Presenter
        if let error = viewModel.error {
            self.showAlertView(withTitle: "Error", andMessage: error.localizedDescription, needCancel: false, completion: { _ in })
        }

        // CoreData
        self.fetchUserInfo()
    }
    
    func displayUserDetails(fromViewModel viewModel: UserProfileShowModels.UserDetails.ViewModel) {
        // NOTE: Display the result from the Presenter
        if let error = viewModel.error {
            self.showAlertView(withTitle: "Error", andMessage: error.localizedDescription, needCancel: false, completion: { _ in })
        }
        
        // CoreData
        self.fetchUserDetails()
    }
    
    func displayUpvote(fromViewModel viewModel: UserProfileShowModels.ActiveVote.ViewModel) {
        // NOTE: Display the result from the Presenter
        if let activeVC = self.containerView.activeVC, let postShortInfo = self.router?.dataStore?.selectedBlog, let indexPath = postShortInfo.indexPath {
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
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.5) {
                RestAPIManager.loadModifiedPost(author: postShortInfo.author ?? "XXX", permlink: postShortInfo.permlink ?? "XXX", postType: PostsFeedType.blog, completion: { model in
                    if let blogEntity = model {
                        activeVC.postsList![indexPath.row] = blogEntity
                        activeVC.postsTableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                })
            }
        }
    }
}


// MARK: - UIScrollViewDelegate
extension UserProfileShowViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollView else { return }
        
        Logger.log(message: String(format: "scrollView.contentOffset.y %f", scrollView.contentOffset.y), event: .debug)
        Logger.log(message: String(format: "userProfileInfoTitleView.frame.midY %f", view.convert(userProfileInfoTitleView.frame, from: contentView).midY), event: .debug)
    }
}


// MARK: - MXParallaxHeaderDelegate
extension UserProfileShowViewController: MXParallaxHeaderDelegate {
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        Logger.log(message: String(format: "progress %f", parallaxHeader.progress), event: .debug)

        guard !self.settingsShow else { return }
        
        UIApplication.shared.statusBarStyle = User.fetch(byNickName: (self.router?.dataStore?.userNickName)!)?.coverImageURL == nil ? .default : (parallaxHeader.progress == 0.0 ? .default : .lightContent)
        self.userProfileHeaderView.whiteStatusBarView.isHidden = parallaxHeader.progress != 0.0
    }
}
