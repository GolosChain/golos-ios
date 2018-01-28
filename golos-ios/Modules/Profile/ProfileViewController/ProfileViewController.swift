//
//  ProfileViewController.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 15/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK: Constants
    let profileHeaderHeight: CGFloat = 180.0
    let profileInfoHeight: CGFloat = 145.0
    let segmentedControlHeight: CGFloat = 43.0
    let headerMinimizedHeight: CGFloat = 20.0
    
    //MARK: Outlets properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusBarImageViewBottomConstraint: NSLayoutConstraint!
    
    //MARK: UI Properties
    var tableHeaderView: UIView!
    let profileHeaderView = ProfileHeaderView()
    let profileInfoView = ProfileInfoView()
    
    
    //MARK: Module properties
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

    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
     
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    //MARK: Setup UI
    private func setupUI() {
        
        mediator.configure(tableView: tableView)
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        tableHeaderView = UIView()
        tableHeaderView.backgroundColor = .green
        tableHeaderView.frame = CGRect(x: 0, y: 0, width: 0, height: profileHeaderHeight + profileInfoHeight - headerMinimizedHeight)
        tableView.tableHeaderView = tableHeaderView
        setupHeaderAndInfoView()
        
        tableView.scrollIndicatorInsets = UIEdgeInsets(
            top: profileHeaderHeight + profileInfoHeight + segmentedControlHeight - headerMinimizedHeight,
            left: 0,
            bottom: 0,
            right: 0
        )
        tableView.contentInset = UIEdgeInsets(
            top: headerMinimizedHeight,
            left: 0,
            bottom: 0,
            right: 0
        )
        tableView.contentOffset = CGPoint(x: 0, y: -headerMinimizedHeight)
        
        statusImageView.image = Images.Profile.getProfileHeaderBackground()
        view.bringSubview(toFront: statusImageView)
        statusBarImageViewBottomConstraint.constant = headerMinimizedHeight
    }
    
    func setupHeaderAndInfoView() {
        var isEdit = false
        if let navigationController = navigationController {
            isEdit = navigationController.viewControllers.count == 1 ? true : false
        }
        
        profileHeaderView.isEdit = isEdit
        profileHeaderView.translatesAutoresizingMaskIntoConstraints = false
        profileHeaderView.backgroundImage = Images.Profile.getProfileHeaderBackground()
        profileHeaderView.delegate = self
        profileHeaderView.minimizedHeaderHeight = headerMinimizedHeight
        tableHeaderView.addSubview(profileHeaderView)
        
        profileInfoView.translatesAutoresizingMaskIntoConstraints = false
        tableHeaderView.addSubview(profileInfoView)
        
        profileHeaderView.topAnchor.constraint(equalTo: tableHeaderView.topAnchor, constant: -headerMinimizedHeight).isActive = true
        profileHeaderView.leftAnchor.constraint(equalTo: tableHeaderView.leftAnchor).isActive = true
        profileHeaderView.rightAnchor.constraint(equalTo: tableHeaderView.rightAnchor).isActive = true
        profileHeaderView.heightAnchor.constraint(equalToConstant: profileHeaderHeight).isActive = true

        profileInfoView.topAnchor.constraint(equalTo: profileHeaderView.bottomAnchor).isActive = true
        profileInfoView.leftAnchor.constraint(equalTo: profileHeaderView.leftAnchor).isActive = true
        profileInfoView.rightAnchor.constraint(equalTo: profileHeaderView.rightAnchor).isActive = true
        profileInfoView.bottomAnchor.constraint(equalTo: tableHeaderView.bottomAnchor).isActive = true
    }
    
    
    //MARK: Autolayout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeTableHeader()
    }
    
    private func sizeTableHeader() {
        let infoView = profileInfoView
        infoView.setNeedsLayout()
        infoView.layoutIfNeeded()
        
        let height = infoView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height + profileHeaderHeight
        let headerView = tableHeaderView
        var frame = headerView!.frame
        frame.size.height = height
        headerView?.frame = frame
        tableView.tableHeaderView = headerView
    }
    
    //MARK: Actions
}


//MARK: ProfileHeaderViewDelegate
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


//MARK: ProfileViewProtocol
extension ProfileViewController: ProfileViewProtocol {
    func didRefreshSuccess() {
        
    }
}


//MARK: ProfileMediatorDelegate
extension ProfileViewController: ProfileMediatorDelegate {
    func tableViewDidScroll(_ tableView: UITableView) {
        profileHeaderView.didChangeOffset(tableView.contentOffset.y)
        
        let offset = tableView.contentOffset.y
        if offset > profileHeaderHeight - (headerMinimizedHeight * 2) {
            statusImageView.alpha = 1
        } else {
            statusImageView.alpha = 0
        }
    }
    
    func heightForSegmentedControlHeight() -> CGFloat {
        return segmentedControlHeight
    }
}
