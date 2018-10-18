//
//  CommentTableViewCell.swift
//  Golos
//
//  Created by msm72 on 10/15/18.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift

class CommentTableViewCell: UITableViewCell, HandlersCellSupport, PostCellActiveVoteSupport {
    // MARK: - Properties
    var created: Date!
    var treeIndex: String!
    var postShortInfo: PostShortInfo!
    
    // Handlers
    var handlerUsersButtonTapped: (() -> Void)?
    var handlerAuthorNameButtonTapped: ((String) -> Void)?
    var handlerAuthorProfileAddButtonTapped: (() -> Void)?
    var handlerReplyButtonTapped: ((PostShortInfo) -> Void)?
    var handlerAuthorProfileImageButtonTapped: ((String) -> Void)?

    // HandlersCellSupport
    var handlerShareButtonTapped: (() -> Void)?
    var handlerCommentsButtonTapped: ((PostShortInfo) -> Void)?
    var handlerActiveVoteButtonTapped: ((Bool, PostShortInfo) -> Void)?

    
    // MARK: - IBOutlets
    @IBOutlet weak var activeVoteButton: UIButton!
    @IBOutlet var markdownViewManager: MarkdownViewManager!
    @IBOutlet weak var authorProfileImageView: UIImageView!
    
    @IBOutlet weak var activeVoteActivityIndicator: UIActivityIndicatorView! {
        didSet {
            self.activeVoteActivityIndicator.stopAnimating()
        }
    }
    
    @IBOutlet weak var commentsButton: UIButton! {
        didSet {
            self.commentsButton.tune(withTitle:         "",
                                     hexColors:         [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                                     font:              UIFont(name: "SFProDisplay-Medium", size: 10.0),
                                     alignment:         .left)
            
            self.contentView.tune()
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
                                  hexColors:    [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
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
    
    @IBOutlet weak var replyButton: UIButton! {
        didSet {
            replyButton.tune(withTitle:         "Reply Verb",
                             hexColors:         [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                             font:              UIFont(name: "SFProDisplay-Medium", size: 10.0),
                             alignment:         .left)
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
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    
    
    // MARK: - Custom Functions
    func loadData(fromBody body: String, completion: @escaping (CGFloat) -> Void) {
        // Load markdown content
//        DispatchQueue.main.sync {
            self.markdownViewManager.load(markdown: body)
            
            self.markdownViewManager.onRendered = { height in
                let viewHeight = height + 74.0
                
                self.markdownViewHeightConstraint.constant = height
                self.markdownViewManager.layoutIfNeeded()
//                self.frame = CGRect(origin: .zero, size: CGSize(width: self.frame.width, height: viewHeight))
//                self.layoutIfNeeded()

                UIView.animate(withDuration: 0.5, animations: {
                    self.contentView.alpha = 1.0
                    completion(viewHeight)
                })
            }
//        }
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
    @IBAction func activeVoteButtonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        self.handlerActiveVoteButtonTapped!(sender.tag == 0, self.postShortInfo)
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


// MARK: - ConfigureCell implementation
extension CommentTableViewCell: ConfigureCell {
    func setup(withItem item: Any?, andIndexPath indexPath: IndexPath) {
        guard let comment = item as? Comment else {
            return
        }

        self.postShortInfo      =   PostShortInfo(id:               comment.id,
                                                  title:            comment.body.substring(withCharactersCount: 120),
                                                  author:           comment.author,
                                                  permlink:         comment.permlink,
                                                  parentTag:        comment.tags?.first,
                                                  indexPath:        indexPath,
                                                  parentAuthor:     comment.parentAuthor,
                                                  parentPermlink:   comment.parentPermlink)
        
        self.created            =   comment.created
        self.treeIndex          =   comment.treeIndex
        self.timeLabel.text     =   comment.created.convertToDaysAgo()
        
        // Set Active Votes icon
        self.activeVoteButton.isEnabled = true
        self.activeVoteActivityIndicator.stopAnimating()
        
        self.activeVoteButton.tag = comment.currentUserVoted ? 99 : 0
        self.activeVoteButton.setTitle(comment.netVotes > 0 ? "\(comment.netVotes)" : nil, for: .normal)
        self.activeVoteButton.setImage(UIImage(named: comment.currentUserVoted ? "icon-button-upvotes-selected" : "icon-button-upvotes-default"), for: .normal)
        
        if comment.netVotes > 0 {
            self.commentsButton.setTitle("\(comment.netVotes)", for: .normal)
            self.commentsButton.isSelected = comment.currentUserVoted
        }
        
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
    }
}
