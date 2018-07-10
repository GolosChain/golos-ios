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
import MXParallaxHeader
import SWSegmentedControl

// MARK: - Input & Output protocols
protocol UserProfileShowDisplayLogic: class {
    func displayUserInfo(fromViewModel viewModel: UserProfileShowModels.UserInfo.ViewModel)
    func displayUserDetailsLenta(fromViewModel viewModel: UserProfileShowModels.UserDetails.ViewModel)
}

class UserProfileShowViewController: BaseViewController {
    // MARK: - Properties
    var refreshData: Bool               =   false
    var reloadData: Bool                =   false
    var segmentedControlIndex: Int      =   0
    var lastUserProfileDetailsIndexes   =   Array(repeating: 0, count: 2)
//    var lastVisibleRowIndexes           =   Array(repeating: 0, count: 2)

    var interactor: UserProfileShowBusinessLogic?
    var router: (NSObjectProtocol & UserProfileShowRoutingLogic & UserProfileShowDataPassing)?
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl          =   UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handlerTableViewRefresh), for: .valueChanged)
        
        return refreshControl
    }()
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var contentView: UIView!
   
    @IBOutlet weak var tableView: UITableViewWithReloadCompletion! {
        didSet {
            tableView.delegate              =   self
            tableView.dataSource            =   self
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
                self?.showAlertView(withTitle: "Exit", andMessage: "Are Your Sure?", needCancel: true, completion: { [weak self] success in
                    if success {
                        self?.router?.routeToLoginShowScene()
                    }
                })
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
            scrollView.parallaxHeader.height            =   180.0 * heightRatio
            scrollView.parallaxHeader.mode              =   MXParallaxHeaderMode.fill
            scrollView.parallaxHeader.minimumHeight     =   20.0

            scrollView.parallaxHeader.delegate          =   self
            scrollView.delegate                         =   self
        }
    }
    
    @IBOutlet weak var segmentedControlView: UIView! {
        didSet {
            let segmentedControl                        =   SWSegmentedControl(frame: CGRect(origin: .zero, size: segmentedControlView.frame.size))
            
            segmentedControl.items                      =   [ "Posts", "Answers" ].map({ $0.localized() })
            segmentedControl.selectedSegmentIndex       =   0
            segmentedControl.titleColor                 =   UIColor(hexString: "#333333")
            segmentedControl.indicatorColor             =   UIColor(hexString: "#1298FF")
            segmentedControl.font                       =   UIFont(name: "SFProDisplay-Medium", size: 13.0 * widthRatio)!
            segmentedControl.indicatorThickness         =   2.0 * heightRatio
            
            segmentedControl.delegate                   =   self
            
            segmentedControlView.addSubview(segmentedControl)
            segmentedControlView.tune()
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
            walletBalanceViewHeightConstraint.constant = 44.0 * heightRatio
        }
    }
    
    @IBOutlet weak var walletBalanceViewTopConstraint: NSLayoutConstraint! {
        didSet {
            walletBalanceViewTopConstraint.constant = walletBalanceView.isHidden ? -walletBalanceViewHeightConstraint.constant : 0.0
        }
    }

    @IBOutlet weak var userProfileInfoControlViewTopConstraint: NSLayoutConstraint! {
        didSet {
            userProfileInfoControlViewTopConstraint.constant = 0.0
        }
    }
    
    @IBOutlet weak var userProfileInfoTitleViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            userProfileInfoTitleViewHeightConstraint.constant *= heightRatio
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
        
        self.hideNavigationBar()
        self.loadViewSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load User info
        self.loadUserInfo()
        
        // Load User details
        self.loadUserDetails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
        self.userProfileHeaderView.showLabelsForAnimationCollection(false)
        self.userProfileInfoTitleView.showLabelsForAnimationCollection(false)
    }
    
    
    // MARK: - Custom Functions
    private func loadViewSettings() {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        // Wallet Balance View show/hide
        if !walletBalanceView.isHidden {
            view.bringSubview(toFront: walletBalanceView)
            walletBalanceViewTopConstraint.constant                 =   0.0
            userProfileInfoControlViewTopConstraint.constant        =   10.0 * heightRatio
            walletBalanceView.add(shadow: true, onside: .bottom)
        }
    }
    
    private func tableViewClear() {
        reloadData = !reloadData
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Actions
    @objc func handlerTableViewRefresh(refreshControl: UIRefreshControl) {
        self.refreshData                                            =   !self.refreshData
        self.lastUserProfileDetailsIndexes[segmentedControlIndex]   =   0
//        self.lastVisibleRowIndexes[segmentedControlIndex]           =   0

        self.interactor?.save(nil)
        self.loadUserDetails()
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
    private func loadUserDetails() {
        switch segmentedControlIndex {
        // Answers
        case 1:
            let userDetailsAnswersRequestModel = UserProfileShowModels.UserDetails.RequestModel()
            interactor?.loadUserDetailsLenta(withRequestModel: userDetailsAnswersRequestModel)

        // Comments
        case 2:
            print("Comments")
            
        // Favorites
        case 3:
            print("Favorites")
            
        // Information
        case 4:
            print("Information")
            
        // Lenta (blogs)
        default:
            let userDetailsLentaRequestModel = UserProfileShowModels.UserDetails.RequestModel()
            interactor?.loadUserDetailsLenta(withRequestModel: userDetailsLentaRequestModel)
        }
    }
}


// MARK: - Fetch data from CoreData
extension UserProfileShowViewController {
    // User Profile
    private func fetchUserInfo() {
        if let userEntity = User.current {
            let displayedUser = DisplayedUser(fromUser: userEntity)
            
            self.userProfileHeaderView.updateUI(fromUserInfo: displayedUser)
            self.userProfileInfoTitleView.updateUI(fromUserInfo: displayedUser)
            
            // Change profileInfoView height
            if let info = displayedUser.about, !info.isEmpty {
                userProfileInfoTitleViewHeightConstraint.constant *= 2
            }
        }
    }
    
    // User Details
    private func fetchUserDetails() {
        var fetchRequest: NSFetchRequest<NSFetchRequestResult>
        var primarySortDescriptor: NSSortDescriptor
        var secondarySortDescriptor: NSSortDescriptor
        
        switch segmentedControlIndex {
        // Answers
        case 1:
            fetchRequest                =   NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            primarySortDescriptor       =   NSSortDescriptor(key: "id", ascending: true)
            secondarySortDescriptor     =   NSSortDescriptor(key: "name", ascending: true)
            
        // Comments
        case 2:
            fetchRequest                =   NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            primarySortDescriptor       =   NSSortDescriptor(key: "id", ascending: true)
            secondarySortDescriptor     =   NSSortDescriptor(key: "name", ascending: true)

        // Favorites
        case 3:
            fetchRequest                =   NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            primarySortDescriptor       =   NSSortDescriptor(key: "id", ascending: true)
            secondarySortDescriptor     =   NSSortDescriptor(key: "name", ascending: true)

        // Information
        case 4:
            fetchRequest                =   NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            primarySortDescriptor       =   NSSortDescriptor(key: "id", ascending: true)
            secondarySortDescriptor     =   NSSortDescriptor(key: "name", ascending: true)

        // Lenta (blogs)
        default:
            fetchRequest                =   NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
            primarySortDescriptor       =   NSSortDescriptor(key: "created", ascending: false)
            secondarySortDescriptor     =   NSSortDescriptor(key: "author", ascending: true)
            fetchRequest.predicate      =   NSPredicate(format: "author == %@ AND feedType == %@", User.current!.name, "lenta")
        }
        
        fetchRequest.sortDescriptors    =   [ primarySortDescriptor, secondarySortDescriptor ]
        
        if self.lastUserProfileDetailsIndexes[segmentedControlIndex] == 0 {
            fetchRequest.fetchLimit     =   Int(loadDataLimit)
        }
        
        else {
            fetchRequest.fetchLimit     =   Int(loadDataLimit) + self.lastUserProfileDetailsIndexes[segmentedControlIndex]
        }

        fetchedResultsController        =   NSFetchedResultsController(fetchRequest:            fetchRequest,
                                                                       managedObjectContext:    CoreDataManager.instance.managedObjectContext,
                                                                       sectionNameKeyPath:      nil,
                                                                       cacheName:               nil)
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()

//            // Reload data completion
//            self.tableView.reloadDataWithCompletion {
//                DispatchQueue.main.async { [weak self] () in
//                    self?.tableView.scrollToRow(at: IndexPath(row: (self?.lastVisibleRowIndexes[(self?.segmentedControlIndex)!])!, section: 0), at: .bottom, animated: false)
//                }
//            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            if self.refreshData {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.9) {
                    self.refreshControl.endRefreshing()
                }
                
                self.refreshData = !self.refreshData
            }
        } catch {
            Logger.log(message: error.localizedDescription, event: .error)
        }
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
    
    func displayUserDetailsLenta(fromViewModel viewModel: UserProfileShowModels.UserDetails.ViewModel) {
        // NOTE: Display the result from the Presenter
        if let error = viewModel.error {
            self.showAlertView(withTitle: "Error", andMessage: error.localizedDescription, needCancel: false, completion: { _ in })
        }
        
        // CoreData
        self.fetchUserDetails()
    }
}


