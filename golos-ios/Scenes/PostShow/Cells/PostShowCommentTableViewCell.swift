//
//  PostShowCommentTableViewCell.swift
//  Golos
//
//  Created by msm72 on 05.08.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import CoreData
import GoloSwift
import MarkdownView

class PostShowCommentTableViewCell: UITableViewCell {
    // MARK: - Properties
    var completionAuthorNameButtonTapped: (() -> Void)?
    var completionAuthorProfileAddButtonTapped: (() -> Void)?
    var completionAuthorProfileImageButtonTapped: (() -> Void)?
    var completionCellChangeHeight: ((CGFloat) -> Void)?

    // Action buttons completions
    var completionUpvotesButtonTapped: (() -> Void)?
    var completionUsersButtonTapped: (() -> Void)?
    var completionCommentsButtonTapped: (() -> Void)?
    var completionReplyButtonTapped: (() -> Void)?
    var completionShareButtonTapped: (() -> Void)?

    
    // MARK: - IBOutlets
    @IBOutlet weak var markdownViewManager: MarkdownViewManager!

    @IBOutlet weak var authorProfileImageButton: UIButton! {
        didSet {
            authorProfileImageButton.layer.cornerRadius = 40.0 * heightRatio / 2
        }
    }
    
    @IBOutlet weak var authorProfileAddButton: UIButton! {
        didSet {
            authorProfileAddButton.layer.cornerRadius = 18.0 * heightRatio / 2
        }
    }
    
    @IBOutlet weak var authorNameButton: UIButton! {
        didSet {
            authorNameButton.tune(withTitle:    "",
                                  hexColors:    [darkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                                  font:         UIFont(name: "SFUIDisplay-Regular", size: 10.0 * widthRatio),
                                  alignment:    .left)
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.tune(withText:            "",
                           hexColors:           darkGrayWhiteColorPickers,
                           font:                UIFont(name: "SFUIDisplay-Regular", size: 10.0 * widthRatio),
                           alignment:           .left,
                           isMultiLines:        false)
        }
    }

    @IBOutlet weak var replyButton: UIButton! {
        didSet {
            replyButton.tune(withTitle:         "Reply Verb",
                             hexColors:         [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                             font:              UIFont(name: "SFUIDisplay-Medium", size: 10.0 * widthRatio),
                             alignment:         .left)
        }
    }
    
    @IBOutlet var heightsCollection: [NSLayoutConstraint]! {
        didSet {
            _ = heightsCollection.map({ $0.constant *= heightRatio })
        }
    }
    
    @IBOutlet var widthsCollection: [NSLayoutConstraint]! {
        didSet {
            _ = widthsCollection.map({ $0.constant *= heightRatio })
        }
    }
    
    @IBOutlet weak var cellLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var markdownViewHeightConstraint: NSLayoutConstraint!


    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.tune()
    }

    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    
    
    // MARK: - Actions
    @IBAction func authorProfileImageButtonTapped(_ sender: UIButton) {
        self.completionAuthorProfileImageButtonTapped!()
    }
    
    @IBAction func authorProfileAddButtonTapped(_ sender: UIButton) {
        self.completionAuthorProfileAddButtonTapped!()
    }
    
    @IBAction func authorNameButtonTapped(_ sender: UIButton) {
        self.completionAuthorNameButtonTapped!()
    }
    
    // Action buttons
    @IBAction func upvotesButtonTapped(_ sender: UIButton) {
        self.completionUpvotesButtonTapped!()
    }

    @IBAction func usersButtonTapped(_ sender: UIButton) {
        self.completionUsersButtonTapped!()
    }

    @IBAction func commentsButtonTapped(_ sender: UIButton) {
        self.completionCommentsButtonTapped!()
    }

    @IBAction func replyButtonTapped(_ sender: UIButton) {
        self.completionReplyButtonTapped!()
    }

    @IBAction func shareButtonTapped(_ sender: UIButton) {
        self.completionShareButtonTapped!()
    }
}


// MARK: - ConfigureCell
extension PostShowCommentTableViewCell {
    func setup(withItem item: Any?, andIndexPath indexPath: IndexPath) {
        if let comment = item as? Comment {
            self.timeLabel.text = comment.created.convertToDaysAgo()

            // avatar
            self.authorNameButton.setTitle(comment.author, for: .normal)

            // Load markdown content
            DispatchQueue.main.async {
                self.markdownViewManager.load(markdown: comment.body)
            }

            self.markdownViewManager.onRendered = { [weak self] height in
                if self?.markdownViewHeightConstraint.constant == 0.0 {
                    self?.markdownViewHeightConstraint.constant = height
                    self?.layoutIfNeeded()
                    
                    self?.completionCellChangeHeight!(height)
                }
                
                UIView.animate(withDuration: 0.5, animations: {
                    self?.contentView.alpha = 1.0
                })
            }

            // Load author profile image
            if let userProfileImageURL = comment.url {
                self.authorProfileImageButton.uploadImage(byStringPath: userProfileImageURL, size: CGSize(width: 40.0 * widthRatio, height: 40.0 * widthRatio))
            }

            // Set cell level
            // set cellLeadingConstraint
        }
    }
}
