//
//  UserFollowersShowViewController.swift
//  golos-ios
//
//  Created by msm72 on 10/29/18.
//  Copyright (c) 2018 golos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import CoreData
import GoloSwift

// MARK: - Input & Output protocols
protocol UserFollowersShowDisplayLogic: class {
    func displaySubscribe(fromViewModel viewModel: UserFollowersShowModels.Sub.ViewModel)
    func displayLoadFollowers(fromViewModel viewModel: UserFollowersShowModels.Item.ViewModel)
}

class UserFollowersShowViewController: GSBaseViewController {
    // MARK: - Properties
    var loadMoreStatus: Bool = false
    var followers: [Follower] = [Follower]()
    var headerView: CommentHeaderView!
    var selectedCell: ActiveUserTableViewCell?

    var interactor: UserFollowersShowBusinessLogic?
    var router: (NSObjectProtocol & UserFollowersShowRoutingLogic & UserFollowersShowDataPassing)?
    
    var gsTimer: GSTimer?
    var loadDataWorkItem: DispatchWorkItem!

    
    // MARK: - IBOutlets
    @IBOutlet var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.tableFooterView?.isHidden = true

            self.tableView.tune()
            self.tableView.register(UINib(nibName: "ActiveUserTableViewCell", bundle: nil), forCellReuseIdentifier: "ActiveUserTableViewCell")
        }
    }
    
    @IBOutlet weak var infiniteScrollingView: UIView! {
        didSet {
            self.infiniteScrollingView.tune()
            self.infiniteScrollingView.isHidden = true
        }
    }
    
    @IBOutlet weak var infiniteScrollingActivityIndicatorView: UIActivityIndicatorView! {
        didSet {
            self.infiniteScrollingActivityIndicatorView.stopAnimating()
        }
    }
    
    @IBOutlet weak var topLineView: UIView! {
        didSet {
            self.topLineView.tune(withThemeColorPicker: lightGrayishBlueWhiteColorPickers)
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
    }
    
    
    // MARK: - Setup
    private func setup() {
        let viewController          =   self
        let interactor              =   UserFollowersShowInteractor()
        let presenter               =   UserFollowersShowPresenter()
        let router                  =   UserFollowersShowRouter()
        
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
        
        // API
        self.loadDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.localizeTitles()
        self.showNavigationBar()
        
        // Set StatusBarStyle
        selectedTabBarItem          =   self.navigationController!.tabBarItem.tag
        self.isStatusBarStyleLight  =   AppSettings.isAppThemeDark
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let dataWorkItem = self.loadDataWorkItem, !dataWorkItem.isCancelled {
            dataWorkItem.cancel()
        }
        
        self.gsTimer                =   nil
        self.loadDataWorkItem       =   nil
    }

    
    // MARK: - Custom Functions
    override func localizeTitles() {
        if let dataStore = self.router?.dataStore {
            self.title = (dataStore.userSubscribeMode == .followers ? "Subscribers" : "Subscriptions").localized()
        }
    }
}


// MARK: - UserSubscribersShowDisplayLogic
extension UserFollowersShowViewController: UserFollowersShowDisplayLogic {
    func displaySubscribe(fromViewModel viewModel: UserFollowersShowModels.Sub.ViewModel) {
        // NOTE: Display the result from the Presenter
        if let error = viewModel.errorAPI {
            self.showAlertView(withTitle: "Error", andMessage: error.localizedDescription, needCancel: false, completion: { _ in })
        }
        
        // Set post author subscribe button title
        if let cell = self.selectedCell {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                self.showAlertView(withTitle:   viewModel.isFollowing ? "Subscribe Noun" : "Unsubscribe Noun",
                                   andMessage:  (viewModel.isFollowing ? "Subscribe Success" : "Unsubscribe Success").localized() + " @\(viewModel.authorNickName)", needCancel: false, completion: { _ in
                                    cell.subscribeButton.isSelected = viewModel.isFollowing
                                    cell.subscribeButton.setTitle(viewModel.isFollowing ? "Subscriptions".localized() : "Subscribe Verb".localized(), for: .normal)
                                    
                                    UIView.animate(withDuration: 0.5, animations: {
                                        viewModel.isFollowing ? cell.subscribeButton.setBorder(color: UIColor(hexString: "#dbdbdb").cgColor, cornerRadius: 5.0) :
                                            cell.subscribeButton.fill(font: UIFont(name: "SFProDisplay-Medium", size: 10.0)!)
                                    }, completion: { success in
                                        cell.subscribeActivityIndicator.stopAnimating()
                                    })
                })
            })
        }
    }

    func displayLoadFollowers(fromViewModel viewModel: UserFollowersShowModels.Item.ViewModel) {
        // NOTE: Display the result from the Presenter
        if let error = viewModel.errorAPI {
            self.showAlertView(withTitle: "Error", andMessage: error.localizedDescription, needCancel: false, completion: { _ in })
        }
            
        // Display empty message
        else if var dataStore = self.router?.dataStore, dataStore.totalItems == -1 {
            dataStore.totalItems = 0
            self.tableView.reloadData()
        }
        
        // CoreData
        else {
            DispatchQueue.main.async {
                self.fetchFollowers()
            }
        }
    }
}