// MARK: - UIScrollViewDelegate
extension UserProfileShowViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        Logger.log(message: String(format: "scrollView.contentOffset.y %f", scrollView.contentOffset.y), event: .debug)
        Logger.log(message: String(format: "segmentedControlView.frame.origin.y %f", view.convert(segmentedControlView.frame, from: contentView).origin.y), event: .debug)
    }
}


// MARK: - MXParallaxHeaderDelegate
extension UserProfileShowViewController: MXParallaxHeaderDelegate {
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        Logger.log(message: String(format: "progress %f", parallaxHeader.progress), event: .debug)

        UIApplication.shared.statusBarStyle                     =   parallaxHeader.progress == 0.0 ? .default : .lightContent
        self.userProfileHeaderView.whiteStatusBarView.isHidden  =   parallaxHeader.progress != 0.0
    }
}


// MARK: - SWSegmentedControlDelegate
extension UserProfileShowViewController: SWSegmentedControlDelegate {
    func segmentedControl(_ control: SWSegmentedControl, willSelectItemAtIndex index: Int) {
        print("will select \(index)")
    }
    
    func segmentedControl(_ control: SWSegmentedControl, didSelectItemAtIndex index: Int) {
        print("did select \(index)")
    }
    
    func segmentedControl(_ control: SWSegmentedControl, willDeselectItemAtIndex index: Int) {
        print("will deselect \(index)")
    }
    
