//
//  PostFeedTableViewCell.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 22/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import CoreData
import GoloSwift

class PostFeedTableViewCell: UITableViewCell, HandlersCellSupport, PostCellLikeSupport {
    // MARK: - Properties
    var postShortInfo: PostShortInfo!

    // Handlers
    var handlerAuthorPostSelected: ((String) -> Void)?

    // HandlersCellSupport
    var handlerRepostButtonTapped: (() -> Void)?
    var handlerCommentsButtonTapped: ((PostShortInfo) -> Void)?
    var handlerLikeButtonTapped: ((Bool, PostShortInfo) -> Void)?
    var handlerDislikeButtonTapped: ((Bool, PostShortInfo) -> Void)?
    var handlerLikeCountButtonTapped: ((PostShortInfo) -> Void)?
    var handlerDislikeCountButtonTapped: ((PostShortInfo) -> Void)?

    
    // MARK: - IBOutlets
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postImageViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.tune(withText:           "",
                            hexColors:          veryDarkGrayWhiteColorPickers,
                            font:               UIFont(name: "SFProDisplay-Regular", size: 14.0),
                            alignment:          .left,
                            isMultiLines:       true)
        }
    }
    
    @IBOutlet private weak var postFeedHeaderView: PostFeedHeaderView! {
        didSet {
            postFeedHeaderView.tune()
            
            // Handlers
            postFeedHeaderView.handlerAuthorTapped          =   { [weak self] userName in
                self?.handlerAuthorPostSelected!(userName)
            }
            
            postFeedHeaderView.handlerReblogAuthorTapped    =   { [weak self] reblogAuthorName in
                self?.handlerAuthorPostSelected!(reblogAuthorName)
            }
        }
    }
    
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

    @IBOutlet weak var repostButton: UIButton! {
        didSet {
            repostButton.tune(withTitle:        "    ",
                              hexColors:        [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                              font:             UIFont(name: "SFProDisplay-Regular", size: 12.0),
                              alignment:        .left)
            
            repostButton.isEnabled = false
        }
    }
    
    @IBOutlet weak var commentsButton: UIButton! {
        didSet {
            commentsButton.tune(withTitle:      "    ",
                                hexColors:      [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                                font:           UIFont(name: "SFProDisplay-Regular", size: 12.0),
                                alignment:      .left)
            
            commentsButton.isEnabled = true
        }
    }
    
    @IBOutlet var widthsCollection: [NSLayoutConstraint]! {
        didSet {
            self.widthsCollection.forEach({ $0.constant *= widthRatio })
        }
    }
    
    @IBOutlet var heightsCollection: [NSLayoutConstraint]! {
        didSet {
            self.heightsCollection.forEach({ $0.constant *= heightRatio })
        }
    }
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }


    // MARK: - Class Functions
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.postFeedHeaderView.authorProfileImageView.image    =   UIImage(named: "icon-user-profile-image-placeholder")

        self.titleLabel.text                                    =   nil
        self.postImageView.image                                =   nil
        self.postImageViewHeightConstraint.constant             =   180.0 * heightRatio
        
        self.likeCountButton.setTitle(nil, for: .normal)
        self.commentsButton.setTitle("    ", for: .normal)
        self.dislikeCountButton.setTitle(nil, for: .normal)
    }
    
    
    // MARK: - Custom Functions
    func setCommentsCount(value: Int64) {
        if value > 0 {
            self.commentsButton.setTitle("\(value)", for: .normal)
        }
    }
    
    
    // MARK: - Actions
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        self.handlerLikeButtonTapped!(sender.tag == 0, self.postShortInfo)
    }
    
    @IBAction func likeCountButtonTapped(_ sender: UIButton) {
        if let countText = sender.titleLabel?.text, let countInt = Int(countText), countInt > 0 {
            self.handlerLikeCountButtonTapped!(self.postShortInfo)
        }
    }

    @IBAction func dislikeButtonTapped(_ sender: UIButton) {
        self.handlerDislikeButtonTapped!(sender.tag == 0, self.postShortInfo)
    }
    
    @IBAction func dislikeCountButtonTapped(_ sender: UIButton) {
        if let countText = sender.titleLabel?.text, let countInt = Int(countText), countInt > 0 {
            self.handlerDislikeCountButtonTapped!(self.postShortInfo)
        }
    }

    @IBAction func commentsButtonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        
        self.handlerCommentsButtonTapped!(self.postShortInfo)
        
        // Stop spinner
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            sender.isEnabled = true
        }
    }
    
    @IBAction func repostButtonTapped(_ sender: UIButton) {
    
    }
        
    
    // MARK: - Reuse identifier
    override var reuseIdentifier: String? {
        return PostFeedTableViewCell.reuseIdentifier
    }
    
    class var reuseIdentifier: String? {
        return String(describing: self)
    }
}


