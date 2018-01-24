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
    private let headerStopSize: CGFloat = 64.0
    private let scrollTopContentOffset: CGFloat = 64.0
    
    
    //MARK: Outlets properties
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var headerView: ProfileHeaderView!
    @IBOutlet weak var infoView: ProfileInfoView!
    @IBOutlet weak var statusBarImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    
    //MARK: Module properties
    lazy var presenter: ProfilePresenterProtocol = {
        let presenter = ProfilePresenter()
        presenter.profileView = self
        return presenter
    }()

    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
     
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            guard let change = change, let value = change[NSKeyValueChangeKey.newKey] as? NSValue else {return}
            let size = value.cgSizeValue
            tableViewHeight.constant = size.height
        }
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
        if let navigationController = navigationController {
            headerView.showBackButton(navigationController.viewControllers.count > 1)
        }
        
        mainScrollView.delegate = self
        mainScrollView.delaysContentTouches = false
        var topInset: CGFloat = -20
        if UIDevice.getDeviceScreenSize() == .iphoneX {
            topInset = -44
        }
        mainScrollView.contentInset = UIEdgeInsetsMake(topInset, 0, 0, 0)
        
        let img = Images.Profile.getProfileHeaderBackground()
        headerView.backgroundImage = img
        headerView.delegate = self
        
        statusBarImageView.alpha = 0
        statusBarImageView.image = headerView.backgroundImage
    }
    
    
    //MARK: Actions
    @IBAction func logoutButtonPressed(_ sender: Any) {
        
    }
    
    @objc
    private func didPressEditProfileButton(_ button: UIButton) {
        
    }
    
    @objc
    private func didPressSettingsButton(_ button: UIButton) {
        
    }
}

extension ProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        if yOffset < 0 {
            let absYOffset = -yOffset
            headerHeightConstraint.constant = 180 + absYOffset

            let alpha = (absYOffset / 100) * 2
            headerView.setBlurViewAlpha(alpha)
            
            if absYOffset > 60 {
                headerView.startLoading()
                presenter.refresh()
            }
            statusBarImageView.alpha = 0
        } else {
            headerHeightConstraint.constant = 180
            if 180 - yOffset <= 20 {
                statusBarImageView.alpha = 1
            } else {
                statusBarImageView.alpha = 0
            }
        }
    }
}

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

extension ProfileViewController: ProfileViewProtocol {
    func didRefreshSuccess() {
        headerView.stopLoading()
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        return cell!
    }
}