    func segmentedControl(_ control: SWSegmentedControl, didDeselectItemAtIndex index: Int) {
        self.tableViewClear()
        self.segmentedControlIndex  =   index
        self.loadUserDetails()
    }
    
    func segmentedControl(_ control: SWSegmentedControl, canSelectItemAtIndex index: Int) -> Bool {
        guard !self.refreshData else {
            return false
        }
        
        return true
    }
}


// MARK: - UITableViewDataSource
extension UserProfileShowViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard fetchedResultsController != nil else {
            return 0
        }
        
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !reloadData else {
            reloadData = !reloadData
            return 0
        }

        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell    =   tableView.dequeueReusableCell(withIdentifier: "BlogCell", for: indexPath)
        
        switch segmentedControlIndex {
        // Answers
        case 1:
            let answerEntity        =   fetchedResultsController.object(at: indexPath) as! User
            cell.textLabel?.text    =   answerEntity.name

        // Lenta (blog)
        default:
            let postEntity              =   fetchedResultsController.object(at: indexPath) as! Post
            cell.textLabel?.text        =   postEntity.body
            cell.detailTextLabel?.text  =   "\(indexPath.row)"
        }
        
//        if tableView.numberOfRows(inSection: indexPath.section) - 1 == indexPath.row {
//            self.lastVisibleRowIndexes[segmentedControlIndex] = indexPath.row
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            
            return currentSection.name
        }
        
        return nil
    }
}


// MARK: - UITableViewDelegate
extension UserProfileShowViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastIndex           =   tableView.numberOfRows(inSection: indexPath.section) - 1
        let lastElement         =   fetchedResultsController.sections![indexPath.section].objects![lastIndex]
        
        if lastIndex == indexPath.row && lastIndex > self.lastUserProfileDetailsIndexes[segmentedControlIndex] {
            // Lenta (blogs)
            if let post = lastElement as? Post {
                self.interactor?.save(post)
            }

            // Answers
//            if let displayedPost = lastElement as? DisplayedPost {
//                self.interactor?.save(displayedPost)
//            }

            // Load more User Profile details
            self.lastUserProfileDetailsIndexes[segmentedControlIndex]   =   lastIndex
            self.loadUserDetails()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
}


// MARK: - NSFetchedResultsControllerDelegate
extension UserProfileShowViewController: NSFetchedResultsControllerDelegate {
}
