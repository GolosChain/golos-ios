//
//  PostShowViewController.swift
//  golos-ios
//
//  Created by msm72 on 31.07.2018.
//  Copyright (c) 2018 golos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import WebKit
import CoreData
import GoloSwift
import MarkdownView
import SafariServices
import AlignedCollectionViewFlowLayout

// MARK: - Input & Output protocols
protocol PostShowDisplayLogic: class {
    func displayLoadContent(fromViewModel viewModel: PostShowModels.Post.ViewModel)
}

class PostShowViewController: GSBaseViewController {
    // MARK: - Properties
    var interactor: PostShowBusinessLogic?
    var router: (NSObjectProtocol & PostShowRoutingLogic & PostShowDataPassing)?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var markdownView: MarkdownView!
    @IBOutlet weak var postFeedHeaderView: PostFeedHeaderView!
    
    @IBOutlet weak var tagsCollectionView: UICollectionView! {
        didSet {
            tagsCollectionView.register(UINib(nibName:               "PostShowTagCollectionViewCell", bundle: nil),
                                        forCellWithReuseIdentifier:  "PostShowTagCollectionViewCell")
            
            tagsCollectionView.tune()
            tagsCollectionView.delegate     =   self
            tagsCollectionView.dataSource   =   self
            
            tagsCollectionView.collectionViewLayout = AlignedCollectionViewFlowLayout.init(horizontalAlignment: .left, verticalAlignment: .top)
        }
    }
    
    @IBOutlet weak var contentView: UIView! {
        didSet {
            contentView.tune()
            contentView.alpha = 0.0
        }
    }
    
