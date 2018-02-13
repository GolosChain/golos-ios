//
//  ProfileViewController.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 15/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

private let topViewHeight: CGFloat = 180.0
private let middleViewHeight: CGFloat = 145.0
private let bottomViewHeight: CGFloat = 43.0
private let topViewMinimizedHeight: CGFloat = 20.0

class ProfileViewController: UIViewController, UIGestureRecognizerDelegate {
    var headerHeight: CGFloat {
        return topViewHeight + middleViewHeight + bottomViewHeight
    }
    var headerMinimizedHeight: CGFloat {
        return topViewMinimizedHeight + bottomViewHeight
    }
    
    // MARK: Outlets properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var profileHeaderView: ProfileHeaderView!
    @IBOutlet weak var profileInfoView: ProfileInfoView!
    @IBOutlet weak var profileHorizontalSelector: ProfileHorizontalSelectorView!
    @IBOutlet weak var statusBarImageViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: UI Properties
    let profileFeedContainer = ProfileFeedContainerController()
    

    // MARK: Constraints
    
    @IBOutlet weak var profileHeaderViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileHeaderViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileInfoViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileInfoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var horizontalSelectorTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var horizontalSelectorHeightConstraint: NSLayoutConstraint!
    
    var isNeedToStartRefreshing = false
    
    
    // MARK: Module properties
    lazy var presenter: ProfilePresenterProtocol = {
        let presenter = ProfilePresenter()
        presenter.profileView = self
        return presenter
    }()
    
    lazy var mediator: ProfileMediator = {
        let mediator = ProfileMediator()
        mediator.profilePresenter = self.presenter
        mediator.delegate = self
        return mediator
    }()

    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        presenter.fetchProfileData()
        presenter.fetchFeed()
    }
    
    // MARK: Setup UI
    private func setupUI() {
        addChildViewController(profileFeedContainer)
        view.addSubview(profileFeedContainer.view)
        profileFeedContainer.didMove(toParentViewController: self)
        
        profileFeedContainer.delegate = self
        
        let vc1 = FeedTabViewController.nibInstance()
        let vc2 = FeedTabViewController.nibInstance()
        let vc3 = FeedTabViewController.nibInstance()
        let vc4 = FeedTabViewController.nibInstance()
        
        profileFeedContainer.setFeedItems([vc1, vc2, vc3, vc4], headerHeight: headerHeight, minimizedHeaderHeight: headerMinimizedHeight)
        
        view.bringSubview(toFront: profileInfoView)
        view.bringSubview(toFront: profileHeaderView)
        view.bringSubview(toFront: profileHorizontalSelector)
        
        profileHorizontalSelector.delegate = self
        profileHeaderView.delegate = self
        
        if let navigationController = self.navigationController {
            profileHeaderView.showBackButton(navigationController.viewControllers.count > 1)
        }
        
        profileHeaderViewHeightConstraint.constant = topViewHeight
        
        profileInfoViewHeightConstraint.constant = middleViewHeight
        profileInfoViewTopConstraint.constant = topViewHeight
        
        horizontalSelectorHeightConstraint.constant = bottomViewHeight
        horizontalSelectorTopConstraint.constant = topViewHeight + middleViewHeight
        
        
        profileHeaderView.backgroundImage = Images.Profile.getProfileHeaderBackground()
    }
    
    // MARK: Actions
}


// MARK: ProfileHeaderViewDelegate
extension ProfileViewController: ProfileHeaderViewDelegate {
    func didPressEditProfileButton() {
        Utils.inDevelopmentAlert()
    }
    
    func didPressSettingsButton() {
        Utils.inDevelopmentAlert()
    }
    
    func didPressSubsribeButton() {
        Utils.inDevelopmentAlert()
    }
    
    func didPressSendMessageButton() {
        Utils.inDevelopmentAlert()
    }
    
    func didPressBackButton() {
        navigationController?.popViewController(animated: true)
    }
}


// MARK: ProfileViewProtocol
extension ProfileViewController: ProfileViewProtocol {
    func didLoadProfileData() {
    }
    
    func didLoadArticles() {
        tableView.reloadSections(IndexSet.init(integer: 0), with: .none)
    }
    
    func didRefreshSuccess() {
        
    }
    
    func didChangedFeedTab(isForward: Bool, previousAmount: Int) {
       
    }
}

// MARK: ProfileMediatorDelegate
extension ProfileViewController: ProfileMediatorDelegate {
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
}

// MARK: ProfileFeedContainerControllerDelegate
extension ProfileViewController: ProfileFeedContainerControllerDelegate {
    func didMainScroll(to pageIndex: Int) {
        profileHorizontalSelector.changeSelectedButton(at: pageIndex)
    }
    
    func didChangeYOffset(_ yOffset: CGFloat) {
        profileHeaderViewTopConstraint.constant = -(min(
            yOffset,
            topViewHeight - topViewMinimizedHeight
        ))
        profileInfoViewTopConstraint.constant = -(min(
            yOffset - topViewHeight,
            middleViewHeight)
        )
        horizontalSelectorTopConstraint.constant = -(min(
            yOffset - middleViewHeight - topViewHeight,
            -topViewMinimizedHeight
        ))
        
        profileHeaderView.didChangeOffset(yOffset)
    }
}

// MARK: HorizontalSelectorViewDelegate
extension ProfileViewController: ProfileHorizontalSelectorViewDelegate {
    func didSelectItem(at index: Int) {
        profileFeedContainer.setActiveItem(at: index)
    }
}
