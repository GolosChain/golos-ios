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
    case comment
    
    func caseTitle() -> String {
        switch self {
        case .post:         return "Post Title".localized()
        case .comment:      return "Comment Title".localized()
        }
    }
}

class ReplyTableViewCell: UITableViewCell, ReusableCell {
    // MARK: - Properties
    var replyType: ReplyType = .post {
        didSet {
            self.replyTypeButton.setTitle(replyType.caseTitle().lowercased(), for: .normal)
        }
    }
    
    var handlerAnswerButtonTapped: (() -> Void)?
    var handlerReplyTypeButtonTapped: (() -> Void)?

    
    // MARK: - IBOutlets
    @IBOutlet weak var authorAvatarImageView: UIImageView!
    
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
            answerButton.tune(withTitle:            "Answer",
                              hexColors:            darkGrayWhiteColorPickers,
                              font:                 UIFont(name: "SFProDisplay-Regular", size: 10.0 * widthRatio),
                              alignment:            .left)
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel!  {
        didSet {
            authorLabel.tune(withText:          "Days ago",
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

        authorAvatarImageView.layer.cornerRadius = authorAvatarImageView.bounds.width / 2
    }
    

    // MARK: - Custom Functions
    private func setup() {
        authorAvatarImageView.layer.masksToBounds = true
        
        contentView.tune()
    }
    
    private func setReplyType(_ reply: Reply) {
        
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
        
        self.authorLabel.text       =   reply.author
        self.replyTextLabel.text    =   reply.body
        self.timeLabel.text         =   reply.created.convertToDaysAgo()

        self.setReplyType(reply)

        // Load author avatar
        if let imageURL = reply.jsonMetadata {
            GSImageLoader().startLoadImage(with: imageURL) { [weak self] image in
                guard let strongSelf = self else { return }
                
                let image = image ?? UIImage(named: "image-placeholder")
                strongSelf.authorAvatarImageView.image = image
            }
        }
        
        selectionStyle  =   .none
    }
}
