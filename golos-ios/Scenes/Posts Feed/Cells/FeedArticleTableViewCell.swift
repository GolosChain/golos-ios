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
        
        self.pictureURL             =   ""
        self.authorPictureURL       =   ""
        
        let avatarPlaceholderImage                          =   UIImage(named: "image-placeholder")
        articleHeaderView.authorProfileImageView.image      =   avatarPlaceholderImage
        
        self.postImageView.image                            =   nil
        self.titleLabelTopConstraint.constant               =   0
        self.postImageViewTopConstraint.constant            =   0
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
    
//    static func height(withImage: Bool) -> CGFloat {
//        return (withImage ? 427.0 : 427.0 - 212.0) * heightRatio
//    }
}


// MARK: - ConfigureCell implementation
extension FeedArticleTableViewCell: ConfigureCell {
    func setup(withItem item: Any?, andIndexPath indexPath: IndexPath) {
        guard let lenta = item as? Lenta else {
            return
        }
        
        // Hide/show title
        if lenta.title.isEmpty {
            self.titleLabel.display(withTopConstraint: self.titleLabelTopConstraint, height: self.titleLabel.frame.height, isShow: false)
        }
        
        else {
            self.titleLabel.text                    =   lenta.title
        }
        
        self.articleHeaderView.authorLabel.text     =   lenta.author
        self.articleHeaderView.categoryLabel.text   =   lenta.category
//        articleHeaderView.reblogAuthorLabel.text    =   displayedPost.reblogAuthorName
        self.upvotesButton.isEnabled                =   lenta.allowVotes
        self.commentsButton.isEnabled               =   lenta.allowReplies

//        commentsButton.setTitle(lenta.commentsAmount, for: .normal)

        
        // Hide/show post image
//        self.postImageView.display(withTopConstraint: self.postImageViewTopConstraint, height: self.postImageView.frame.height, isShow: false)
        
        
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
        
//        guard let tags = lenta.tags else { return }
//        
//        let isNsfw = tags.map({ $0.lowercased() }).contains("nsfw")
//        
//        // Images: set height
//        let imageHeight: CGFloat            =   ((lenta.imagePictureURL != nil || isNsfw) ? 212.0 : 0.0) * heightRatio
//        imageViewHeightConstraint.constant  =   imageHeight
//        contentView.layoutIfNeeded()
//        
//        // Images: upload
//        if isNsfw {
//            let nsfwImage                   =   UIImage(named: "nsfw")
//            self.postImageView.image        =   nsfwImage
//        }
//            
//        else if let imageURL = lenta.imagePictureURL {
//            if self.pictureURL == imageURL && postImageView.image != nil {
//                return
//            }
//            
//            // Add proxy
//            if imageURL.hasPrefix("https://images.golos.io") {
//                self.pictureURL     =   imageURL
//            }
//                
//            else {
//                self.pictureURL     =   "https://imgp.golos.io" + String(format: "/%dx%d/", self.postImageView.frame.width, self.postImageView.frame.height) + imageURL
//            }
//            
//            imageLoader.startLoadImage(with: self.pictureURL) { (image) in
//                DispatchQueue.main.async {
//                    self.postImageView.image = image ?? UIImage(named: "XXX")
//                }
//            }
//        }
        
//        if let authorPictureURL = lenta.authorAvatarURL {
//            if self.authorPictureURL == authorPictureURL && articleHeaderView.authorProfileImageView.image != nil {
//                return
//            }
//
//            self.authorPictureURL = authorPictureURL
              self.articleHeaderView.authorReputationLabel.text = "234"
        
//            imageLoader.startLoadImage(with: authorPictureURL) { (image) in
//                DispatchQueue.main.async {
//                    if let image = image, authorPictureURL == self.authorPictureURL {
//                        self.articleHeaderView.authorProfileImageView.image = image
//                    }
//                }
//            }
//        }
//
//        else {
//            let avatarPlaceholderImage                      =   UIImage(named: "icon-user-profile-image-placeholder")
//            articleHeaderView.authorProfileImageView.image  =   avatarPlaceholderImage
//        }
        
        
        // Load author profile image
//        if let userProfileImageURL = reply.commentator?.profileImageURL {
//            userProfileImageURL.uploadImage(withSize: CGSize(width: 50.0 * widthRatio, height: 50.0 * widthRatio), completion: { [weak self] image in
//                DispatchQueue.main.async {
//                    self?.authorAvatarImageView.image = image
//                }
//            })
//        }
        
        selectionStyle = .none
    }
}