    @IBOutlet weak var navbarView: UIView! {
        didSet {
            navbarView.tune()
        }
    }
    
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            shadowView.setGradientBackground(colors: [UIColor.lightGray.cgColor, UIColor.lightText.cgColor], onside: .bottom)
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.tune(withText:           "",
                            hexColors:          veryDarkGrayWhiteColorPickers,
                            font:               UIFont(name: "SFUIDisplay-Medium", size: 15.0 * widthRatio),
                            alignment:          .left,
                            isMultiLines:       true)
        }
    }
    
    @IBOutlet weak var upvoteButton: UIButton! {
        didSet {
            upvoteButton.tune(withTitle:        "$23.22",
                              hexColors:        [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                              font:             UIFont(name: "SFUIDisplay-Regular", size: 10.0 * widthRatio),
                              alignment:        .left)
            
            upvoteButton.isEnabled      =   false
        }
    }
    
    @IBOutlet weak var usersButton: UIButton! {
        didSet {
            usersButton.tune(withTitle:        "42",
                             hexColors:        [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                             font:             UIFont(name: "SFUIDisplay-Regular", size: 10.0 * widthRatio),
                             alignment:        .left)
            
            usersButton.isEnabled       =   false
        }
    }
    
    @IBOutlet weak var commentsButton: UIButton! {
        didSet {
            commentsButton.tune(withTitle:        "50",
                                hexColors:        [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                                font:             UIFont(name: "SFUIDisplay-Regular", size: 10.0 * widthRatio),
                                alignment:        .left)
            
            commentsButton.isEnabled    =   false
        }
    }
    
    @IBOutlet weak var flauntButton: UIButton! {
        didSet {
            flauntButton.tune(withTitle:        "Flaunt Verb",
                              hexColors:        [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                              font:             UIFont(name: "SFUIDisplay-Regular", size: 10.0 * widthRatio),
                              alignment:        .left)
            
            flauntButton.isEnabled      =   false
        }
    }
    
    @IBOutlet weak var promoteButton: UIButton! {
        didSet {
            promoteButton.tune(withTitle:        "Promote Post Verb",
                               hexColors:        [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                               font:             UIFont(name: "SFUIDisplay-Medium", size: 11.0 * widthRatio),
                               alignment:        .center)
            
            promoteButton.isEnabled     =   false
            
            promoteButton.setBorder(color: UIColor(hexString: "#6ad381").cgColor, cornerRadius: 4.0 * heightRatio)
        }
    }
    
    @IBOutlet weak var donateButton: UIButton! {
        didSet {
            donateButton.tune(withTitle:        "Donate Verb",
                               hexColors:        [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                               font:             UIFont(name: "SFUIDisplay-Medium", size: 11.0 * widthRatio),
                               alignment:        .center)
            
            donateButton.isEnabled      =   true
           
            donateButton.setBorder(color: UIColor(hexString: "#6ad381").cgColor, cornerRadius: 4.0 * heightRatio)
        }
    }
    
    // Subscribe by Topic
    @IBOutlet weak var topicCoverImageView: UIImageView!
    
    @IBOutlet weak var topicPublishedInLabel: UILabel! {
        didSet {
            topicPublishedInLabel.tune(withText:         "Published in",
                                       hexColors:        darkGrayWhiteColorPickers,
                                       font:             UIFont(name: "SFUIDisplay-Regular", size: 8.0 * widthRatio),
                                       alignment:        .left,
                                       isMultiLines:     false)
        }
    }
    
    @IBOutlet weak var topicTitleLabel: UILabel! {
        didSet {
            topicTitleLabel.tune(withText:         "",
                                 hexColors:        darkGrayWhiteColorPickers,
                                 font:             UIFont(name: "SFUIDisplay-Regular", size: 12.0 * widthRatio),
                                 alignment:        .left,
                                 isMultiLines:     false)
        }
    }
    
    // Subscribe by User
    @IBOutlet weak var userAvatarImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel! {
        didSet {
            userNameLabel.tune(withText:        "",
                               hexColors:       veryDarkGrayWhiteColorPickers,
                               font:            UIFont(name: "SFUIDisplay-Regular", size: 12.0 * widthRatio), alignment: .left,
                               isMultiLines:    false)
        }
    }
    
    @IBOutlet weak var userRecentPastLabel: UILabel! {
        didSet {
            userRecentPastLabel.tune(withText:        "Recent Past:",
                                     hexColors:       darkGrayWhiteColorPickers,
                                     font:            UIFont(name: "SFUIDisplay-Regular", size: 8.0 * widthRatio), alignment: .left,
                                     isMultiLines:    false)
        }
    }
    
    @IBOutlet weak var userPreviouslyLabel: UILabel! {
        didSet {
            userPreviouslyLabel.tune(withText:        "Previously:",
                                     hexColors:       darkGrayWhiteColorPickers,
                                     font:            UIFont(name: "SFUIDisplay-Regular", size: 8.0 * widthRatio), alignment: .left,
                                     isMultiLines:    false)
        }
    }
    
    @IBOutlet var subscribeButtonsCollection: [UIButton]! {
        didSet {
            _ = subscribeButtonsCollection.map({ button in
                button.tune(withTitle:         "Subscribe",
                            hexColors:         [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                            font:              UIFont(name: "SFUIDisplay-Medium", size: 10.0 * widthRatio),
                            alignment:         .center)
                
                button.setBorder(color: UIColor(hexString: "#dbdbdb").cgColor, cornerRadius: 4.0 * heightRatio)
            })
        }
    }
    
    @IBOutlet weak var bottomLineView: UIView! {
        didSet {
            bottomLineView.tune(withThemeColorPicker: veryLightGrayColorPickers)
        }
    }
    
    @IBOutlet var backgroundGrayViewsCollection: [UIView]! {
        didSet {
            _ = backgroundGrayViewsCollection.map({ $0.theme_backgroundColor = veryLightGrayColorPickers })
        }
    }
    
    @IBOutlet weak var commentsTitleLabel: UILabel! {
        didSet {
            commentsTitleLabel.tune(withText:           "Comments Noun",
                                    hexColors:          veryDarkGrayWhiteColorPickers,
                                    font:               UIFont(name: "SFUIDisplay-Regular", size: 14.0 * widthRatio),
                                    alignment:          .left,
                                    isMultiLines:       false)
        }
    }

    @IBOutlet weak var commentsCountLabel: UILabel! {
        didSet {
            commentsCountLabel.tune(withText:           "42",
                                    hexColors:          grayWhiteColorPickers,
                                    font:               UIFont(name: "SFUIDisplay-Regular", size: 14.0 * widthRatio),
                                    alignment:          .left,
                                    isMultiLines:       false)
        }
    }

    @IBOutlet weak var sortByLabel: UILabel! {
        didSet {
            sortByLabel.tune(withText:           "Sort by",
                             hexColors:          grayWhiteColorPickers,
                             font:               UIFont(name: "SFUIDisplay-Regular", size: 10.0 * widthRatio),
                             alignment:          .left,
                             isMultiLines:       false)
        }
    }

    @IBOutlet weak var commentsSortByButton: UIButton! {
        didSet {
            commentsSortByButton.tune(withTitle:        "Action Sheet First New",
                                      hexColors:        [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                                      font:             UIFont(name: "SFUIDisplay-Regular", size: 10.0 * widthRatio),
                                      alignment:        .center)
            
            commentsSortByButton.isEnabled      =   true
        }
    }

    @IBOutlet weak var commentsHideButton: UIButton! {
        didSet {
            commentsHideButton.tune(withTitle:        "Hide Comments Verb",
                                    hexColors:        [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                                    font:             UIFont(name: "SFUIDisplay-Medium", size: 8.0 * widthRatio),
                                    alignment:        .center)
            
            commentsHideButton.isEnabled        =   true
            
            commentsHideButton.setBorder(color: UIColor(hexString: "#dbdbdb").cgColor, cornerRadius: 4.0 * heightRatio)
        }
    }
    
    // Collections
    @IBOutlet var circleImagesCollection: [UIImageView]! {
        didSet {
            _ = circleImagesCollection.map({ $0.layer.cornerRadius = $0.bounds.height / 2 })
        }
    }
    
    
    @IBOutlet var heightsCollection: [NSLayoutConstraint]! {
        didSet {
            _ = heightsCollection.map({ $0.constant *= heightRatio })
        }
    }
    
    @IBOutlet var widthsCollection: [NSLayoutConstraint]! {
        didSet {
            _ = widthsCollection.map({ $0.constant *= widthRatio })
        }
    }
    
    @IBOutlet weak var buttonsStackViewTopConstraint: NSLayoutConstraint! {
        didSet {
            buttonsStackViewTopConstraint.constant = -34.0 * heightRatio * 0.0
        }
    }
    
    @IBOutlet weak var tagsCollectionViewheightConstraint: NSLayoutConstraint!
    @IBOutlet weak var markdownViewHeightConstraint: NSLayoutConstraint!
    
    
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
        let interactor              =   PostShowInteractor()
        let presenter               =   PostShowPresenter()
        let router                  =   PostShowRouter()
        
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
    override func viewDidLayoutSubviews() {
        self.tagsCollectionViewheightConstraint.constant    =   self.tagsCollectionView.contentSize.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Handlers
        self.postFeedHeaderView.handlerAuthorTapped         =   { [weak self] in
            self?.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .default
        
        // Load Post
        self.loadContent()
    }

    
    // MARK: - Custom Functions
    private func loadViewSettings() {
        if let displayedPost = self.router?.dataStore?.post as? PostCellSupport {
            self.titleLabel.text = displayedPost.title
            
            // Load markdown content
            self.markdownView.isScrollEnabled = false
            
            self.markdownView.onRendered = { [weak self] height in
                self?.markdownViewHeightConstraint.constant = height
                
                UIView.animate(withDuration: 0.5, animations: {
                    self?.contentView.alpha = 1.0
                })
            }
            
            DispatchQueue.main.async {
                self.markdownView.load(markdown: displayedPost.body)
            }
            
            // Handler: display content in App
            self.markdownView.onTouchLink = { [weak self] request in
                guard let url = request.url else {
                    self?.showAlertView(withTitle: "Error", andMessage: "Broken Link Failure", needCancel: false, completion: { _ in })
                    return false
                }
                
                if url.scheme == "file", let userName = url.pathComponents.last, userName.hasPrefix("@") {
                    self?.router?.routeToUserProfileScene(byUserName: userName.replacingOccurrences(of: "@", with: ""))
                    return true
                }
                
                else if url.scheme!.hasPrefix("http") {
                    let safari = SFSafariViewController(url: url)
                    self?.present(safari, animated: true, completion: nil)

                    return false
                }
                
                else {
                    self?.showAlertView(withTitle: "Error", andMessage: "Broken Link Failure", needCancel: false, completion: { _ in })
                    return false
                }
            }
            
            // Subscribe topic
            if let firstTag = displayedPost.tags?.first {
                self.topicTitleLabel.text       =   firstTag.uppercaseFirst
            }
            
            // Subscribe User
            self.userAvatarImageView.image      =   self.postFeedHeaderView.authorProfileImageView.image
            self.userNameLabel.text             =   self.postFeedHeaderView.authorLabel.text
        }
    }
    
    
    // MARK: - Actions
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        self.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        let urlString   =   "https://www.google.com/any-link-to-share"
        let shareText   =   "Hello, world!"
        
        if let image = try! UIImage(data: Data(contentsOf: URL(string: "https://www.google.co.in/logos/doodles/2017/mohammed-rafis-93th-birthday-5885879699636224.2-l.png")!)) {
            let activityVC  =   UIActivityViewController(activityItems: [shareText, urlString, image], applicationActivities: nil)
            present(activityVC, animated: true, completion: nil)
            
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView  =   self.view
            }
        }
    }
    
    @IBAction func upvoteButtonTapped(_ sender: UIButton) {
        self.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
    }

    @IBAction func usersButtonTapped(_ sender: UIButton) {
        self.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
    }

    @IBAction func commentsButtonTapped(_ sender: UIButton) {
        self.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
    }

    @IBAction func flauntButtonTapped(_ sender: UIButton) {
        self.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
    }

    @IBAction func promoteButtonTapped(_ sender: UIButton) {
        sender.layer.borderColor = UIColor(hexString: "#6ad381").cgColor

        self.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
    }

    @IBAction func donateButtonTapped(_ sender: UIButton) {
        sender.layer.borderColor = UIColor(hexString: "#6ad381").cgColor

        self.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
    }
    
    @IBAction func buttonsTappedDown(_ sender: UIButton) {
        sender.layer.borderColor = UIColor(hexString: "#dbdbdb").cgColor
    }

    @IBAction func sortCommentsByButtonTapped(_ sender: UIButton) {
        self.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
    }

    @IBAction func hideCommentsButtonTapped(_ sender: UIButton) {
        self.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
    }
    
    @IBAction func subscribeButtonTapped(_ sender: UIButton) {
        sender.setBorder(color: UIColor(hexString: "#dbdbdb").cgColor, cornerRadius: 4.0 * heightRatio)
        
        self.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
    }
    
    @IBAction func subscribeButtonTappedDown(_ sender: UIButton) {
        sender.setBorder(color: UIColor(hexString: "#e3e3e3").cgColor, cornerRadius: 4.0 * heightRatio)
    }
}


// MARK: - PostShowDisplayLogic
extension PostShowViewController: PostShowDisplayLogic {
    func displayLoadContent(fromViewModel viewModel: PostShowModels.Post.ViewModel) {
        // NOTE: Display the result from the Presenter
        if let error = viewModel.errorAPI {
            self.showAlertView(withTitle: "Error", andMessage: error.localizedDescription, needCancel: false, completion: { _ in })
        }
        
        // CoreData
        self.fetchContent()
    }
}


// MARK: - Load data from Blockchain by API
extension PostShowViewController {
    private func loadContent() {
        let contentRequestModel = PostShowModels.Post.RequestModel()
        interactor?.loadContent(withRequestModel: contentRequestModel)
    }
}


// MARK: - Fetch data from CoreData
extension PostShowViewController {
    // User Profile
    private func fetchContent() {
        var fetchRequest: NSFetchRequest<NSFetchRequestResult>
        
        let postType    =   self.router!.dataStore!.postType!
        let userName    =   (self.router!.dataStore!.post as! PostCellSupport).author
        let permlink    =   (self.router!.dataStore!.post as! PostCellSupport).permlink
        
        fetchRequest            =   NSFetchRequest<NSFetchRequestResult>(entityName: postType.caseTitle())
        fetchRequest.predicate  =   NSPredicate(format: "author == %@ AND permlink == %@", userName, permlink)
        
        do {
            if let displayedPost = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest).first as? NSManagedObject {
                self.postFeedHeaderView.display(displayedPost as! PostCellSupport)
                self.interactor?.save(displayedPost)
                self.loadViewSettings()
            }
        }
        
        catch {
            self.showAlertView(withTitle: "Error", andMessage: "Fetching Failed", needCancel: false, completion: { _ in
                Logger.log(message: "Fetching Failed", event: .error)
            })
        }
    }
}


// MARK: - UICollectionViewDataSource
extension PostShowViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of items
        guard let dataSource = (self.router?.dataStore?.post as? PostCellSupport)?.tags, dataSource.count > 0 else {
            return 0
        }
        
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell    =   collectionView.dequeueReusableCell(withReuseIdentifier: "PostShowTagCollectionViewCell", for: indexPath) as! PostShowTagCollectionViewCell
        let tag     =   (self.router!.dataStore!.post as! PostCellSupport).tags![indexPath.row]
        
        // Config cell
        cell.setup(withItem: tag, andIndexPath: indexPath)
        
        // Handlers
        cell.completionButtonTapped     =   {
            self.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
        }
        
        return cell
    }
}


// MARK: - UICollectionViewDelegate
extension PostShowViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}


// MARK: - UICollectionViewDelegateFlowLayout
extension PostShowViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6.0 * widthRatio
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6.0 * heightRatio
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tag     =   (self.router!.dataStore!.post as! PostCellSupport).tags![indexPath.row]
        let width   =   (CGFloat(tag.count) * 6.0 * widthRatio + 30.0) * widthRatio
        
        return CGSize.init(width: width, height: 30.0 * heightRatio)
    }
}
