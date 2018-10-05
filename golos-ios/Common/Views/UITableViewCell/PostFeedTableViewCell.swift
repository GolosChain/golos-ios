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
    var handlerCommentsButtonTapped: ((PostShortInfo) -> Void)?
    var handlerActiveVotesButtonTapped: ((Bool, PostShortInfo) -> Void)?

    
    // MARK: - IBOutlets
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.tune(withText:           "",
                            hexColors:          veryDarkGrayWhiteColorPickers,
                            font:               UIFont(name: "SFProDisplay-Regular", size: 14.0),
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
            
            postFeedHeaderView.handlerReblogAuthorTapped    =   { [weak self] reblogAuthorName in
                self?.handlerAuthorPostSelected!(reblogAuthorName)
            }
        }
    }
    
    @IBOutlet private weak var bottomView: UIView! {
        didSet {
            bottomView.tune()
        }
    }

    @IBOutlet private weak var activeVotesButton: UIButton! {
        didSet {
            activeVotesButton.tune(withTitle:       "",
                               hexColors:       [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                               font:            UIFont(name: "SFProDisplay-Regular", size: 10.0),
                               alignment:       .center)
        }
    }
    
    @IBOutlet private weak var commentsButton: UIButton! {
        didSet {
            commentsButton.tune(withTitle:      "",
                                hexColors:      [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                                font:           UIFont(name: "SFProDisplay-Regular", size: 10.0),
                                alignment:      .center)
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
        
        self.postFeedHeaderView.reblogIconButton.isHidden       =   true
        self.postFeedHeaderView.rebloggedAuthorButton.isHidden  =   true
        
        self.commentsButton.setTitle(nil, for: .normal)
        self.activeVotesButton.setTitle(nil, for: .normal)
        self.postFeedHeaderView.rebloggedAuthorButton.setTitle(nil, for: .normal)
    }
    
    
    // MARK: - Custom Functions
    func setCommentsCount(value: Int64) {
        if value > 0 {
            self.commentsButton.setTitle("\(value)", for: .normal)
        }
    }
    
    
    // MARK: - Actions
    @IBAction func activeVotesButtonTapped(_ sender: UIButton) {
        self.handlerActiveVotesButtonTapped!(sender.tag == 0, self.postShortInfo)
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
        
        // Display PostFeedHeaderView
        self.postFeedHeaderView.display(post: model)
        
        // TODO: - RECOMMENT IN BETA-VERSION
        // Author Post Reputation -> Int
//            let pendingPayoutValue = String(format: "%@%.2f", "gbg", model.pendingPayoutValue)
//            self.upvotesButton.setTitle(pendingPayoutValue, for: .normal)
        
        // Set Active Votes icon
        self.activeVotesButton.tag = model.currentUserVoted ? 99 : 0
        self.activeVotesButton.setTitle(model.activeVotesCount > 0 ? "\(model.activeVotesCount)" : nil, for: .normal)
        self.activeVotesButton.setImage(UIImage(named: model.currentUserVoted ? "icon-button-upvotes-selected" : "icon-button-upvotes-default"), for: .normal)
        
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
            self.postImageViewHeightConstraint.constant = 0
        }
        
        self.titleLabel.text    =   model.title
        selectionStyle          =   .none
        
        if model.children > 0 {
            self.commentsButton.setTitle("\(model.children)", for: .normal)
//            self.commentsButton.isSelected = model.currentUserVoted
            
            if self.commentsButton.isSelected {
                Logger.log(message: "Set green like icon", event: .debug)
            }
        }
        
        self.layoutIfNeeded()
    }
}
