//
//  ProfileViewController.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 15/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift

private let topViewHeight: CGFloat              =   180.0 * heightRatio
private var middleViewHeight: CGFloat           =   58.0 * heightRatio
private let bottomViewHeight: CGFloat           =   43.0 * heightRatio
private let topViewMinimizedHeight: CGFloat     =   (UIDevice.getDeviceScreenSize() == .iphoneX ? 35.0 : 20.0) * heightRatio

class ProfileViewController: BaseViewController, UIGestureRecognizerDelegate {
    // MARK: - Properties
    let profileFeedContainer = ProfileFeedContainerController()
    var isNeedToStartRefreshing = false
    var username: String?
    var user: DisplayedUser?
    private var imageLoader = GSImageLoader()

    lazy var presenter: ProfilePresenterProtocol = {
        let presenter           =   ProfilePresenter()
        presenter.profileView   =   self

        return presenter
    }()
    
    var headerHeight: CGFloat {
        return topViewHeight + middleViewHeight + bottomViewHeight
    }
    
    var headerMinimizedHeight: CGFloat {
        return topViewMinimizedHeight + bottomViewHeight
    }
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var profileInfoView: ProfileInfoView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var profileHeaderView: ProfileHeaderView!
    @IBOutlet weak var profileHorizontalSelector: ProfileHorizontalSelectorView!

    @IBOutlet weak var statusBarImageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileHeaderViewTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var profileHeaderViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileInfoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var horizontalSelectorTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var horizontalSelectorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileInfoViewTopConstraint: NSLayoutConstraint!
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        self.presenter.setUser(self.user)
        self.presenter.setUsername(username: self.username)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        // Set status bar
        UIApplication.shared.statusBarStyle = profileHeaderView.whiteStatusBarView.isHidden ? .lightContent : .default
        
        self.presenter.fetchUser()

        // API
        self.presenter.loadUser()
    }
    
    
    // MARK: - Setup UI
    private func setupUI() {
        addChildViewController(profileFeedContainer)
        view.addSubview(profileFeedContainer.view)
        profileFeedContainer.didMove(toParentViewController: self)
        
        profileFeedContainer.view.translatesAutoresizingMaskIntoConstraints                     =   false
        profileFeedContainer.view.topAnchor.constraint(equalTo: view.topAnchor).isActive        =   true
        profileFeedContainer.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive      =   true
        profileFeedContainer.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive    =   true
        profileFeedContainer.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive  =   true
        
        profileFeedContainer.delegate   =   self
        
        // TODO: Move to mediator
        let postsFeedViewController     =   PostsFeedViewController.nibInstance()
        let answersFeedViewController   =   AnswersFeedViewController.nibInstance()
        let postsFeedViewController1    =   PostsFeedViewController.nibInstance()
        let postsFeedViewController2    =   PostsFeedViewController.nibInstance()
        
        let feedItems: [UIViewController & ProfileFeedContainerItem] = [postsFeedViewController,
                                                                        answersFeedViewController,
                                                                        postsFeedViewController1,
                                                                        postsFeedViewController2]
        
        profileFeedContainer.setFeedItems(feedItems, headerHeight: headerHeight, minimizedHeaderHeight: headerMinimizedHeight)
        
        view.bringSubview(toFront: profileInfoView)
        view.bringSubview(toFront: profileHeaderView)
        view.bringSubview(toFront: profileHorizontalSelector)
        
        profileHeaderView.delegate          =   self
        profileHorizontalSelector.delegate  =   self
        
        if let navigationController = self.navigationController {
            profileHeaderView.showBackButton(navigationController.viewControllers.count > 1)
        }
        
//        profileHeaderViewHeightConstraint.constant      =   topViewHeight
        profileInfoViewHeightConstraint.constant        =   middleViewHeight
//        profileInfoViewTopConstraint.constant           =   topViewHeight
        horizontalSelectorHeightConstraint.constant     =   bottomViewHeight
        horizontalSelectorTopConstraint.constant        =   topViewHeight + middleViewHeight
        profileHeaderView.backgroundImage               =   Images.Profile.getProfileHeaderBackground()
        profileHorizontalSelector.backgroundColor       =   .green
    }
}


// MARK: - ProfileHeaderViewDelegate
extension ProfileViewController: ProfileHeaderViewDelegate {
    func didPressEditProfileButton() {
        self.inDevelopmentAlert()
    }
    
    func didPressSettingsButton() {
        self.showAlertView(withTitle: "Exit", andMessage: "Are Your Sure?", needCancel: true, completion: { [weak self] success in
            if success {
                self?.presenter.logout()
            }
        })
    }
    
    func didPressSubsribeButton() {
        self.inDevelopmentAlert()
    }
    
    func didPressSendMessageButton() {
        self.inDevelopmentAlert()
    }
    
    func didPressBackButton() {
        navigationController?.popViewController(animated: true)
    }
}


// MARK: - ProfileViewProtocol
extension ProfileViewController: ProfileViewProtocol {
    func didFail(with errorMessage: String) {
        self.showAlertView(withTitle: "Error", andMessage: errorMessage, needCancel: false, completion: { _ in })
    }
    
    func didRefreshUser() {
        guard let viewModel = presenter.getProfileViewModel() else {
            return
        }
        
        profileHeaderView.name                  =   viewModel.name
        profileHeaderView.rankString            =   viewModel.rank
        profileHeaderView.starsAmountString     =   viewModel.starsAmount
        
        profileInfoView.information             =   viewModel.information
        profileInfoView.postsAmountString       =   viewModel.postsCount
        
        // Change profileInfoView height
        if !viewModel.information.isEmpty {
            middleViewHeight *= 2
            profileInfoViewHeightConstraint.constant = middleViewHeight
        }
        
        if let pictureUrlString = viewModel.pictureUrl {
            imageLoader.startLoadImage(with: pictureUrlString) { [weak self] image in
                guard let strongSelf = self else { return }
                
                let image = image ?? UIImage(named: "avatar_placeholder")
                strongSelf.profileHeaderView.avatarImage = image
            }
        }
    }
}


// MARK: - ProfileFeedContainerControllerDelegate
extension ProfileViewController: ProfileFeedContainerControllerDelegate {
    func didMainScroll(to pageIndex: Int) {
        profileHorizontalSelector.changeSelectedButton(at: pageIndex)
    }
    
    func didChangeYOffset(_ yOffset: CGFloat) {
        profileHeaderViewTopConstraint.constant     =   -(min(yOffset, topViewHeight - topViewMinimizedHeight))
        profileInfoViewTopConstraint.constant       =   -(min(yOffset - topViewHeight, middleViewHeight))
        horizontalSelectorTopConstraint.constant    =   -(min(yOffset - middleViewHeight - topViewHeight, -topViewMinimizedHeight))
        
        // Change status bar
        profileHeaderView.whiteStatusBarView.isHidden   =   profileHeaderViewTopConstraint.constant == -160.0 ? false : true
        UIApplication.shared.statusBarStyle             =   profileHeaderViewTopConstraint.constant == -160.0 ? .default : .lightContent
        
        profileHeaderView.didChangeOffset(yOffset)
    }
}


// MARK: - HorizontalSelectorViewDelegate
extension ProfileViewController: ProfileHorizontalSelectorViewDelegate {
    func didSelectItem(at index: Int) {
        profileFeedContainer.setActiveItem(at: index)
    }
}
