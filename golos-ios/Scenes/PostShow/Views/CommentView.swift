//
//  CommentView.swift
//  Golos
//
//  Created by msm72 on 10.08.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import CoreData
import GoloSwift

class CommentView: UIView, HandlersCellSupport {
    // MARK: - Properties
    var treeIndex: Int = 0
    var created: Date!
    var postShortInfo: PostShortInfo!

    // Handlers
    var handlerUsersButtonTapped: (() -> Void)?
    var handlerAuthorNameButtonTapped: ((String) -> Void)?
    var handlerAuthorProfileAddButtonTapped: (() -> Void)?
    var handlerReplyButtonTapped: ((PostShortInfo) -> Void)?
    var handlerAuthorProfileImageButtonTapped: ((String) -> Void)?

    // HandlersCellSupport
    var handlerLikeButtonTapped: ((Bool, PostShortInfo) -> Void)?
    var handlerRepostButtonTapped: (() -> Void)?
    var handlerDislikeButtonTapped: ((Bool, PostShortInfo) -> Void)?
    var handlerCommentsButtonTapped: ((PostShortInfo) -> Void)?


    // MARK: - IBOutlets
    @IBOutlet var view: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var markdownViewManager: MarkdownViewManager!
    @IBOutlet weak var authorProfileImageView: UIImageView!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var likeActivityIndicator: UIActivityIndicatorView! {
        didSet {
            self.likeActivityIndicator.stopAnimating()
        }
    }
    
    @IBOutlet weak var dislikeActivityIndicator: UIActivityIndicatorView! {
        didSet {
            self.dislikeActivityIndicator.stopAnimating()
        }
    }
    
    @IBOutlet weak var likeButton: UIButton! {
        didSet {
            likeButton.isEnabled = true
        }
    }
    
