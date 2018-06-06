//
//  FeedArticleTableViewCell.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 22/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

protocol FeedArticleTableViewCellDelegate: class {
    func didPressCommentsButton(at cell: FeedArticleTableViewCell)
    func didPressUpvoteButton(at cell: FeedArticleTableViewCell)
    func didPressExpandButton(at cell: FeedArticleTableViewCell)
    func didPressAuthor(at cell: FeedArticleTableViewCell)
    func didPressReblogAuthor(at cell: FeedArticleTableViewCell)
}

extension FeedArticleTableViewCellDelegate {
    func didPressExpandButton(at cell: FeedArticleTableViewCell) {}
}

class FeedArticleTableViewCell: UITableViewCell {
    // MARK: - Properties
    let imageLoader = GSImageLoader()
    let gradientLayer = CAGradientLayer()
   
    weak var delegate: FeedArticleTableViewCellDelegate?

    private static let bodyFont = Fonts.shared.regular(with: 13.0)
    private static let bodyEdgesOffset: CGFloat = 12.0

    private var pictureURL: String = ""
    private var authorPictureURL: String = ""

    static let minimizedHeight: CGFloat = 180
    
    
    // MARK: - IBOutlets
    @IBOutlet private weak var articleHeaderView: ArticleHeaderView!
    @IBOutlet private weak var articleContentView: UIView!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var upvoteButton: UIButton!
    @IBOutlet private weak var commentsButton: UIButton!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        authorPictureURL = ""
        pictureURL = ""
        
        let avatarPlaceholderImage = UIImage(named: "avatar_placeholder")
        articleHeaderView.authorAvatarImageView.image = avatarPlaceholderImage
        
        postImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    // MARK: - Setup UI
    private func setupUI() {
        titleLabel.textColor = UIColor.Project.articleBlackColor
        titleLabel.font = Fonts.shared.regular(with: 16.0)
        
        upvoteButton.tintColor = UIColor.Project.articleButtonsGrayColor
        upvoteButton.setTitleColor(UIColor.Project.articleBodyGrayColor, for: .normal)
        upvoteButton.titleLabel?.font = Fonts.shared.regular(with: 10.0)
        
        commentsButton.tintColor = UIColor.Project.articleButtonsGrayColor
        commentsButton.setTitleColor(UIColor.Project.articleBodyGrayColor, for: .normal)
        commentsButton.titleLabel?.font = Fonts.shared.regular(with: 10.0)
        
        articleHeaderView.delegate = self
        
        descriptionTextView.textContainer.lineBreakMode = .byTruncatingTail
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 5, left: 13, bottom: 0, right: 13)
    }
    
    func configure(withDisplayedModel displayedModel: DisplayedPost?) {
        guard let displayedPost = displayedModel else {
            return
        }
        
        titleLabel.text                             =   displayedPost.title
        descriptionTextView.text                    =   displayedPost.description
        articleHeaderView.authorLabel.text          =   displayedPost.authorName
        articleHeaderView.themeLabel.text           =   displayedPost.category
//        articleHeaderView.reblogAuthorLabel.text    =   displayedPost.reblogAuthorName
        upvoteButton.tintColor                      =   displayedPost.allowVotes ?  UIColor.Project.articleButtonsGreenColor :
                                                                                    UIColor.Project.articleButtonsGrayColor
        
//        upvoteButton.setTitle(displayedPost.activeVotesCount, for: .normal)
        commentsButton.tintColor = displayedPost.allowReplies ? UIColor.Project.articleButtonsGreenColor : UIColor.Project.articleButtonsGrayColor
        
        // TODO: - PRECISE
//        commentsButton.setTitle(displayedPost.commentsAmount, for: .normal)
        
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
        
        guard let tags = displayedPost.tags else { return }
        
        let isNsfw = tags.map({ $0.lowercased() }).contains("nsfw")
        
        // Images: set height
        let imageHeight: CGFloat            =   (displayedPost.imagePictureURL != nil || isNsfw) ? 212.0 : 0.0
        imageViewHeightConstraint.constant  =   imageHeight
        contentView.layoutIfNeeded()

        // Images: upload
        if isNsfw {
            let nsfwImage                   =   UIImage(named: "nsfw")
            self.postImageView.image        =   nsfwImage
        }

        else if let imageURL = displayedPost.imagePictureURL {
            if self.pictureURL == imageURL && postImageView.image != nil {
                return
            }

            // Add proxy
            if imageURL.hasPrefix("https://images.golos.io") {
                self.pictureURL     =   imageURL
            }
            
            else {
                self.pictureURL     =   "https://imgp.golos.io" + String(format: "/%dx%d/", self.postImageView.frame.width, self.postImageView.frame.height) + imageURL
            }
            
            imageLoader.startLoadImage(with: self.pictureURL) { (image) in
                DispatchQueue.main.async {
                    self.postImageView.image = image ?? UIImage(named: "XXX")
                }
            }
        }
        
        if let authorPictureURL = displayedPost.authorAvatarURL {
            if self.authorPictureURL == authorPictureURL && articleHeaderView.authorAvatarImageView.image != nil {
                return
            }

            self.authorPictureURL = authorPictureURL
           
            imageLoader.startLoadImage(with: authorPictureURL) { (image) in
                DispatchQueue.main.async {
                    if let image = image, authorPictureURL == self.authorPictureURL {
                        self.articleHeaderView.authorAvatarImageView.image = image
                    }
                }
            }
        }

        else {
            let avatarPlaceholderImage = UIImage(named: "avatar_placeholder")
            articleHeaderView.authorAvatarImageView.image = avatarPlaceholderImage
        }
    }
    
    
    // MARK: - Actions
    @IBAction func didPressUpvoteButton(_ sender: Any) {
        delegate?.didPressUpvoteButton(at: self)
    }
    
    @IBAction func didPressCommentsButton(_ sender: Any) {
        delegate?.didPressCommentsButton(at: self)
    }
    
    @IBAction func didPressExpandButton(_ sender: Any) {
        delegate?.didPressExpandButton(at: self)
    }
    
    
    // MARK: Reuse identifier
    override var reuseIdentifier: String? {
        return FeedArticleTableViewCell.reuseIdentifier
    }
    
    class var reuseIdentifier: String? {
        return String(describing: self)
    }
    
    static func height(withImage: Bool) -> CGFloat {
        return withImage ? 427 : 427 - 212
    }
}


// MARK: - ArticleHeaderViewDelegate
extension FeedArticleTableViewCell: ArticleHeaderViewDelegate {
    func didPressAuthor() {
        delegate?.didPressAuthor(at: self)
    }
    
    func didPressReblogAuthor() {
        delegate?.didPressReblogAuthor(at: self)
    }
}
