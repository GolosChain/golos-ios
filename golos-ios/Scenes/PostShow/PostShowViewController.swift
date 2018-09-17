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
import SafariServices
import AlignedCollectionViewFlowLayout

// MARK: - Input & Output protocols
protocol PostShowDisplayLogic: class {
    func displayLoadContent(fromViewModel viewModel: PostShowModels.Post.ViewModel)
    func displayLoadContentComments(fromViewModel viewModel: PostShowModels.Post.ViewModel)
}

class PostShowViewController: GSBaseViewController {
    // MARK: - Properties
    var scrollToComment: Bool = false
    
    var commentsViews = [CommentView]() {
        didSet {
            _ = commentsViews.map( { commentView in
                // Handlers
                commentView.handlerUpvotesButtonTapped                  =   { [weak self] in
                    self?.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
                }
                
                commentView.handlerUsersButtonTapped                    =   { [weak self] in
                    self?.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
                }
                
                commentView.handlerCommentsButtonTapped                 =   { [weak self] postShortInfo in
                    self?.interactor?.save(comment: postShortInfo)
                    self?.router?.routeToPostCreateScene(withType: .createComment)
                }
                
                commentView.handlerReplyButtonTapped                    =   { [weak self] postShortInfo in
                    self?.interactor?.save(comment: postShortInfo)
                    self?.router?.routeToPostCreateScene(withType: .createCommentReply)
                }
                
                commentView.handlerShareButtonTapped                    =   { [weak self] in
                    self?.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
                }
                
                commentView.handlerAuthorProfileAddButtonTapped         =   { [weak self] in
                    self?.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
                }
                
                commentView.handlerAuthorProfileImageButtonTapped       =   { [weak self] authorName in
                    self?.router?.routeToUserProfileScene(byUserName: authorName)
                }

                commentView.handlerAuthorNameButtonTapped               =   { [weak self] authorName in
                    self?.router?.routeToUserProfileScene(byUserName: authorName)
                }
                
                // Handler Markdown
                commentView.markdownViewManager.completionErrorAlertView            =   { [weak self] errorMessage in
                    self?.showAlertView(withTitle: "Error", andMessage: errorMessage, needCancel: false, completion: { _ in })
                }

                commentView.markdownViewManager.completionCommentAuthorTapped       =   { [weak self] authorName in
                    self?.router?.routeToUserProfileScene(byUserName: authorName)
                }
                
                commentView.markdownViewManager.completionShowSafariURL             =   { [weak self] url in
                    if isNetworkAvailable {
                        let safari = SFSafariViewController(url: url)
                        self?.present(safari, animated: true, completion: nil)
                    }
                        
                    else {
                        self?.showAlertView(withTitle: "Info", andMessage: "No Internet Connection", needCancel: false, completion: { _ in })
                    }
                }
            })
        }
    }

