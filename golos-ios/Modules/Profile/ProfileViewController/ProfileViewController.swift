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
    
    
    //MARK: UI Properties
    var topView: UIView!
    var profileHeaderView: ProfileHeaderView!
    var profileInfoView: ProfileInfoView!
    var tableHeaderView: UIView!
    
    var topViewHeightConstraint: NSLayoutConstraint!
    
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
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        mediator.configure(tableView: tableView)
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
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
        
        tableHeaderView = UIView()
        tableHeaderView.frame = CGRect(
            x: 0,
            y: 0,
            width: 0,
            height: profileHeaderHeight + profileInfoHeight - headerMinimizedHeight
        )
        tableHeaderView.backgroundColor = .green
        tableView.tableHeaderView = tableHeaderView
        
        setupHeaderAndInfoView()
//        topView.frame = CGRect(x: 0, y: -headerMinimizedHeight, width: UIScreen.main.bounds.width, height: profileHeaderHeight + profileInfoHeight)
        topView.backgroundColor = .yellow
        tableView.addSubview(topView)
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        topView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
//        topViewHeightConstraint = topView.heightAnchor.constraint(equalToConstant: 100)
//        topViewHeightConstraint.isActive = true
        topView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
    }
    
    func setupHeaderAndInfoView() {
        profileHeaderView = ProfileHeaderView()
        profileHeaderView.translatesAutoresizingMaskIntoConstraints = false
        profileHeaderView.backgroundImage = Images.Profile.getProfileHeaderBackground()
        profileHeaderView.delegate = self
        
        profileInfoView = ProfileInfoView()
        profileInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        topView = UIView()
        topView.addSubview(profileHeaderView)
        topView.addSubview(profileInfoView)
//
        profileHeaderView.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
        profileHeaderView.leftAnchor.constraint(equalTo: topView.leftAnchor).isActive = true
        profileHeaderView.rightAnchor.constraint(equalTo: topView.rightAnchor).isActive = true
//        profileHeaderView.heightAnchor.constraint(equalToConstant: profileHeaderHeight).isActive = true
        profileInfoView.topAnchor.constraint(equalTo: profileHeaderView.bottomAnchor).isActive = true
        profileInfoView.leftAnchor.constraint(equalTo: topView.leftAnchor).isActive = true
        profileInfoView.rightAnchor.constraint(equalTo: topView.rightAnchor).isActive = true
//        profileInfoView.heightAnchor.constraint(equalToConstant: profileInfoHeight).isActive = true
        profileInfoView.bottomAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        
    }
    
    
    //MARK: Autolayout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        CGRect headerFrame           = self.profile.tableHeaderView.frame;
//        headerFrame.size.height      = self.myStatus.frame.size.height + offset;
//        self.header.frame            = headerFrame;
//        self.profile.tableHeaderView = self.header;
        
        var headerFrame = tableHeaderView.frame
        headerFrame.size.height = topView.bounds.height
        tableHeaderView.frame = headerFrame
        tableView.tableHeaderView = tableHeaderView
        tableView.reloadData()
//        profileHeaderView.setNeedsLayout()
//        profileHeaderView.layoutIfNeeded()
//        tableView.beginUpdates()
//        tableView.endUpdates()
        
//        topViewHeightConstraint.constant = profileHeaderView.bounds.size.height + profileInfoView.bounds.size.height
//        topView.setNeedsLayout()
//        topView.layoutIfNeeded()
        
//        print(topView.frame.height)
//        var topViewFrame = topView.frame
//        topViewFrame.size.height = profileHeaderHeight + profileInfoView.bounds.size.height
//        print(profileHeaderHeight + profileInfoView.bounds.size.height)
//        topView.frame = topViewFrame
    }
    
    //MARK: Actions
}


//MARK: ProfileHeaderViewDelegate
extension ProfileViewController: ProfileHeaderViewDelegate {
    func didPressEditProfileButton() {
        
        Utils.inDevelopmentAlert()
    }
    
    func didPressSettingsButton() {
        profileInfoView.information = "shdjshj djs hdjhjs jsdhjshj hjhdjs hjdh sjdhj shdj hd shdjshj djs hdjhjs jsdhjshj hjhdjs hjdh sjdhj shdj hd shdjshj djs hdjhjs jsdhjshj hjhdjs hjdh sjdhj shdj hd shdjshj djs hdjhjs jsdhjshj hjhdjs hjdh sjdhj shdj hd shdjshj djs hdjhjs jsdhjshj hjhdjs hjdh sjdhj shdj hd shdjshj djs hdjhjs jsdhjshj hjhdjs hjdh sjdhj shdj hd shdjshj djs hdjhjs jsdhjshj hjhdjs hjdh sjdhj shdj hd shdjshj djs hdjhjs jsdhjshj hjhdjs hjdh sjdhj shdj hd  shdjshj djs hdjhjs jsdhjshj hjhdjs hjdh sjdhj shdj hd shdjshj djs hdjhjs jsdhjshj hjhdjs hjdh sjdhj shdj hd shdjshj djs hdjhjs jsdhjshj hjhdjs hjdh sjdhj shdj hd shdjshj djs hdjhjs jsdhjshj hjhdjs hjdh sjdhj shdj hd shdjshj djs hdjhjs jsdhjshj hjhdjs hjdh sjdhj shdj hd shdjshj djs hdjhjs jsdhjshj hjhdjs hjdh sjdhj shdj hd shdjshj djs hdjhjs jsdhjshj hjhdjs hjdh sjdhj shdj hd shdjshj djs hdjhjs jsdhjshj hjhdjs hjdh sjdhj shdj hd shdjshj djs hdjhjs jsdhjshj hjhdjs hjdh sjdhj shdj hd shdjshj djs hdjhjs jsdhjshj hjhdjs hjdh sjdhj shdj hd shdjshj djs hdjhjs jsdhjshj hjhdjs hjdh sjdhj shdj hd shdjshj djs hdjhjs jsdhjshj hjhdjs hjdh sjdhj shdj hd shdjshj djs hdjhjs jsdhjshj hjhdjs hjdh sjdhj shdj hd shdjshj djs hdjhjs jsdhjshj hjhdjs hjdh sjdhj shdj hd shdjshj djs hdjhjs jsdhjshj hjhdjs hjdh sjdhj shdj hd shdjshj djs hdjhjs jsdhjshj hjhdjs hjdh sjdhj shdj hd shdjshj djs hdjhjs jsdhjshj hjhdjs hjdh sjdhj shdj hd shdjshj djs hdjhjs jsdhjshj hjhdjs hjdh sjdhj shdj hd shdjshj djs hdjhjs jsdhjshj hjhdjs hjdh sjdhj shdj hd shdjshj djs hdjhjs jsdhjshj hjhdjs hjdh sjdhj shdj hd"
//        Utils.inDevelopmentAlert()
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
        print("dsds")
    }
    
    func heightForSegmentedControlHeight() -> CGFloat {
        return segmentedControlHeight
    }
}
