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
    
    let imageLoader = GSImageLoader()
    
    // MARK: Constants
    private static let bodyFont = Fonts.shared.regular(with: 13.0)
    private static let bodyEdgesOffset: CGFloat = 12.0
    static let minimizedHeight: CGFloat = 180
    
    
    // MARK: UI Outlets
    @IBOutlet private weak var articleHeaderView: ArticleHeaderView!
    @IBOutlet private weak var articleContentView: UIView!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var upvoteButton: UIButton!
    @IBOutlet private weak var commentsButton: UIButton!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    private var pictureUrl: String = ""
    private var authorPictureUrl: String = ""
    
    
    // MARK: UI properties
    let gradientLayer = CAGradientLayer()
    
    // MARK: Delegate
    weak var delegate: FeedArticleTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        let avatarPlaceholderImage = UIImage(named: "avatar_placeholder")
        articleHeaderView.authorAvatarImageView.image = avatarPlaceholderImage
        
        postImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: Setup UI
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
    
    func configure(with viewModel: PostsFeedViewModel?) {
        guard let viewModel = viewModel else {
            return
        }
        
        titleLabel.text = viewModel.articleTitle
        descriptionTextView.text = viewModel.postDescription
        articleHeaderView.authorLabel.text = viewModel.authorName
        articleHeaderView.themeLabel.text = viewModel.theme
        articleHeaderView.reblogAuthorLabel.text = viewModel.reblogAuthorName
        upvoteButton.tintColor = viewModel.didUpvote ? UIColor.Project.articleButtonsGreenColor : UIColor.Project.articleButtonsGrayColor
        upvoteButton.setTitle(viewModel.upvoteAmount, for: .normal)
        commentsButton.tintColor = viewModel.didComment ? UIColor.Project.articleButtonsGreenColor : UIColor.Project.articleButtonsGrayColor
        commentsButton.setTitle(viewModel.commentsAmount, for: .normal)
        
        if let reblogAuthor = viewModel.reblogAuthorName {
            articleHeaderView.reblogAuthorLabel.isHidden = false
            articleHeaderView.reblogAuthorLabel.text = reblogAuthor
            articleHeaderView.reblogIconImageView.isHidden = false
        } else {
            articleHeaderView.reblogAuthorLabel.isHidden = true
            articleHeaderView.reblogIconImageView.isHidden = true
        }
        
        
        let imageHeight: CGFloat = viewModel.imagePictureUrl == nil ? 0 : 212
        imageViewHeightConstraint.constant = imageHeight
        contentView.layoutIfNeeded()
        
        if let imageUrl = viewModel.imagePictureUrl {
            if self.pictureUrl == imageUrl && postImageView.image != nil {
                return
            }
            
            self.pictureUrl = imageUrl
            imageLoader.startLoadImage(with: imageUrl) { (image) in
                DispatchQueue.main.async {
                    if let image = image, imageUrl == self.pictureUrl {
                        self.postImageView.image = image
                    }
                }
            }
        }
        
        if let authorPictureUrl = viewModel.authorAvatarUrl {
            if self.authorPictureUrl == authorPictureUrl && articleHeaderView.authorAvatarImageView.image != nil {
                return
            }
            
            self.authorPictureUrl = authorPictureUrl
            imageLoader.startLoadImage(with: authorPictureUrl) { (image) in
                DispatchQueue.main.async {
                    if let image = image, authorPictureUrl == self.authorPictureUrl {
                        self.articleHeaderView.authorAvatarImageView.image = image
                    }
                }
            }
        } else {
            let avatarPlaceholderImage = UIImage(named: "avatar_placeholder")
            articleHeaderView.authorAvatarImageView.image = avatarPlaceholderImage
        }
    }

    
    // MARK: Actions
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


// MARK: ArticleHeaderViewDelegate
extension FeedArticleTableViewCell: ArticleHeaderViewDelegate {
    func didPressAuthor() {
        delegate?.didPressAuthor(at: self)
    }
    
    func didPressReblogAuthor() {
        delegate?.didPressReblogAuthor(at: self)
    }
}
