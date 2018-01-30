//
//  TableViewCellArticleComment.swift
//  Golos
//
//  Created by Grigory on 30/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

protocol ArticleCommentTableViewCellDelegate: class {
    func didPressUpvote(at cell: ArticleCommentTableViewCell)
    func didPressComments(at cell: ArticleCommentTableViewCell)
    func didPressReply(at cell: ArticleCommentTableViewCell)
}

class ArticleCommentTableViewCell: UITableViewCell {

    // IBOutlets properties
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var upvoteButton: UIButton!
    @IBOutlet weak var upvoteAmountButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    
    // Delegate
    weak var delegate: ArticleCommentTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    
    //MARK: Setup
    private func setup() {
        let greenColor = UIColor.Project.articleButtonsGreenColor
        let grayColor = UIColor.Project.articleButtonsGrayColor
        let blackColor = UIColor.Project.articleBlackColor
        
        upvoteButton.tintColor = grayColor
        upvoteButton.setTitleColor(blackColor, for: .normal)
        
        upvoteAmountButton.tintColor = grayColor
        upvoteAmountButton.setTitleColor(blackColor, for: .normal)
        
        commentsButton.tintColor = grayColor
        commentsButton.setTitleColor(blackColor, for: .normal)
        
        replyButton.setTitleColor(UIColor.Project.articleBodyGrayColor, for: .normal)
        replyButton.titleLabel?.font = Fonts.shared.medium(with: 10.0)
        
        avatarImageView.layer.masksToBounds = true
    }
    
    
    //MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.size.height / 2
    }
    
    
    //MARK: Actions
    @IBAction func upvoteButtonPressed(_ sender: Any) {
        delegate?.didPressUpvote(at: self)
    }
    
    @IBAction func commentsButtonPressed(_ sender: Any) {
        delegate?.didPressComments(at: self)
    }
    
    @IBAction func answerButtonPressed(_ sender: Any) {
        delegate?.didPressReply(at: self)
    }
    
    
    //MARK: Reuse identifier
    override var reuseIdentifier: String? {
        return ArticleCommentTableViewCell.reuseIdentifier
    }
    
    class var reuseIdentifier: String? {
        return String(describing: self)
    }
}


//MARK: Setters
extension ArticleCommentTableViewCell {
    var upvoteString: String? {
        get {return upvoteButton.title(for: .normal)}
        set {upvoteButton.setTitle(newValue, for: .normal) }
    }
    
    var upvoteAmountString: String? {
        get {return upvoteAmountButton.title(for: .normal)}
        set {upvoteAmountButton.setTitle(newValue, for: .normal) }
    }
    
    var commentsAmountString: String? {
        get {return commentsButton.title(for: .normal)}
        set {commentsButton.setTitle(newValue, for: .normal) }
    }
    
    var isUpvote: Bool {
        get {return false}
        set {upvoteButton.tintColor = newValue
            ? UIColor.Project.articleButtonsGreenColor
            : UIColor.Project.articleButtonsGrayColor}
    }
    
    var isComment: Bool {
        get {return false}
        set {commentsButton.tintColor = newValue
            ? UIColor.Project.articleButtonsGreenColor
            : UIColor.Project.articleButtonsGrayColor}
    }
}
