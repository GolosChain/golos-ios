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
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var postImageViewTopConstraint: NSLayoutConstraint!
    
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
    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.pictureURL                                         =   ""
        self.authorPictureURL                                   =   ""
        self.articleHeaderView.authorProfileImageView.image     =   UIImage(named: "icon-user-profile-image-placeholder")
        
        self.titleLabel.alpha                                   =   1.0
        self.titleLabel.text                                    =   nil
//        self.titleLabelTopConstraint.constant                   =   -40.0 * heightRatio

        self.postImageView.alpha                                =   1.0
        self.postImageView.image                                =   nil
//        self.postImageViewTopConstraint.constant                =   -180 * heightRatio
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    // MARK: - Setup UI
    private func setupUI() {
        titleLabel.textColor = UIColor.Project.articleBlackColor
        titleLabel.font = Fonts.shared.regular(with: 16.0 * widthRatio)
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
                userProfileImageURL.upload(avatarImage: true, size: CGSize(width: 30.0 * widthRatio, height: 30.0 * widthRatio), tags: nil, completion: { [weak self] image in
                    self?.articleHeaderView.authorProfileImageView.image = image
                })
            }
        }
        
        // Load post cover image
        if let coverImageURL = lenta.coverImageURL {
            coverImageURL.upload(avatarImage: true, size: CGSize(width: UIScreen.main.bounds.width, height: 180.0 * heightRatio), tags: lenta.tags, completion: { [weak self] image in
                self?.postImageView.image = image
                
                // Hide/show post image
                self?.postImageView.display(withTopConstraint:      (self?.postImageViewTopConstraint)!,
                                            height:                 (self?.postImageView.frame.height)!,
                                            isShow:                 !image.isEqualTo(image: UIImage(named: "image-placeholder")!))
            })
        }
        
        else {
            // Hide post image
            self.postImageView.display(withTopConstraint:      self.postImageViewTopConstraint,
                                       height:                 self.postImageView.frame.height,
                                       isShow:                 false)
        }

        // Hide/show title
        self.titleLabel.text                        =   lenta.title
        self.titleLabel.display(withTopConstraint: self.titleLabelTopConstraint, height: self.titleLabel.frame.height, isShow: lenta.title.isEmpty)
        
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
