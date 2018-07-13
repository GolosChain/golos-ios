//
//  FeedArticleTableViewCell.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 22/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift

class FeedArticleTableViewCell: UITableViewCell {
    // MARK: - Properties
    let imageLoader = GSImageLoader()
    let gradientLayer = CAGradientLayer()
   
    private static let bodyFont = Fonts.shared.regular(with: 13.0)
    private static let bodyEdgesOffset: CGFloat = 12.0

    private var pictureURL: String = ""
    private var authorPictureURL: String = ""

    static let minimizedHeight: CGFloat = 180
    
    // Handlers
    var handlerShareButtonTapped: (() -> Void)?
    var handlerUpvotesButtonTapped: (() -> Void)?
    var handlerCommentsButtonTapped: (() -> Void)?


    // MARK: - IBOutlets
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.tune(withText:       "",
                            hexColors:      veryDarkGrayWhiteColorPickers,
                            font:           UIFont(name: "SFUIDisplay-Regular", size: 14.0 * widthRatio),
                            alignment:      .left,
                            isMultiLines:   true)
        }
    }

    @IBOutlet weak var postImageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var articleHeaderView: ArticleHeaderView! {
        didSet {
            articleHeaderView.tune()
            
            // Handlers
            articleHeaderView.handlerAuthorTapped           =   {
                
            }
            
            articleHeaderView.handlerReblogAuthorTapped     =   {
                
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
                               hexColors:       veryDarkGrayWhiteColorPickers,
                               font:            UIFont(name: "SFUIDisplay-Regular", size: 10.0 * widthRatio),
                               alignment:       .center)
        }
    }
    
    @IBOutlet private weak var commentsButton: UIButton! {
        didSet {
            commentsButton.tune(withTitle:      "",
                                hexColors:      veryDarkGrayWhiteColorPickers,
                                font:           UIFont(name: "SFUIDisplay-Regular", size: 10.0 * widthRatio),
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
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.pictureURL                                         =   ""
        self.authorPictureURL                                   =   ""
        self.articleHeaderView.authorProfileImageView.image     =   UIImage(named: "icon-user-profile-image-placeholder")
        
        self.titleLabel.text                                    =   nil
        self.postImageView.image                                =   nil
        self.postImageViewHeightConstraint.constant             =   180.0 * heightRatio
    }
    
    
    // MARK: - Actions
    @IBAction func upvotesButtonTapped(_ sender: UIButton) {
        self.handlerUpvotesButtonTapped!()
    }
    
    @IBAction func commentsButtonTapped(_ sender: UIButton) {
        self.handlerCommentsButtonTapped!()
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        self.handlerShareButtonTapped!()
    }
    
    
    // MARK: - Reuse identifier
    override var reuseIdentifier: String? {
        return FeedArticleTableViewCell.reuseIdentifier
    }
    
    class var reuseIdentifier: String? {
        return String(describing: self)
    }
}


// MARK: - ConfigureCell implementation
extension FeedArticleTableViewCell: ConfigureCell {
    func setup(withItem item: Any?, andIndexPath indexPath: IndexPath) {
        guard let lenta = item as? Lenta else {
            return
        }
        
        // Get user info
        if let user = User.fetch(byName: lenta.author) {
            self.articleHeaderView.authorLabel.text             =   user.name
            
            // Reputation -> Int
            self.articleHeaderView.authorReputationLabel.text   =   String(format: "%i", user.reputation.convertWithLogarithm10())
            
            // Load author profile image
            if let userProfileImageURL = user.profileImageURL {
                self.articleHeaderView.authorProfileImageView.uploadImage(byStringPath:     userProfileImageURL,
                                                                          avatarImage:      true,
                                                                          size:             CGSize(width: 30.0 * widthRatio, height: 30.0 * widthRatio),
                                                                          tags:             nil)
            }
        }
        
        // Load post cover image
        if let coverImageURL = lenta.coverImageURL {
            self.postImageView.uploadImage(byStringPath:    coverImageURL,
                                           avatarImage:     false,
                                           size:            CGSize(width: UIScreen.main.bounds.width, height: 180.0 * heightRatio),
                                           tags:            lenta.tags)
        }
        
        // Hide post image
        else {
            self.postImageViewHeightConstraint.constant = 0
        }

        self.titleLabel.text                        =   lenta.title        
        self.articleHeaderView.authorLabel.text     =   lenta.author
        self.articleHeaderView.categoryLabel.text   =   lenta.category
        self.upvotesButton.isEnabled                =   lenta.allowVotes
        self.commentsButton.isEnabled               =   lenta.allowReplies

        selectionStyle                              =   .none

        self.layoutIfNeeded()
        
        
//        commentsButton.setTitle(lenta.commentsAmount, for: .normal)
//        articleHeaderView.reblogAuthorLabel.text    =   displayedPost.reblogAuthorName
        
        // TODO: - PRECISE
        
        //        if let reblogAuthor = displayedPost.reblogAuthorName {
        //            articleHeaderView.reblogAuthorLabel.isHidden    =   false
        //            articleHeaderView.reblogAuthorLabel.text        =   reblogAuthor
        //            articleHeaderView.reblogIconImageView.isHidden  =   false
        //        }
        //
        //        else {
        //            articleHeaderView.reblogAuthorLabel.isHidden    =   true
        //            articleHeaderView.reblogIconImageView.isHidden  =   true
        //        }
        
        
    }
}