    var interactor: PostShowBusinessLogic?
    var router: (NSObjectProtocol & PostShowRoutingLogic & PostShowDataPassing)?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var postFeedHeaderView: PostFeedHeaderView!
    @IBOutlet weak var commentsView: UIView!
    @IBOutlet weak var commentsStackView: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var markdownViewManager: MarkdownViewManager! {
        didSet {
            // Handler Markdown
            markdownViewManager.completionErrorAlertView            =   { [weak self] errorMessage in
                self?.showAlertView(withTitle: "Error", andMessage: errorMessage, needCancel: false, completion: { _ in })
            }
            
            markdownViewManager.completionCommentAuthorTapped       =   { [weak self] authorName in
                self?.router?.routeToUserProfileScene(byUserName: authorName)
            }
            
            markdownViewManager.completionShowSafariURL             =   { [weak self] url in
                if isNetworkAvailable {
                    let safari = SFSafariViewController(url: url)
                    self?.present(safari, animated: true, completion: nil)
                }
                    
                else {
                    self?.showAlertView(withTitle: "Info", andMessage: "No Internet Connection", needCancel: false, completion: { _ in })
                }
            }
        }
    }

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
                            font:               UIFont(name: "SFUIDisplay-Medium", size: 15.0),
                            alignment:          .left,
                            isMultiLines:       true)
        }
    }
    
    @IBOutlet weak var upvoteButton: UIButton! {
        didSet {
            upvoteButton.tune(withTitle:        "",
                              hexColors:        [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                              font:             UIFont(name: "SFUIDisplay-Regular", size: 10.0),
                              alignment:        .left)
            
            upvoteButton.isEnabled      =   true
        }
    }
    
    @IBOutlet weak var usersButton: UIButton! {
        didSet {
            usersButton.tune(withTitle:        "42",
                             hexColors:        [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                             font:             UIFont(name: "SFUIDisplay-Regular", size: 10.0),
                             alignment:        .left)
            
            usersButton.isEnabled       =   false
            usersButton.isHidden        =   true
        }
    }
    
    @IBOutlet weak var commentsButton: UIButton! {
        didSet {
            commentsButton.tune(withTitle:      "",
                                hexColors:      [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                                font:           UIFont(name: "SFUIDisplay-Regular", size: 10.0),
                                alignment:      .left)
            
            commentsButton.isEnabled    =   true
        }
    }
    
    @IBOutlet weak var flauntButton: UIButton! {
        didSet {
            flauntButton.tune(withTitle:        "Flaunt Verb",
                              hexColors:        [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                              font:             UIFont(name: "SFUIDisplay-Regular", size: 10.0),
                              alignment:        .left)
            
            flauntButton.isEnabled      =   true
        }
    }
    
    @IBOutlet weak var promoteButton: UIButton! {
        didSet {
            promoteButton.tune(withTitle:        "Promote Post Verb",
                               hexColors:        [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                               font:             UIFont(name: "SFUIDisplay-Medium", size: 11.0),
                               alignment:        .center)
            
            promoteButton.isEnabled     =   false
            
            promoteButton.setBorder(color: UIColor(hexString: "#6ad381").cgColor, cornerRadius: 4.0 * heightRatio)
        }
    }
    
    @IBOutlet weak var donateButton: UIButton! {
        didSet {
            donateButton.tune(withTitle:        "Donate Verb",
                               hexColors:        [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                               font:             UIFont(name: "SFUIDisplay-Medium", size: 11.0),
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
                                       font:             UIFont(name: "SFUIDisplay-Regular", size: 8.0),
                                       alignment:        .left,
                                       isMultiLines:     false)
        }
    }
    
    @IBOutlet weak var topicTitleLabel: UILabel! {
        didSet {
            topicTitleLabel.tune(withText:         "",
                                 hexColors:        darkGrayWhiteColorPickers,
                                 font:             UIFont(name: "SFUIDisplay-Regular", size: 12.0),
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
                               font:            UIFont(name: "SFUIDisplay-Regular", size: 12.0), alignment: .left,
                               isMultiLines:    false)
        }
    }
    
    @IBOutlet weak var userRecentPastLabel: UILabel! {
        didSet {
            userRecentPastLabel.tune(withText:        "Recent Past:",
                                     hexColors:       darkGrayWhiteColorPickers,
                                     font:            UIFont(name: "SFUIDisplay-Regular", size: 8.0), alignment: .left,
                                     isMultiLines:    false)
        }
    }
    
    @IBOutlet weak var userPreviouslyLabel: UILabel! {
        didSet {
            userPreviouslyLabel.tune(withText:        "Previously:",
                                     hexColors:       darkGrayWhiteColorPickers,
                                     font:            UIFont(name: "SFUIDisplay-Regular", size: 8.0), alignment: .left,
                                     isMultiLines:    false)
        }
    }
    
    @IBOutlet var subscribeButtonsCollection: [UIButton]! {
        didSet {
            _ = subscribeButtonsCollection.map({ button in
                button.tune(withTitle:         "Subscribe",
                            hexColors:         [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                            font:              UIFont(name: "SFUIDisplay-Medium", size: 10.0),
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
                                    font:               UIFont(name: "SFUIDisplay-Regular", size: 14.0),
                                    alignment:          .left,
                                    isMultiLines:       false)
        }
    }

    @IBOutlet weak var commentsCountLabel: UILabel! {
        didSet {
            commentsCountLabel.tune(withText:           "",
                                    hexColors:          grayWhiteColorPickers,
                                    font:               UIFont(name: "SFUIDisplay-Regular", size: 14.0),
                                    alignment:          .left,
                                    isMultiLines:       false)
        }
    }

    @IBOutlet weak var sortByLabel: UILabel! {
        didSet {
            sortByLabel.tune(withText:           "Sort by",
                             hexColors:          grayWhiteColorPickers,
                             font:               UIFont(name: "SFUIDisplay-Regular", size: 10.0),
                             alignment:          .left,
                             isMultiLines:       false)
        }
    }

    @IBOutlet weak var commentsSortByButton: UIButton! {
        didSet {
            commentsSortByButton.tune(withTitle:        "Action Sheet First New",
                                      hexColors:        [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                                      font:             UIFont(name: "SFUIDisplay-Regular", size: 10.0),
                                      alignment:        .center)
            
            commentsSortByButton.isEnabled  =   true
        }
    }

    @IBOutlet weak var commentsHideButton: UIButton! {
        didSet {
            commentsHideButton.tune(withTitle:        "Hide Comments Verb",
                                    hexColors:        [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                                    font:             UIFont(name: "SFUIDisplay-Medium", size: 8.0),
                                    alignment:        .center)
            
            commentsHideButton.isEnabled    =   true
            commentsHideButton.setBorder(color: UIColor(hexString: "#dbdbdb").cgColor, cornerRadius: 4.0 * heightRatio)
        }
    }
    
    // Collections
    @IBOutlet var circleImagesCollection: [UIView]! {
        didSet {
            _ = circleImagesCollection.map({ imageView in
                imageView.layer.cornerRadius = imageView.bounds.height / 2 * heightRatio
                
                if imageView.tag == 0 {
                    imageView.layer.borderWidth     =   1.0
                    imageView.layer.borderColor     =   UIColor(hexString: "#1e1e1e").cgColor
                }
            })
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
    @IBOutlet weak var commentsViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentsStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentsStackViewHeightConstraint: NSLayoutConstraint!
    
    
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
        self.postFeedHeaderView.handlerAuthorTapped         =   { [weak self] userName in
            self?.router?.routeToUserProfileScene(byUserName: userName)
        }
        
        // Load Post
        self.loadContent()
        self.loadContentComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.hideNavigationBar()
        UIApplication.shared.statusBarStyle = .default
    }
    
    
    // MARK: - Custom Functions
    private func didCommentsView(isHide: Bool) {
        if isHide {
            self.commentsViewTopConstraint.constant         =   -70.0 * heightRatio
            self.commentsStackViewTopConstraint.constant    =   -(self.commentsStackViewHeightConstraint.constant + 40.0 * heightRatio)
            self.commentsView.isHidden                      =   true
            self.commentsStackView.isHidden                 =   true
        }
        
        else {
            self.commentsCountLabel.text   =   String(format: "%i", self.commentsStackView.subviews.count)
        }
    }
    
    private func loadViewSettings() {
        if let displayedPost = self.router?.dataStore?.post as? PostCellSupport {
            self.titleLabel.text = displayedPost.title
            
            DispatchQueue.main.async {
                self.markdownViewManager.load(markdown: displayedPost.body)
            }
            
            // Load markdown content
            self.markdownViewManager.onRendered = { [weak self] height in
                self?.markdownViewHeightConstraint.constant = height
                self?.activityIndicator.stopAnimating()
                
                UIView.animate(withDuration: 0.5, animations: {
                    self?.contentView.alpha = 1.0
                })
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
                    if (self?.scrollToComment)! {
                        self?.scrollView.scrollRectToVisible(CGRect(origin: (self?.commentsView.frame.origin)!, size: CGSize(width: (self?.commentsView.frame.width)!, height: UIScreen.main.bounds.height - 64.0 * heightRatio - 48.0)), animated: true)
                    }
                })
            }
            
            // Set upvotes icon
            if let activeVotes = displayedPost.activeVotes, activeVotes.count > 0 {
                self.upvoteButton.isSelected = activeVotes.compactMap({ ($0 as? ActiveVote)?.voter == User.current!.name }).count > 0
                self.upvoteButton.setTitle("\(activeVotes.count)", for: .normal)
                
                if self.upvoteButton.isSelected {
                    self.upvoteButton.alpha = 1.0
                    Logger.log(message: "Set green upvote icon", event: .debug)
                }
            }

            // Subscribe topic
            if let firstTag = displayedPost.tags?.first {
                self.topicTitleLabel.text       =   firstTag.transliteration().uppercaseFirst
            }
            
            // Subscribe User
            self.userAvatarImageView.image      =   self.postFeedHeaderView.authorProfileImageView.image
            self.userNameLabel.text             =   self.postFeedHeaderView.authorLabel.text
            
            // User action buttons
            if displayedPost.children > 0 {
                self.commentsButton.setTitle("\(displayedPost.children)", for: .normal)
                self.commentsButton.isSelected  =   (displayedPost.activeVotes?.allObjects as! [ActiveVote]).contains(where: { $0.voter == User.current?.name ?? "" })
            }
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
        if isNetworkAvailable {
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
        
        else {
            self.showAlertView(withTitle: "Info", andMessage: "No Internet Connection", needCancel: false, completion: { _ in })
        }
    }
    
    @IBAction func upvoteButtonTapped(_ sender: UIButton) {
        self.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
    }

    @IBAction func usersButtonTapped(_ sender: UIButton) {
        self.showAlertView(withTitle: "Info", andMessage: "In development", needCancel: false, completion: { _ in })
    }

    @IBAction func commentsButtonTapped(_ sender: UIButton) {
        self.router?.routeToPostCreateScene(withType: .createComment)
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
        sender.isSelected = !sender.isSelected
       
        sender.setTitle("Hide Comments Verb".localized(), for: .normal)
        sender.setTitle("Show Comments Verb".localized(), for: .selected)
        
        self.commentsStackView.alpha = sender.isSelected ? 0.0 : 1.0
        self.commentsStackViewTopConstraint.constant = sender.isSelected ? -self.commentsStackView.bounds.height : 0.0
        
        UIView.animate(withDuration: 1.2) {
            self.commentsStackView.layoutIfNeeded()
        }
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
    
    func displayLoadContentComments(fromViewModel viewModel: PostShowModels.Post.ViewModel) {
        // NOTE: Display the result from the Presenter
        if let error = viewModel.errorAPI {
            self.showAlertView(withTitle: "Error", andMessage: error.localizedDescription, needCancel: false, completion: { _ in })
        }
        
        // CoreData
        self.fetchCommentsFirstLevel()
    }
}


// MARK: - Load data from Blockchain by API
extension PostShowViewController {
    private func loadContent() {
        DispatchQueue.main.async {
            let contentRequestModel = PostShowModels.Post.RequestModel()
            self.interactor?.loadContent(withRequestModel: contentRequestModel)
        }
    }
    
    private func loadContentComments() {
        DispatchQueue.main.async {
            let contentRepliesRequestModel = PostShowModels.Post.RequestModel()
            self.interactor?.loadContentComments(withRequestModel: contentRepliesRequestModel)
        }
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
                self.interactor?.save(post: displayedPost)
                self.loadViewSettings()
            }
        }
        
        catch {
            self.showAlertView(withTitle: "Error", andMessage: "Fetching Failed", needCancel: false, completion: { _ in
                Logger.log(message: "Fetching Failed", event: .error)
            })
        }
    }
    
    // Post Comments list
    private func nextCommentLevel(byPermlink permlink: String?, andParentLevel parentLevel: String) {
        if let commentPermlink = permlink {
            DispatchQueue.main.async {
                let comments    =   CoreDataManager.instance.readEntities(withName:                    "Comment",
                                                                          withPredicateParameters:     NSPredicate(format: "parentPermlink == %@", commentPermlink),
                                                                          andSortDescriptor:           NSSortDescriptor(key: "created", ascending: false)) as! [Comment]
                
                guard comments.count > 0 else {
                    // Remove subviews in Stack view
                    self.commentsViews.forEach({ self.commentsStackView.removeArrangedSubview($0)})
                    
                    // Sort subviews for Stack view
                    let sortedSubviews = self.commentsViews.sorted(by: { $0.level < $1.level })
                    
                    // Add subview to Stack view
                    for subview in sortedSubviews {
                        self.commentsStackView.addArrangedSubview(subview)
                    }
                    
                    // Show scene
                    UIView.animate(withDuration: 0.5) {
                        self.view.alpha = 1.0
                    }

                    // Show comments count
                    self.didCommentsView(isHide: false)
                    
                    return
                }
                
                // "00_01_02_03_04_05"
                for (tag, comment) in comments.enumerated() {
                    let commentView = CommentView.init(withComment: comment, atLevel: parentLevel + "\(tag + 1)".addFirstZero())
                    
                    // Level N
                    commentView.loadData(fromBody: comment.body, completion: { [weak self] viewHeight in
                        self?.commentsStackViewHeightConstraint.constant += viewHeight
                        self?.commentsStackView.layoutIfNeeded()
                        self?.commentsViews.append(commentView)
                        
                        // Get next Comment level
                        if commentView.level.count / 2 <= 2 {
                            self?.nextCommentLevel(byPermlink: commentView.postShortInfo.permlink ?? "XXX", andParentLevel: commentView.level)
                        }
                            
                        else {
                            self?.nextCommentLevel(byPermlink: "XXX", andParentLevel: "XXX")
                        }
                    })
                }
            }
        }
    }
    
    
    private func fetchCommentsFirstLevel() {
        if let post = self.router?.dataStore?.post as? PostCellSupport {
            DispatchQueue.main.async {
                guard let comments = CoreDataManager.instance.readEntities(withName:                    "Comment",
                                                                           withPredicateParameters:     NSPredicate(format: "parentAuthor == %@ AND parentPermlink == %@", post.author, post.permlink),
                                                                           andSortDescriptor:           NSSortDescriptor(key: "created", ascending: true)) as? [Comment] else {
                                                                            self.didCommentsView(isHide: true)
                                                                            return
                }
                
                self.commentsStackViewHeightConstraint.constant =   0.0
                var tagIndex            =   1
                
                for comment in comments {
                    let commentView     =   CommentView.init(withComment: comment, atLevel: "\(tagIndex)".addFirstZero())
                    tagIndex            +=  1
                    
                    // Level 0
                    commentView.loadData(fromBody: comment.body, completion: { [weak self] viewHeight in
                        self?.commentsStackViewHeightConstraint.constant += viewHeight
//                        self?.commentsStackView.layoutIfNeeded()
                        self?.commentsViews.append(commentView)
//                        self?.didCommentsView(isHide: false)

                        // Levels 2...n
                        self?.nextCommentLevel(byPermlink: commentView.postShortInfo.permlink ?? "XXX", andParentLevel: commentView.level)
                    })
                }
            }
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
        return UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 12.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6.0 * widthRatio
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6.0 * heightRatio
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tag     =   (self.router!.dataStore!.post as! PostCellSupport).tags![indexPath.row]
        let width   =   (CGFloat(tag.count) * 7.0 + 30.0) * widthRatio
        
        return CGSize.init(width: width, height: 30.0 * heightRatio)
    }
}
