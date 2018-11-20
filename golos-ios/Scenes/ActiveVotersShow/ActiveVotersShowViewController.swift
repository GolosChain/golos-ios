//
//  ActiveVotersShowViewController.swift
//  golos-ios
//
//  Created by msm72 on 10/25/18.
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
protocol ActiveVotersShowDisplayLogic: class {
    func displaySubscribe(fromViewModel viewModel: ActiveVotersShowModels.Sub.ViewModel)
    func displayLoadActiveVoters(fromViewModel viewModel: ActiveVotersShowModels.Item.ViewModel)
}

class ActiveVotersShowViewController: GSBaseViewController {
    // MARK: - Properties
    var voters: [Voter]                 =   [Voter]()
    var selectedVoterInRow: Int         =   0

    var gsTimer: GSTimer?
    var loadVotersWorkItem: DispatchWorkItem!

    var interactor: ActiveVotersShowBusinessLogic?
    var router: (NSObjectProtocol & ActiveVotersShowRoutingLogic & ActiveVotersShowDataPassing)?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate             =   self
            self.tableView.dataSource           =   self

            self.tableView.tune()
            self.tableView.register(UINib(nibName: "ActiveUserTableViewCell", bundle: nil), forCellReuseIdentifier: "ActiveUserTableViewCell")
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
        let interactor              =   ActiveVotersShowInteractor()
        let presenter               =   ActiveVotersShowPresenter()
        let router                  =   ActiveVotersShowRouter()
        
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
        self.loadActiveVoters()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.localizeTitles()
        self.showNavigationBar()
        
        // Set StatusBarStyle
        selectedTabBarItem          =   self.navigationController!.tabBarItem.tag
        self.isStatusBarStyleLight  =   false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let votersWorkItem = self.loadVotersWorkItem, !votersWorkItem.isCancelled {
            votersWorkItem.cancel()
        }
        
        self.gsTimer                =   nil
        self.loadVotersWorkItem     =   nil
    }

    
    // MARK: - Custom Functions
    override func localizeTitles() {
        if let dataStore = self.router?.dataStore {
            self.title = (dataStore.activeVoterMode == .like ? "Voted Verb" : "Voted Against Verb").localized()
        }
    }
}


// MARK: - UsersVoteShowDisplayLogic
extension ActiveVotersShowViewController: ActiveVotersShowDisplayLogic {
    func displaySubscribe(fromViewModel viewModel: ActiveVotersShowModels.Sub.ViewModel) {
        let cell = self.tableView.cellForRow(at: IndexPath(row: self.selectedVoterInRow, section: 0)) as! ActiveUserTableViewCell
        
        // NOTE: Display the result from the Presenter
        if let error = viewModel.errorAPI {
            self.showAlertView(withTitle: "Error", andMessage: error.localizedDescription, needCancel: false, completion: { _ in })
        }
        
        // Set post author subscribe button title
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

    func displayLoadActiveVoters(fromViewModel viewModel: ActiveVotersShowModels.Item.ViewModel) {
        // NOTE: Display the result from the Presenter
        Logger.log(message: "Success", event: .severe)
        
        if let error = viewModel.errorAPI {
            self.showAlertView(withTitle: "Error", andMessage: error.localizedDescription, needCancel: false, completion: { _ in })
        }
        
        // CoreData
        DispatchQueue.main.async {
            self.fetchActiveVoters()
        }
    }
}


// MARK: - Load data from Blockchain by API
extension ActiveVotersShowViewController {
    func loadActiveVoters() {
        // Load Voters
        self.loadVotersWorkItem = DispatchWorkItem {
            self.gsTimer = GSTimer(operationName: "Load Users Voted list...", time: Double((self.router?.dataStore?.votersCount ?? 0) * 10), completion: { [weak self] success in
                if success {
                    self?.loadVotersWorkItem.cancel()
                    self?.loadActiveVoters()
                }
            })

            let usersVotedRequestModel = ActiveVotersShowModels.Item.RequestModel()
            self.interactor?.loadActiveVoters(withRequestModel: usersVotedRequestModel)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: self.loadVotersWorkItem)
    }
}


// MARK: - Fetch data from CoreData
extension ActiveVotersShowViewController {
    // User Profile
    private func fetchActiveVoters() {
        if let dataStore = self.router?.dataStore, let itemID = dataStore.itemID, let items = Voter.loadVoters(byPostID: itemID), items.count > 0, let votersMode = dataStore.activeVoterMode {
            self.voters = items.filter({ votersMode == .like ? $0.percent > 0 : $0.percent < 0 })
            
            self.tableView.reloadData()
            self.gsTimer?.stop()
        }
        
        else {
            
        }
    }
}


// MARK: - UITableViewDataSource
extension ActiveVotersShowViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.voters.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell    =   tableView.dequeueReusableCell(withIdentifier: "ActiveUserTableViewCell") as! ActiveUserTableViewCell
        let voter   =   self.voters[indexPath.row]
        
        cell.display(author: voter)
        
        // Handlers
        cell.handlerSubscribeButtonTapped           =   { [weak self] activeVoterShortInfo in
            guard (self?.isCurrentOperationPossible())! else { return }

            self?.selectedVoterInRow = self?.voters.firstIndex(where: { $0.voter == activeVoterShortInfo.nickName }) ?? 0

            guard activeVoterShortInfo.isSubscribe else {
                // API 'Subscribe'
                let requestModel = ActiveVotersShowModels.Sub.RequestModel(willSubscribe: true, authorNickName: activeVoterShortInfo.nickName)
                self?.interactor?.subscribe(withRequestModel: requestModel)

                // Run spinner
                DispatchQueue.main.async {
                    cell.subscribeButton.setTitle(nil, for: .normal)
                    cell.subscribeActivityIndicator.startAnimating()
                }
                
                return
            }
            
            // API 'Unsibscribe'
            self?.showAlertAction(withTitle: "Unsubscribe Verb", andMessage: String(format: "%@ @%@ ?", "Unsubscribe are you sure".localized(), activeVoterShortInfo.nickName), icon: activeVoterShortInfo.icon, actionTitle: "Cancel Subscribe Verb", needCancel: true, isCancelLeft: false, completion: { [weak self] success in
                if success {
                    let requestModel = ActiveVotersShowModels.Sub.RequestModel(willSubscribe: false, authorNickName: activeVoterShortInfo.nickName)
                    self?.interactor?.subscribe(withRequestModel: requestModel)

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
            self?.router?.routeToVoterUserProfileShowScene(byUserNickName: voterNickName)
        }
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension ActiveVotersShowViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.voters.count == 0 ? 48.0 : 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = CommentHeaderView.init(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.width, height: 48.0)))
        headerView.set(mode: .header)
        
        return headerView
    }
}
