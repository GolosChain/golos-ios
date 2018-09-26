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
import MarkdownView

class CommentView: UIView, HandlersCellSupport {
    // MARK: - Properties
    var level: String = ""
    var created: Date!
    var postShortInfo: PostShortInfo!

    
    // Handlers
    var handlerUsersButtonTapped: (() -> Void)?
    var handlerAuthorNameButtonTapped: ((String) -> Void)?
    var handlerAuthorProfileAddButtonTapped: (() -> Void)?
    var handlerReplyButtonTapped: ((PostShortInfo) -> Void)?
    var handlerAuthorProfileImageButtonTapped: ((String) -> Void)?

    // HandlersCellSupport
    var handlerShareButtonTapped: (() -> Void)?
    var handlerUpvotesButtonTapped: (() -> Void)?
    var handlerCommentsButtonTapped: ((PostShortInfo) -> Void)?

    
    // MARK: - IBOutlets
    @IBOutlet var view: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var upvotesButton: UIButton!
    @IBOutlet weak var authorProfileImageButton: UIButton!
    @IBOutlet weak var markdownViewManager: MarkdownViewManager!
    
    @IBOutlet weak var commentsButton: UIButton! {
        didSet {
            self.commentsButton.tune(withTitle:         "",
                                     hexColors:         [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                                     font:              UIFont(name: "SFUIDisplay-Medium", size: 10.0),
                                     alignment:         .left)
        }
    }

    @IBOutlet var circleViewsCollection: [UIView]! {
        didSet {
            _ = circleViewsCollection.map({ $0.layer.cornerRadius = $0.bounds.width / 2 * widthRatio })
        }
    }
    
    @IBOutlet weak var authorProfileAddButton: UIButton! {
        didSet {
            authorProfileAddButton.layer.cornerRadius       =   18.0 * heightRatio / 2
        }
    }
    
    @IBOutlet weak var authorNameButton: UIButton! {
        didSet {
            authorNameButton.tune(withTitle:    "",
                                  hexColors:    [darkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                                  font:         UIFont(name: "SFUIDisplay-Regular", size: 10.0),
                                  alignment:    .left)
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.tune(withText:            "",
                           hexColors:           darkGrayWhiteColorPickers,
                           font:                UIFont(name: "SFUIDisplay-Regular", size: 10.0),
                           alignment:           .left,
                           isMultiLines:        false)
        }
    }
    
    
    
    @IBOutlet weak var replyButton: UIButton! {
        didSet {
            replyButton.tune(withTitle:         "Reply Verb",
                             hexColors:         [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                             font:              UIFont(name: "SFUIDisplay-Medium", size: 10.0),
                             alignment:         .left)
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
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var markdownViewHeightConstraint: NSLayoutConstraint!

    
    // MARK: - Class Initialization
    init(withComment comment: Comment, atLevel level: String) {
        super.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: 351.0 * widthRatio, height: 85.0))) // * heightRatio)))
        
        createFromXIB()
        
        self.level              =   level
        
        self.postShortInfo      =   PostShortInfo(id:               comment.id,
                                                  title:            comment.body.substring(withCharactersCount: 120),
                                                  author:           comment.author,
                                                  permlink:         comment.permlink,
                                                  parentTag:        comment.tags?.first,
                                                  indexPath:        nil,
                                                  parentAuthor:     comment.parentAuthor,
                                                  parentPermlink:   comment.parentPermlink)

        self.created            =   comment.created
        self.timeLabel.text     =   comment.created.convertToDaysAgo()
        
        if comment.activeVotesCount > 0 {
            self.commentsButton.setTitle("\(comment.activeVotesCount)", for: .normal)
            self.commentsButton.isSelected = comment.currentUserVoted
        }
        
        // Avatar
        self.authorNameButton.setTitle(comment.author, for: .normal)
        
        // Load author profile image
        RestAPIManager.loadUsersInfo(byNames: [comment.author], completion: { [weak self] errorAPI in
            if errorAPI == nil, let author = User.fetch(byName: comment.author) {
                if let authorProfileImageURL = author.profileImageURL {
                    self?.authorProfileImageButton.uploadImage(byStringPath:     authorProfileImageURL,
                                                               size:             CGSize(width: 40.0 * widthRatio, height: 40.0 * widthRatio),
                                                               createdDate:      author.created.convert(toDateFormat: .expirationDateType),
                                                               fromItem:         (author as CachedImageFrom).fromItem)
                }
            }
        })
        
        // Set cell level
        self.leadingConstraint.constant = CGFloat(self.level.count - 2) > 0 ? 52.0 * widthRatio : 0.0
//        self.leadingConstraint.constant = 52.0 * widthRatio * CGFloat(self.level.count - 2) / 2
        self.markdownViewManager.layoutIfNeeded()
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
    }
    
    func loadData(fromBody body: String, completion: @escaping (CGFloat) -> Void) {
        // Load markdown content
        DispatchQueue.main.async {
            self.markdownViewManager.load(markdown: body)
        }

        self.markdownViewManager.onRendered = { [weak self] height in
            let viewHeight      =   height + 85.0 //* heightRatio
            
            self?.markdownViewHeightConstraint.constant = height
            self?.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.5, animations: {
                self?.contentView.alpha = 1.0
                completion(viewHeight)
            })
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 375.0 * widthRatio, height: 85.0) // * heightRatio)
    }

    func localizeTitles() {
        self.timeLabel.text = self.created.convertToDaysAgo()
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
    @IBAction func upvotesButtonTapped(_ sender: UIButton) {
        self.handlerUpvotesButtonTapped!()
    }
    
    @IBAction func usersButtonTapped(_ sender: UIButton) {
        self.handlerUsersButtonTapped!()
    }
    
    @IBAction func commentsButtonTapped(_ sender: UIButton) {
        self.handlerCommentsButtonTapped!(self.postShortInfo)
    }
    
    @IBAction func replyButtonTapped(_ sender: UIButton) {
        self.handlerReplyButtonTapped!(self.postShortInfo)
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        self.handlerShareButtonTapped!()
    }
}
