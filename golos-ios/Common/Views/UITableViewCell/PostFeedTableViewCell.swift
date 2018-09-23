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

class PostFeedTableViewCell: UITableViewCell, HandlersCellSupport {
    // MARK: - Properties
    var postShortInfo: PostShortInfo!

    // Handlers
    var handlerAuthorPostSelected: ((String) -> Void)?

    // HandlersCellSupport
    var handlerShareButtonTapped: (() -> Void)?
    var handlerUpvotesButtonTapped: (() -> Void)?
    var handlerCommentsButtonTapped: ((PostShortInfo) -> Void)?

    
    // MARK: - IBOutlets
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.tune(withText:           "",
                            hexColors:          veryDarkGrayWhiteColorPickers,
                            font:               UIFont(name: "SFUIDisplay-Regular", size: 14.0),
                            alignment:          .left,
                            isMultiLines:       true)
        }
    }

    @IBOutlet weak var postImageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var postFeedHeaderView: PostFeedHeaderView! {
        didSet {
            postFeedHeaderView.tune()
            
            // Handlers
            postFeedHeaderView.handlerAuthorTapped          =   { [weak self] userName in
                self?.handlerAuthorPostSelected!(userName)
            }
            
            postFeedHeaderView.handlerReblogAuthorTapped    =   {
                
            }
        }
    }
    
    @IBOutlet private weak var bottomView: UIView! {
        didSet {
            bottomView.tune()
        }
    }

    @IBOutlet private weak var upvotesButton: UIButton! {
        didSet {
            upvotesButton.tune(withTitle:       "",
                               hexColors:       [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                               font:            UIFont(name: "SFUIDisplay-Regular", size: 10.0),
                               alignment:       .center)
        }
    }
    
    @IBOutlet private weak var commentsButton: UIButton! {
        didSet {
            commentsButton.tune(withTitle:      "",
                                hexColors:      [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                                font:           UIFont(name: "SFUIDisplay-Regular", size: 10.0),
                                alignment:      .center)
        }
    }
    
    @IBOutlet var widthsCollection: [NSLayoutConstraint]! {
        didSet {
            _ = widthsCollection.map({ $0.constant *= widthRatio })
        }
    }
    
    @IBOutlet var heightsCollection: [NSLayoutConstraint]! {
        didSet {
            _ = heightsCollection.map({ $0.constant *= heightRatio })
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
        self.postImageView.image                                =   nil // UIImage(named: "image-user-cover-placeholder")
        self.postImageViewHeightConstraint.constant             =   180.0 * heightRatio
        
        self.postFeedHeaderView.reblogAuthorLabel.text          =   nil
        self.postFeedHeaderView.reblogAuthorLabel.isHidden      =   true
        self.postFeedHeaderView.reblogIconImageView.isHidden    =   true
        
        self.commentsButton.setTitle(nil, for: .normal)
    }
    
    
    // MARK: - Actions
    @IBAction func upvotesButtonTapped(_ sender: UIButton) {
        self.handlerUpvotesButtonTapped!()
    }
    
    @IBAction func commentsButtonTapped(_ sender: UIButton) {
        self.handlerCommentsButtonTapped!(self.postShortInfo)
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        self.handlerShareButtonTapped!()
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
        
        self.postShortInfo = PostShortInfo(indexPath: indexPath)
        
        // Set User info
        if let user = User.fetch(byName: model.author) {
            self.postFeedHeaderView.authorLabel.text            =   user.name
            
            // User Reputation -> Int
            self.postFeedHeaderView.authorReputationLabel.text  =   String(format: "%i", user.reputation.convertWithLogarithm10())
            
            
            // TODO: - RECOMMENT IN BETA-VERSION
            // Author Post Reputation -> Int
//            let pendingPayoutValue = String(format: "%@%.2f", "gbg", model.pendingPayoutValue)
//            self.upvotesButton.setTitle(pendingPayoutValue, for: .normal)

            // Set upvotes icon
            if model.activeVotesCount > 0 {
                self.upvotesButton.isSelected = model.currentUserVoted
            }

            // Load User author profile image
            if let userProfileImageURL = user.profileImageURL {
                self.postFeedHeaderView.authorProfileImageView.uploadImage(byStringPath:    userProfileImageURL,
                                                                           imageType:       .userProfileImage,
                                                                           size:            CGSize(width: 30.0 * widthRatio, height: 30.0 * widthRatio),
                                                                           tags:            nil,
                                                                           createdDate:     user.created.convert(toDateFormat: .expirationDateType),
                                                                           fromItem:        (user as CachedImageFrom).fromItem)
            }
        }

        // Load model user cover image
        if let coverImageURL = model.coverImageURL, !coverImageURL.isEmpty {
            self.postImageView.uploadImage(byStringPath:    coverImageURL,
                                           imageType:       .userCoverImage,
                                           size:            CGSize(width: UIScreen.main.bounds.width, height: 180.0 * heightRatio),
                                           tags:            model.tags,
                                           createdDate:     model.created,
                                           fromItem:        (model as! CachedImageFrom).fromItem)
        }

        // Hide post image
        else {
            self.postImageViewHeightConstraint.constant     =   0
        }

        self.titleLabel.text                                =   model.title
        self.postFeedHeaderView.authorLabel.text            =   model.author
        self.postFeedHeaderView.categoryLabel.text          =   model.category.transliteration()

        selectionStyle                                      =   .none

        if model.children > 0 {
            self.commentsButton.setTitle("\(model.children)", for: .normal)
//            self.commentsButton.isSelected = model.currentUserVoted
            
            if self.commentsButton.isSelected {
                Logger.log(message: "Set green like icon", event: .debug)
            }
        }
        
        self.layoutIfNeeded()
        
        // Set reblogged user info (default isHidden = true)
        if let rebloggedBy = model.rebloggedBy, rebloggedBy.count > 0 {
            self.postFeedHeaderView.reblogAuthorLabel.text          =   rebloggedBy.first ?? ""
            self.postFeedHeaderView.reblogAuthorLabel.isHidden      =   false
            self.postFeedHeaderView.reblogIconImageView.isHidden    =   false
        }
    }
}
