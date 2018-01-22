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

class FeedArticleTableViewCell: UITableViewCell {
    
    //MARK: Constants
    private let minimizedHeight: CGFloat = 65.0
    
    //MARK: Setters properties
    var authorName: String? {
        didSet {
            authorLabel.text = authorName
        }
    }
    var authorAvatarUrl: String? {
        didSet {
            
        }
    }
    var articleTitle: String? {
        didSet {
            titleLabel.text = articleTitle
        }
    }
    var reblogAuthorName: String? {
        didSet {
            guard let name = reblogAuthorName else {
                reblogAuthorLabel.isHidden = true
                reblogIconImageView.isHidden = true
                return
            }
            reblogAuthorLabel.isHidden = false
            reblogIconImageView.isHidden = false
            reblogAuthorLabel.text = name
        }
    }
    var theme: String? {
        didSet {
            themeLabel.text = theme
        }
    }
    var articleImageUrl: String? {
        didSet {
            
        }
    }
    var articleBody: String? {
        didSet {
            bodyTextView.text = articleBody
        }
    }
    var upvoteAmount: String? {
        didSet {
            upvoteButton.setTitle(upvoteAmount, for: .normal)
        }
    }
    var commentsAmount: String? {
        didSet {
            commentsButton.setTitle(commentsAmount, for: .normal)
        }
    }
    var didUpvote: Bool = false {
        didSet {
            upvoteButton.tintColor = didUpvote
                ? UIColor.Project.articleButtonsGreenColor
                : UIColor.Project.articleButtonsGrayColor
            
        }
    }
    var didComment: Bool = false {
        didSet {
            commentsButton.tintColor = didComment
                ? UIColor.Project.articleButtonsGreenColor
                : UIColor.Project.articleButtonsGrayColor
        }
    }
    
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
    
    @IBOutlet private var contentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private var textViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var authorTappableView: UIView!
    @IBOutlet weak var reblogAuthorTappableView: UIView!
    
    
    //MARK: UI properties
    let gradientLayer = CAGradientLayer()
    var isExpanded = false {
        didSet {
            updateExpand(animated: false)
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
        bodyTextView.textContainerInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        upvoteButton.tintColor = UIColor.Project.articleButtonsGrayColor
        upvoteButton.setTitleColor(UIColor.Project.articleBodyGrayColor, for: .normal)
        upvoteButton.titleLabel?.font = Fonts.shared.regular(with: 10.0)
        
        commentsButton.tintColor = UIColor.Project.articleButtonsGrayColor
        commentsButton.setTitleColor(UIColor.Project.articleBodyGrayColor, for: .normal)
        commentsButton.titleLabel?.font = Fonts.shared.regular(with: 10.0)
        
        gradientLayer.colors = [UIColor(white: 1, alpha: 0.2).cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0.0, 0.6]
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        
        textViewHeightConstraint.constant = minimizedHeight
        textViewHeightConstraint.isActive = true
        
        expandButton.tintColor = UIColor.Project.buttonTextGray
        
        let authorTapGesture = UITapGestureRecognizer(target: self, action: #selector(didPressAuthor))
        authorTappableView.addGestureRecognizer(authorTapGesture)
        
        let reblogAuthorTapGesture = UITapGestureRecognizer(target: self, action: #selector(didPressReblogAuthor))
        reblogAuthorTappableView.addGestureRecognizer(reblogAuthorTapGesture)
    }
    
    
    //MARK: Reset
    private func resetAll() {
        textViewHeightConstraint.constant = minimizedHeight
        rotateArrow(down: false, animated: false)
        isExpanded = false
    }
    
    private func updateExpand(animated: Bool) {
        if isExpanded {
            let fixedWidth = bodyTextView.bounds.size.width
            let newSize = bodyTextView.sizeThatFits(CGSize.init(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            var newFrame = bodyTextView.frame
            newFrame.size = CGSize(width: CGFloat.maximum(newSize.width, fixedWidth), height: newSize.height)
            
            textViewHeightConstraint.constant = newSize.height + 30
        } else {
            textViewHeightConstraint.constant = minimizedHeight
        }
        
        rotateArrow(down: !isExpanded, animated: animated)
        delegate?.didPressExpandButton(at: self)
    }
    
//    - (void)textViewFitToContent:(UITextView *)textView
//    {
//    CGFloat fixedWidth = textView.frame.size.width;
//    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
//    CGRect newFrame = textView.frame;
//    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
//    textView.frame = newFrame;
//    textView.scrollEnabled = NO;
//    }
    
    
    //MARK: Actions
    @IBAction func didPressUpvoteButton(_ sender: Any) {
        delegate?.didPressUpvoteButton(at: self)
    }
    
    @IBAction func didPressCommentsButton(_ sender: Any) {
        delegate?.didPressCommentsButton(at: self)
    }
    
    @IBAction func didPressExpandButton(_ sender: Any) {
        isExpanded = !isExpanded
    }
    
    @objc
    private func didPressAuthor() {
        delegate?.didPressAuthor(at: self)
    }
    
    @objc
    private func didPressReblogAuthor() {
        delegate?.didPressReblogAuthor(at: self)
    }
    
    private func rotateArrow(down: Bool, animated: Bool) {
        let transform = down
            ? CGAffineTransform.identity
            : expandButton.transform.rotated(by: 180 * CGFloat(Double.pi/180))
        
        let animations = {
            self.expandButton.transform = transform
        }
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: animations)
        } else {
            animations()
        }
    }
    
    
    //MARK: Reuse identifier
    override var reuseIdentifier: String? {
        return FeedArticleTableViewCell.reuseIdentifier
    }
    
    class var reuseIdentifier: String? {
        return String.init(describing: self)
    }
}