// MARK: - Load data from Blockchain by API
extension UserFollowersShowViewController {
    func loadDataSource() {
        guard !self.loadMoreStatus && (self.router?.dataStore?.needPagination)! else {
            return
        }

        self.loadDataWorkItem = DispatchWorkItem {
            self.gsTimer = GSTimer(operationName: "Load Followers list...", time: Double((self.router?.dataStore?.totalItems ?? 0) * 10), completion: { [weak self] success in
                guard let strongSelf = self else { return }

                if success && !(strongSelf.loadDataWorkItem.isCancelled) {
                    strongSelf.loadDataWorkItem.cancel()
                    strongSelf.loadDataSource()
                }
            })

            let followersRequestModel = UserFollowersShowModels.Item.RequestModel()
            self.interactor?.loadFollowers(withRequestModel: followersRequestModel)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: self.loadDataWorkItem)
        self.loadMoreStatus = true
    }
}


// MARK: - Fetch data from CoreData
extension UserFollowersShowViewController {
    // User Profile
    private func fetchFollowers() {
        if var dataStore = self.router?.dataStore, var followersNew = Follower.loadFollowers(byUserNickName: dataStore.authorNickName, andPaginationPage: dataStore.paginationPage, forMode: dataStore.userSubscribeMode), followersNew.count > 0 {
            followersNew.removeAll(where: { $0.following == dataStore.lastAuthorNickName?.uppercaseFirst })
            self.followers.append(contentsOf: followersNew)
            
            dataStore.paginationPage += 1
            self.loadMoreStatus = false
            self.gsTimer?.stop()
            
            self.tableView.reloadData()

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                self.tableView.tableFooterView?.isHidden = true
                self.infiniteScrollingActivityIndicatorView.stopAnimating()
            })
        }
    }
}


// MARK: - UITableViewDataSource
extension UserFollowersShowViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.followers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveUserTableViewCell") as! ActiveUserTableViewCell
        
        let follower = self.followers[indexPath.row]
        cell.display(author: follower)
        
        // Handlers
        cell.handlerSubscribeButtonTapped           =   { [weak self] activeVoterShortInfo in
            guard let strongSelf = self else { return }
            
            guard strongSelf.isCurrentOperationPossible() else { return }
            
            strongSelf.selectedCell = cell
            
            guard activeVoterShortInfo.isSubscribe else {
                // API 'Subscribe'
                let requestModel = UserFollowersShowModels.Sub.RequestModel(willSubscribe: true, authorNickName: activeVoterShortInfo.nickName)
                strongSelf.interactor?.subscribe(withRequestModel: requestModel)
                
                // Run spinner
                DispatchQueue.main.async {
                    cell.subscribeButton.setTitle(nil, for: .normal)
                    cell.subscribeActivityIndicator.startAnimating()
                }
                
                return
            }
            
            // API 'Unsibscribe'
            strongSelf.showAlertAction(withTitle: "Unsubscribe Verb", andMessage: String(format: "%@ @%@ ?", "Unsubscribe are you sure".localized(), activeVoterShortInfo.nickName), icon: activeVoterShortInfo.icon, actionTitle: "Cancel Subscribe Verb", needCancel: true, isCancelLeft: false, completion: { [weak self] success in
                guard let strongSelf = self else { return }
                
                if success {
                    let requestModel = UserFollowersShowModels.Sub.RequestModel(willSubscribe: false, authorNickName: activeVoterShortInfo.nickName)
                    strongSelf.interactor?.subscribe(withRequestModel: requestModel)
                    
                    // Run spinner
                    DispatchQueue.main.async {
                        cell.subscribeButton.setTitle(nil, for: .normal)
                        cell.subscribeActivityIndicator.startAnimating()
                    }
                }
                    
                else {
                    cell.subscribeActivityIndicator.stopAnimating()
                }
            })
        }
        
        cell.handlerAuthorVoterTapped               =   { [weak self] voterNickName in
            guard let strongSelf = self else { return }
            
            strongSelf.router?.routeToUserProfileShowScene(byUserNickName: voterNickName)
        }

        return cell
    }
}


// MARK: - UITableViewDelegate
extension UserFollowersShowViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.followers.count <= 0 ? 48.0 : 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = CommentHeaderView.init(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.width, height: 48.0)))

        // Display empty message
        if let dataStore = self.router?.dataStore, dataStore.totalItems == 0 {
            headerView.set(mode: .headerEmpty)
            headerView.emptyItemsLabel.text             =   (dataStore.userSubscribeMode == .followers ? "Followers List is empty" : "Followings List is empty").localized()
            self.tableView.isUserInteractionEnabled     =   false
        }
        
        // Display spinner
        else {
            headerView.set(mode: .header)
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let activeUserTableViewCell = cell as? ActiveUserTableViewCell {
            activeUserTableViewCell.userProfileImageView.setTemplate(type: .userProfileImage)
        }
        
        if indexPath.row >= self.followers.count - 3 && !self.loadMoreStatus {
            self.loadDataSource()
            self.infiniteScrollingActivityIndicatorView.startAnimating()
            self.tableView.tableFooterView?.isHidden = false
        }
    }
}