    @IBOutlet weak var likeCountButton: UIButton! {
        didSet {
            likeCountButton.tune(withTitle:     "",
                                 hexColors:     [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                                 font:          UIFont(name: "SFProDisplay-Regular", size: 12.0),
                                 alignment:     .left)
            
            likeCountButton.isEnabled = true
        }
    }

    @IBOutlet weak var dislikeButton: UIButton! {
        didSet {
            dislikeButton.isEnabled = true
        }
    }

    @IBOutlet weak var dislikeCountButton: UIButton! {
        didSet {
            dislikeCountButton.tune(withTitle:      "",
                                    hexColors:      [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                                    font:           UIFont(name: "SFProDisplay-Regular", size: 12.0),
                                    alignment:      .center)
            
            dislikeCountButton.isEnabled = true
        }
    }

    @IBOutlet weak var replyButton: UIButton! {
        didSet {
            replyButton.tune(withTitle:         "Reply Verb".localized(),
                             hexColors:         [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                             font:              UIFont(name: "SFProDisplay-Medium", size: 12.0),
                             alignment:         .center)
        }
    }
    
    
    @IBOutlet var circleViewsCollection: [UIView]! {
        didSet {
            self.circleViewsCollection.forEach({ $0.layer.cornerRadius = $0.bounds.width / 2 * widthRatio })
        }
    }
    
    @IBOutlet weak var authorProfileAddButton: UIButton! {
        didSet {
            authorProfileAddButton.layer.cornerRadius = 18.0 * heightRatio / 2
        }
    }
    
    @IBOutlet weak var authorNameButton: UIButton! {
        didSet {
            authorNameButton.tune(withTitle:    "",
                                  hexColors:    [darkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                                  font:         UIFont(name: "SFProDisplay-Regular", size: 10.0),
                                  alignment:    .left)
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.tune(withText:            "",
                           hexColors:           darkGrayWhiteColorPickers,
                           font:                UIFont(name: "SFProDisplay-Regular", size: 10.0),
                           alignment:           .left,
                           isMultiLines:        false)
        }
    }
    
    @IBOutlet var heightsCollection: [NSLayoutConstraint]! {
        didSet {
            self.heightsCollection.forEach({ $0.constant *= heightRatio })
        }
    }
    
    @IBOutlet var widthsCollection: [NSLayoutConstraint]! {
        didSet {
            self.widthsCollection.forEach({ $0.constant *= widthRatio })
        }
    }

    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var markdownViewHeightConstraint: NSLayoutConstraint!

    
    // MARK: - Class Initialization
    init(withComment comment: Comment, forRow row: Int) {
        super.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: 351.0 * widthRatio, height: 79.0)))
        
        createFromXIB()
        
        self.setupUI(withComment: comment, forRow: row)
    }
    
    func setupUI(withComment comment: Comment, forRow row: Int) {
        self.postShortInfo = PostShortInfo(id:               comment.id,
                                           title:            comment.body.substring(withCharactersCount: 120),
                                           author:           comment.author,
                                           permlink:         comment.permlink,
                                           parentTag:        comment.tags?.first,
                                           indexPath:        IndexPath(row: row, section: 0),
                                           parentAuthor:     comment.parentAuthor,
                                           parentPermlink:   comment.parentPermlink)
        
        self.created    =   comment.created
        self.treeIndex  =   row
        
        // Like icon
        self.likeButton.isEnabled       =   true
        self.dislikeButton.isEnabled    =   true
        
        self.likeActivityIndicator.stopAnimating()
        self.dislikeActivityIndicator.stopAnimating()

        self.likeButton.tag = comment.currentUserLiked ? 99 : 0
        self.likeCountButton.setTitle(comment.likeCount > 0 ? "\(comment.likeCount)" : nil, for: .normal)
        self.likeButton.setImage(UIImage(named: comment.currentUserLiked ? "icon-button-post-like-selected" : "icon-button-post-like-normal"), for: .normal)
        
        // Dislike icon
        self.dislikeButton.tag = comment.currentUserDisliked ? 99 : 0
        self.dislikeCountButton.setTitle(comment.dislikeCount > 0 ? "\(comment.dislikeCount)" : nil, for: .normal)
        self.dislikeButton.setImage(comment.currentUserDisliked ? UIImage(named: "icon-button-post-dislike-selected") : UIImage(named: "icon-button-post-dislike-normal"), for: .normal)

        // Avatar
        self.authorNameButton.setTitle(comment.author, for: .normal)
        
        // Load author profile image
        RestAPIManager.loadUsersInfo(byNickNames: [comment.author], completion: { [weak self] errorAPI in
            if errorAPI == nil, let author = User.fetch(byNickName: comment.author) {
                if let authorProfileImageURL = author.profileImageURL {
                    self?.authorProfileImageView.uploadImage(byStringPath:  authorProfileImageURL,
                                                             imageType:     ImageType.userProfileImage,
                                                             size:          CGSize(width: 40.0, height: 40.0),
                                                             tags:          nil,
                                                             createdDate:   author.created.convert(toDateFormat: .expirationDateType),
                                                             fromItem:      (author as CachedImageFrom).fromItem,
                                                             completion:    { _ in })
                }
            }
        })
        
        // Set cell level
        self.leadingConstraint.constant = (comment.treeLevel == 0 ? 2.0 : 52.0) * widthRatio
        self.markdownViewManager.layoutIfNeeded()
        self.layoutIfNeeded()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createFromXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        createFromXIB()
    }
    
    deinit {
        Logger.log(message: "Success", event: .severe)
    }

    
    // MARK: - Class Functions
    func createFromXIB() {
        UINib(nibName: String(describing: CommentView.self), bundle: Bundle(for: CommentView.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = frame
        
        self.view.tune()
        self.contentView.tune()
    }
    
    func loadData(fromBody body: String, completion: @escaping (CGFloat) -> Void) {
        // Load markdown content
        self.markdownViewManager.load(markdown: Parser.repair(body: body))

        self.markdownViewManager.onRendered = { height in
            completion(height)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 375.0 * widthRatio, height: 79.0)
    }

    func localizeTitles() {
        self.timeLabel.text = self.created.convertToTimeAgo()
        self.replyButton.setTitle("Reply Verb".localized(), for: .normal)
    }
    
    
    // MARK: - Actions
    @IBAction func authorProfileImageButtonTapped(_ sender: UIButton) {
        self.handlerAuthorProfileImageButtonTapped!(self.authorNameButton.titleLabel?.text ?? "XXX")
    }
    
    @IBAction func authorProfileAddButtonTapped(_ sender: UIButton) {
        self.handlerAuthorProfileAddButtonTapped!()
    }
    
    @IBAction func authorNameButtonTapped(_ sender: UIButton) {
        self.handlerAuthorNameButtonTapped!(sender.titleLabel?.text ?? "XXX")
    }
    
    // Action buttons
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        self.handlerLikeButtonTapped!(sender.tag == 0, self.postShortInfo)
    }

    @IBAction func likeCountButtonTapped(_ sender: UIButton) {
        
    }

    @IBAction func dislikeButtonTapped(_ sender: UIButton) {
        self.handlerDislikeButtonTapped!(sender.tag == 0, self.postShortInfo)
    }

    @IBAction func dislikeCountButtonTapped(_ sender: UIButton) {
        
    }

    @IBAction func replyButtonTapped(_ sender: UIButton) {
        self.handlerReplyButtonTapped!(self.postShortInfo)
    }

    @IBAction func shareButtonTapped(_ sender: UIButton) {

    }
}