// MARK: - ConfigureCell implementation
extension PostFeedTableViewCell: ConfigureCell {
    func setup(withItem item: Any?, andIndexPath indexPath: IndexPath) {
        guard let model = item as? PostCellSupport else {
            return
        }
        
        self.postShortInfo              =   PostShortInfo(indexPath: indexPath)
        self.likeButton.isEnabled       =   true
        self.dislikeButton.isEnabled    =   true

        self.likeActivityIndicator.stopAnimating()

        // Display PostFeedHeaderView
        self.postFeedHeaderView.display(post: model)
        
        // TODO: - RECOMMENT IN BETA-VERSION
        // Author Post Reputation -> Int
//            let pendingPayoutValue = String(format: "%@%.2f", "gbg", model.pendingPayoutValue)
//            self.upvotesButton.setTitle(pendingPayoutValue, for: .normal)
        

        // Load model user cover image
        if let coverImageURL = model.coverImageURL, !coverImageURL.isEmpty {
            self.postImageView.uploadImage(byStringPath:    coverImageURL,
                                           imageType:       .userCoverImage,
                                           size:            CGSize(width: UIScreen.main.bounds.width, height: 180.0 * heightRatio),
                                           tags:            model.tags,
                                           createdDate:     model.created,
                                           fromItem:        (model as! CachedImageFrom).fromItem,
                                           completion:      { [weak self] sidesAspectRatio in
                                            if sidesAspectRatio >= 1.0 {
                                                DispatchQueue.main.async(execute: {
                                                    self?.postImageViewHeightConstraint.constant = UIScreen.main.bounds.width * sidesAspectRatio
                                                    self?.layoutIfNeeded()
                                                })
                                            }
            })
        }
            
        // Hide post image
        else {
            self.postImageViewHeightConstraint.constant = 0
        }
        
        self.titleLabel.text    =   model.title
        selectionStyle          =   .none
        
        // Like icon
        self.likeButton.tag = model.currentUserLiked ? 99 : 0
        self.likeCountButton.setTitle(model.likeCount > 0 ? "\(model.likeCount)" : nil, for: .normal)
        self.likeButton.setImage(UIImage(named: model.currentUserLiked ? "icon-button-post-like-selected" : "icon-button-post-like-normal"), for: .normal)
        
        // Dislike icon
        self.dislikeButton.tag = model.currentUserDisliked ? 99 : 0
        self.dislikeCountButton.setTitle(model.dislikeCount > 0 ? "\(model.dislikeCount)" : nil, for: .normal)
        self.dislikeButton.setImage(UIImage(named: model.currentUserDisliked ? "icon-button-post-dislike-selected" : "icon-button-post-dislike-normal"), for: .normal)
        
        // Comments icon
        self.commentsButton.setTitle(model.children > 0 ? "\(model.children)" : "    ", for: .normal)
        self.commentsButton.setImage(UIImage(named: model.currentUserCommented ? "icon-button-post-comments-selected" : "icon-button-post-comments-normal"), for: .normal)
        
        self.layoutIfNeeded()
    }
}
