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
private let topViewMinimizedHeight: CGFloat = UIDevice.getDeviceScreenSize() == .iphoneX ? 35.0 : 20.0

class ProfileViewController: UIViewController, UIGestureRecognizerDelegate {
    var headerHeight: CGFloat {
        return topViewHeight + middleViewHeight + bottomViewHeight
    }
    var headerMinimizedHeight: CGFloat {
        return topViewMinimizedHeight + bottomViewHeight
    }
    
    // MARK: Outlets properties
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
        return mediator
    }()

    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    let postsManager = PostsManager()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    // MARK: Setup UI
    private func setupUI() {
        addChildViewController(profileFeedContainer)
        view.addSubview(profileFeedContainer.view)
        profileFeedContainer.didMove(toParentViewController: self)
        
        profileFeedContainer.view.translatesAutoresizingMaskIntoConstraints = false
        profileFeedContainer.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        profileFeedContainer.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        profileFeedContainer.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        profileFeedContainer.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        profileFeedContainer.delegate = self
        
        let vc1 = PostsFeedViewController.nibInstance()
        let vc2 = AnswersFeedViewController.nibInstance()
        let vc3 = PostsFeedViewController.nibInstance()
        let vc4 = PostsFeedViewController.nibInstance()
        
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
        
        profileHorizontalSelector.backgroundColor = .green
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
    
    }
    
    func didRefreshSuccess() {
        
    }
    
    func didChangedFeedTab(isForward: Bool, previousAmount: Int) {
       
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
