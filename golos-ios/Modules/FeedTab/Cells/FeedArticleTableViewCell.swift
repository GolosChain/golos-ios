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
    
    //MARK: Constants
    private static let bodyFont = Fonts.shared.regular(with: 13.0)
    private static let bodyEdgesOffset: CGFloat = 12.0
    static let minimizedHeight: CGFloat = 180
    
    
    //MARK: UI Outlets
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var articleContentView: UIView!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var authorAvatarImageView: UIImageView!
    @IBOutlet private weak var reblogAuthorLabel: UILabel!
    @IBOutlet private weak var reblogIconImageView: UIImageView!
    @IBOutlet private weak var themeLabel: UILabel!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyTextView: UITextView!
    
    @IBOutlet private weak var upvoteButton: UIButton!
    @IBOutlet private weak var commentsButton: UIButton!
    
    @IBOutlet private weak var expandButton: UIButton!
    
    @IBOutlet weak var authorTappableView: UIView!
    @IBOutlet weak var reblogAuthorTappableView: UIView!
    
    
    //MARK: UI properties
    let gradientLayer = CAGradientLayer()
    var isExpanded = false {
        didSet {
            gradientView.isHidden = isExpanded
        }
    }
    
    var isNeedExpand = true {
        didSet {
            gradientView.isHidden = !isNeedExpand
        }
    }
    
    
    //MARK: Delegate
    weak var delegate: FeedArticleTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetAll()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        authorAvatarImageView.layer.cornerRadius = authorAvatarImageView.bounds.size.width / 2
        
        gradientLayer.frame = gradientView.bounds
        
        guard isNeedExpand == true else {
            return
        }
        
        if bounds.size.height == FeedArticleTableViewCell.minimizedHeight {
            isExpanded = false
        } else {
            isExpanded = true
        }
        
    }
    
    
    //MARK: Setup UI
    private func setupUI() {
        authorLabel.textColor = UIColor.Project.articleBlackColor
        authorLabel.font = Fonts.shared.regular(with: 12.0)
        
        reblogAuthorLabel.textColor = UIColor.Project.articleBlackColor
        reblogAuthorLabel.font = Fonts.shared.regular(with: 12.0)
        
        themeLabel.textColor = UIColor.Project.textPlaceholderGray
        themeLabel.font = Fonts.shared.regular(with: 10.0)
        
        authorAvatarImageView.layer.masksToBounds = true
        
        titleLabel.textColor = UIColor.Project.articleBlackColor
        titleLabel.font = Fonts.shared.regular(with: 16.0)
        
        bodyTextView.textColor = UIColor.Project.articleBodyGrayColor
        bodyTextView.textContainerInset = UIEdgeInsets(top: 0,
                                                       left: FeedArticleTableViewCell.bodyEdgesOffset,
                                                       bottom: 0,
                                                       right: 0)
        bodyTextView.font = FeedArticleTableViewCell.bodyFont
        
        upvoteButton.tintColor = UIColor.Project.articleButtonsGrayColor
        upvoteButton.setTitleColor(UIColor.Project.articleBodyGrayColor, for: .normal)
        upvoteButton.titleLabel?.font = Fonts.shared.regular(with: 10.0)
        
        commentsButton.tintColor = UIColor.Project.articleButtonsGrayColor
        commentsButton.setTitleColor(UIColor.Project.articleBodyGrayColor, for: .normal)
        commentsButton.titleLabel?.font = Fonts.shared.regular(with: 10.0)
        
        gradientLayer.colors = [UIColor(white: 1, alpha: 0.2).cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0.0, 0.6]
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        gradientView.isHidden = !isNeedExpand
        
        expandButton.tintColor = UIColor.Project.buttonTextGray
        
        let authorTapGesture = UITapGestureRecognizer(target: self, action: #selector(didPressAuthor))
        authorTappableView.addGestureRecognizer(authorTapGesture)
        
        let reblogAuthorTapGesture = UITapGestureRecognizer(target: self, action: #selector(didPressReblogAuthor))
        reblogAuthorTappableView.addGestureRecognizer(reblogAuthorTapGesture)
    }
    
    func configure(with viewModel: FeedArticleViewModel?) {
        guard let viewModel = viewModel else {
            return
        }
        authorName = viewModel.authorName
        authorAvatarUrl = viewModel.authorAvatarUrl
        articleTitle = viewModel.articleTitle
        reblogAuthorName = viewModel.reblogAuthorName
        theme = viewModel.theme
        articleImageUrl = viewModel.articleImageUrl
        articleBody = viewModel.articleBody
        upvoteAmount = viewModel.upvoteAmount
        commentsAmount = viewModel.commentsAmount
        didUpvote = viewModel.didUpvote
        didComment = viewModel.didComment
    }

    
    //MARK: Reset
    private func resetAll() {
        
    }
    
    
    //MARK: Actions
    @IBAction func didPressUpvoteButton(_ sender: Any) {
        delegate?.didPressUpvoteButton(at: self)
    }
    
    @IBAction func didPressCommentsButton(_ sender: Any) {
        delegate?.didPressCommentsButton(at: self)
    }
    
    @IBAction func didPressExpandButton(_ sender: Any) {
        delegate?.didPressExpandButton(at: self)
    }
    
    @objc
    private func didPressAuthor() {
        delegate?.didPressAuthor(at: self)
    }
    
    @objc
    private func didPressReblogAuthor() {
        delegate?.didPressReblogAuthor(at: self)
    }

    
    //MARK: Reuse identifier
    override var reuseIdentifier: String? {
        return FeedArticleTableViewCell.reuseIdentifier
    }
    
    class var reuseIdentifier: String? {
        return String.init(describing: self)
    }
}


//MARK: Setters
extension FeedArticleTableViewCell{
    var authorName: String? {
        get {
            return authorLabel.text
        }
        set {
            authorLabel.text = newValue
        }
    }
    
    var authorAvatarUrl: String? {
        get {
            return nil
        }
        set {
        
        }
    }
    
    var articleTitle: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    var reblogAuthorName: String? {
        get {
            return reblogAuthorLabel.text
        }
        set {
            reblogAuthorLabel.text = newValue
            reblogAuthorLabel.isHidden = newValue == nil
            reblogIconImageView.isHidden = newValue == nil
        }
    }
    
    var theme: String? {
        get {
            return themeLabel.text
        }
        set {
            themeLabel.text = newValue
        }
    }
    
    var articleImageUrl: String? {
        get {
            return nil
        }
        
        set {
            
        }
    }
    
    var articleBody: String? {
        get {
            return bodyTextView.text
        }
        
        set {
            bodyTextView.text = newValue
        }
    }
    
    var upvoteAmount: String? {
        get {
            return upvoteButton.title(for: .normal)
        }
        
        set {
            upvoteButton.setTitle(newValue, for: .normal)
        }
    }
    
    var commentsAmount: String? {
        get {
            return commentsButton.title(for: .normal)
        }
        
        set {
            commentsButton.setTitle(newValue, for: .normal)
        }
    }
    
    var didUpvote: Bool {
        get {
            return false
        }
        
        set {
            upvoteButton.tintColor = newValue
                ? UIColor.Project.articleButtonsGreenColor
                : UIColor.Project.articleButtonsGrayColor
        }
    }
    
    var didComment: Bool {
        get {
            return false
        }
        
        set {
            commentsButton.tintColor = newValue
                ? UIColor.Project.articleButtonsGreenColor
                : UIColor.Project.articleButtonsGrayColor
        }
    }
    
}
