//
//  AnswersFeedTableViewCell.swift
//  Golos
//
//  Created by Grigory on 14/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import CoreData
import GoloSwift

enum ReplyType: String {
    case post
    case answer
    case comment

    func caseTitle() -> String {
        switch self {
        case .post:         return "Post Title".localized()
        case .answer:       return "Answer Title".localized()
        case .comment:      return "Comment Title Noun".localized()
        }
    }
}

class ReplyTableViewCell: UITableViewCell, ReusableCell {
    // MARK: - Properties
    var replyType: ReplyType = .post {
        didSet {
            self.replyTypeButton.setTitle(replyType.caseTitle().localized().lowercased(), for: .normal)
        }
    }
    
    var handlerAnswerButtonTapped: (() -> Void)?
    var handlerReplyTypeButtonTapped: (() -> Void)?

    
    // MARK: - IBOutlets
    @IBOutlet weak var authorAvatarImageView: UIImageView!
    
    @IBOutlet weak var reputationLabel: UILabel! {
        didSet {
            reputationLabel.tune(withText: "",
                                 hexColors:           whiteColorPickers,
                                 font:                UIFont(name: "Roboto-Medium", size: 6.0 * widthRatio),
                                 alignment:           .center,
                                 isMultiLines:        false)
        }
    }
    
    @IBOutlet weak var authorLabel: UILabel! {
        didSet {
            authorLabel.tune(withText:          "",
                             hexColors:         veryDarkGrayWhiteColorPickers,
                             font:              UIFont(name: "SFProDisplay-Regular", size: 10.0 * widthRatio),
                             alignment:         .left,
                             isMultiLines:      false)
        }
    }
    
    @IBOutlet weak var authorTitleLabel: UILabel!  {
        didSet {
            authorTitleLabel.tune(withText:          "Answered your".localized(),
                                  hexColors:         darkGrayWhiteColorPickers,
                                  font:              UIFont(name: "SFProDisplay-Regular", size: 10.0 * widthRatio),
                                  alignment:         .left,
                                  isMultiLines:      false)
        }
    }
    
    @IBOutlet weak var replyTextLabel: UILabel! {
        didSet {
            replyTextLabel.tune(withText:          "",
                                 hexColors:         veryDarkGrayWhiteColorPickers,
                                 font:              UIFont(name: "SFProDisplay-Regular", size: 12.0 * widthRatio),
                                 alignment:         .left,
                                 isMultiLines:      false)
            
            replyTextLabel.numberOfLines = 2
        }
    }
    
    @IBOutlet weak var replyTypeButton: UIButton!  {
        didSet {
            replyTypeButton.tune(withTitle:         "",
                                 hexColors:         darkGrayWhiteColorPickers,
                                 font:              UIFont(name: "SFProDisplay-Regular", size: 10.0 * widthRatio),
                                 alignment:         .left)
        }
    }
    
    @IBOutlet weak var answerButton: UIButton!  {
        didSet {
            answerButton.tune(withTitle:            "Reply Title Verb",
                              hexColors:            darkGrayWhiteColorPickers,
                              font:                 UIFont(name: "SFProDisplay-Regular", size: 10.0 * widthRatio),
                              alignment:            .left)
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel!  {
        didSet {
            timeLabel.tune(withText:          "Days ago",
                           hexColors:         darkGrayWhiteColorPickers,
                           font:              UIFont(name: "SFProDisplay-Regular", size: 10.0 * widthRatio),
                           alignment:         .left,
                           isMultiLines:      false)
        }
    }
    
    @IBOutlet var widthCollection: [NSLayoutConstraint]! {
        didSet {
            _ = widthCollection.map({ $0.constant *= widthRatio })
        }
    }

    @IBOutlet var heightCollection: [NSLayoutConstraint]! {
        didSet {
            _ = heightCollection.map({ $0.constant *= heightRatio })
        }
    }

    @IBOutlet var circleViewsCollection: [UIView]! {
        didSet {
            _ = circleViewsCollection.map({ $0.layer.cornerRadius = $0.bounds.width / 2 * widthRatio })
        }
    }
    
    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
    
        setup()
    }
    
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Class Functions
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.replyType                      =   .post
        self.authorLabel.text               =   nil
        self.reputationLabel.text           =   nil
        self.authorAvatarImageView.image    =   UIImage(named: "icon-user-profile-image-placeholder")
    }
    
    
    // MARK: - Custom Functions
    private func setup() {
        authorAvatarImageView.layer.masksToBounds = true
        
        contentView.tune()
    }
    
    private func setReplyType(_ reply: Reply) {
        // Post: parentPermlink == nil
        guard let parentPermlink = reply.parentPermlink else {
            self.replyType = .post
            return
        }
        
        switch parentPermlink {
        // Answer
        case let permlink where permlink.hasPrefix(String(format: "re-%@", reply.parentAuthor!)):
            self.replyType = .answer

        // Comment
        default:
            self.replyType = .comment
        }
    }
    

    // MARK: - Actions
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        self.handlerAnswerButtonTapped!()
    }

    @IBAction func replyTypeButtonTapped(_ sender: UIButton) {
        self.handlerReplyTypeButtonTapped!()
    }
}


// MARK: - ConfigureCell implementation
extension ReplyTableViewCell: ConfigureCell {
    func setup(withItem item: Any?, andIndexPath indexPath: IndexPath) {
        guard let reply = item as? Reply else {
            return
        }
        
        // Get commentator info
        if let userCommentator = User.fetch(byName: reply.author) {
            self.authorLabel.text       =   userCommentator.name

            // Reputation -> Int
            self.reputationLabel.text   =   String(format: "%i", userCommentator.reputation.convertWithLogarithm10())

            // Load author profile image
            if let userProfileImageURL = userCommentator.profileImageURL {
                self.authorAvatarImageView.uploadImage(byStringPath:    userProfileImageURL,
                                                       imageType:       .userProfileImage,
                                                       size:            CGSize(width: 50.0 * widthRatio, height: 50.0 * widthRatio),
                                                       tags:            nil)
            }
        }
        
        self.timeLabel.text             =   reply.created.convertToDaysAgo()
        self.replyTextLabel.text        =   reply.body
        
        selectionStyle                  =   .none

        self.setReplyType(reply)
    }
}
