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
    
    var username: String!
    var user: UserModel!
    
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
    
    private var imageLoader = GSImageLoader()

    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
//        self.presenter.setUsername(username: self.username)
        self.presenter.setUser(self.user)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
//        self.presenter.loadUser()
        self.presenter.fetchUser()
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
        
        
        // TODO: Move to mediator
        let postsFeedViewController = PostsFeedViewController.nibInstance()
        let answersFeedViewController = AnswersFeedViewController.nibInstance()
        let postsFeedViewController1 = PostsFeedViewController.nibInstance()
        let postsFeedViewController2 = PostsFeedViewController.nibInstance()
        let feedItems: [UIViewController & ProfileFeedContainerItem] = [postsFeedViewController,
                                                                        answersFeedViewController,
                                                                        postsFeedViewController1,
                                                                        postsFeedViewController2]
        
        profileFeedContainer.setFeedItems(feedItems, headerHeight: headerHeight, minimizedHeaderHeight: headerMinimizedHeight)
        
        view.bringSubview(toFront: profileInfoView)
        view.bringSubview(toFront: profileHeaderView)
        view.bringSubview(toFront: profileHorizontalSelector)
        
        profileHorizontalSelector.delegate = self
        profileHeaderView.delegate = self
        
        if let navigationController = self.navigationController {
            profileHeaderView.showBackButton(navigationController.viewControllers.count > 1)
        }
        
        profileHeaderViewHeightConstraint.constant = topViewHeight
        
//        profileInfoViewHeightConstraint.constant = middleViewHeight
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
//        Utils.inDevelopmentAlert()
        let alert = UIAlertController(title: "Выход", message: "Уверены?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Нет", style: .destructive, handler: nil)
        let ok = UIAlertAction(title: "Да", style: .default) { _ in
            self.presenter.logout()
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
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
    func didFail(with errorMessage: String) {
        Utils.showAlert(message: errorMessage)
    }
    
    func didRefreshUser() {
        guard let viewModel = presenter.getProfileViewModel() else {
            return
        }
        profileHeaderView.name = viewModel.name
        profileHeaderView.rankString = viewModel.rank
        profileHeaderView.starsAmountString = viewModel.starsAmount
        
        profileInfoView.information = viewModel.information
        profileInfoView.postsAmountString = viewModel.postsCount
        
        if let pictureUrlString = viewModel.pictureUrl {
            imageLoader.startLoadImage(with: pictureUrlString) { [weak self] image in
                guard let strongSelf = self else { return }
                let image = image ?? UIImage(named: "avatar_placeholder")
                strongSelf.profileHeaderView.avatarImage = image
            }
        }
        
        
        
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
