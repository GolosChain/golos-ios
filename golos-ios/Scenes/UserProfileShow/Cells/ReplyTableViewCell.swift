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
        case .post:     return "Post Title".localized()
        case .answer:   return "Answer Title".localized()
        case .comment:  return "Comment Title Noun".localized()
        }
    }
}

class ReplyTableViewCell: UITableViewCell, ReusableCell {
    // MARK: - Properties
    var postShortInfo : PostShortInfo!
    
    var replyType: ReplyType = .post {
        didSet {
            self.replyTypeButton.setTitle(replyType.caseTitle().localized().lowercased(), for: .normal)
        }
    }
    
    // Handlers
    var handlerAnswerButtonTapped: ((PostShortInfo?) -> Void)?
    var handlerReplyTypeButtonTapped: ((Bool) -> Void)?
    var handlerAuthorCommentReplyTapped: ((String) -> Void)?
    
    // Markdown handlers
    var handlerMarkdownError: ((String) -> Void)?
    var handlerMarkdownURLTapped: ((URL) -> Void)?
    var handlerMarkdownAuthorNameTapped: ((String) -> Void)?

    
    // MARK: - IBOutlets
    @IBOutlet var markdownViewManager: MarkdownViewManager! {
        didSet {
            // Handlers
            self.markdownViewManager.completionShowSafariURL            =   { [weak self] url in
                self?.handlerMarkdownURLTapped!(url)
            }
            
            self.markdownViewManager.completionErrorAlertView           =   { [weak self] errorMessage in
                self?.handlerMarkdownError!(errorMessage)
            }
            
            self.markdownViewManager.completionCommentAuthorTapped      =   { [weak self] commentAuthorName in
                self?.handlerAuthorCommentReplyTapped!(commentAuthorName)
            }
        }
    }

    @IBOutlet weak var authorAvatarImageView: UIImageView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(authorLabelTapped))
            authorAvatarImageView.isUserInteractionEnabled = true
            authorAvatarImageView.addGestureRecognizer(tap)
        }
    }
    
    @IBOutlet weak var reputationLabel: UILabel! {
        didSet {
            reputationLabel.tune(withText: "",
                                 hexColors:           whiteColorPickers,
                                 font:                UIFont(name: "SFProDisplay-Medium", size: 6.0),
                                 alignment:           .center,
                                 isMultiLines:        false)
        }
    }
    
    @IBOutlet weak var authorLabel: UILabel! {
        didSet {
            authorLabel.tune(withText:          "",
                             hexColors:         veryDarkGrayWhiteColorPickers,
                             font:              UIFont(name: "SFProDisplay-Regular", size: 10.0),
                             alignment:         .left,
                             isMultiLines:      false)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(authorLabelTapped))
            authorLabel.isUserInteractionEnabled = true
            authorLabel.addGestureRecognizer(tap)
        }
    }
    
    @IBOutlet weak var authorTitleLabel: UILabel!  {
        didSet {
            authorTitleLabel.tune(withText:          "Answered your".localized(),
                                  hexColors:         darkGrayWhiteColorPickers,
                                  font:              UIFont(name: "SFProDisplay-Regular", size: 10.0),
                                  alignment:         .left,
                                  isMultiLines:      false)
        }
    }
    
    @IBOutlet weak var replyTypeButton: UIButton!  {
        didSet {
            replyTypeButton.tune(withTitle:         "",
                                 hexColors:         [darkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                                 font:              UIFont(name: "SFProDisplay-Regular", size: 10.0),
                                 alignment:         .left)
        }
    }
    
    @IBOutlet weak var answerButton: UIButton!  {
        didSet {
            answerButton.tune(withTitle:            "Reply Title Verb",
                              hexColors:            [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                              font:                 UIFont(name: "SFProDisplay-Regular", size: 10.0),
                              alignment:            .left)
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel!  {
        didSet {
            timeLabel.tune(withText:          "Days ago",
                           hexColors:         darkGrayWhiteColorPickers,
                           font:              UIFont(name: "SFProDisplay-Regular", size: 10.0),
                           alignment:         .left,
                           isMultiLines:      false)
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

    @IBOutlet var circleViewsCollection: [UIView]! {
        didSet {
            self.circleViewsCollection.forEach({ $0.layer.cornerRadius = $0.bounds.width / 2 * widthRatio })
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
    @objc func authorLabelTapped(sender: UITapGestureRecognizer) {
        guard !User.isAnonymous else {
            self.handlerAuthorCommentReplyTapped!(self.authorLabel.text!)
            return
        }
        
        if self.authorLabel.text! != User.current!.nickName {
            self.handlerAuthorCommentReplyTapped!(self.authorLabel.text!)
        }
    }
    
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        guard !User.isAnonymous else {
            self.handlerAnswerButtonTapped!(nil)
            return
        }

        if self.authorLabel.text! != User.current!.nickName {
            self.handlerAnswerButtonTapped!(self.postShortInfo)
        }
    }

    @IBAction func replyTypeButtonTapped(_ sender: UIButton) {
        self.handlerReplyTypeButtonTapped!(!User.isAnonymous)
    }
    
    
    // MARK: - Reuse identifier
    override var reuseIdentifier: String? {
        return ReplyTableViewCell.reuseIdentifier
    }
    
    class var reuseIdentifier: String? {
        return String(describing: self)
    }
}


// MARK: - ConfigureCell implementation
extension ReplyTableViewCell: ConfigureCell {
    func setup(withItem item: Any?, andIndexPath indexPath: IndexPath) {
        guard let model = item as? Reply, let reply = CoreDataManager.instance.readEntity(withName: "Reply", andPredicateParameters: NSPredicate(format: "id == \(model.id)")) as? Reply else {
            return
        }
        
        self.postShortInfo  =   PostShortInfo(id:               model.id,
                                              title:            model.body.substring(withCharactersCount: 120),
                                              author:           model.author,
                                              permlink:         model.permlink,
                                              parentTag:        model.tags?.first,
                                              indexPath:        nil,
                                              parentAuthor:     model.parentAuthor,
                                              parentPermlink:   model.parentPermlink)
        
        // Load markdown content
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.markdownViewManager.load(markdown: model.body)
        }

        // Load commentator info
        RestAPIManager.loadUsersInfo(byNickNames: [reply.author], completion: { [weak self] errorAPI in
            if errorAPI == nil, let commentator = User.fetch(byNickName: reply.author) {
                self?.authorLabel.text = commentator.nickName
                
                // Commentator Reputation -> Int
                self?.reputationLabel.text = String(format: "%i", commentator.reputation.convertWithLogarithm10())
                
                // Load commentator profile image
                if let commentatorProfileImageURL = commentator.profileImageURL {
                    self?.authorAvatarImageView.uploadImage(byStringPath:   commentatorProfileImageURL,
                                                            imageType:      .userProfileImage,
                                                            size:           CGSize(width: 50.0, height: 50.0),
                                                            tags:           nil,
                                                            createdDate:    commentator.created.convert(toDateFormat: .expirationDateType),
                                                            fromItem:       (commentator as CachedImageFrom).fromItem,
                                                            completion:     { _ in })
                }
            }

            else {
                self?.authorLabel.text      =   "Unknown User".localized()
                self?.reputationLabel.text  =   "0"
            }
        })
        
        self.timeLabel.text         =   reply.created.convertToDaysAgo()
        self.authorTitleLabel.text  =   "Answered your".localized()

        selectionStyle = .none

        self.setReplyType(reply)
    }
}
