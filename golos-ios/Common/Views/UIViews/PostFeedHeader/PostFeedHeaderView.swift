//
//  PostFeedHeaderView.swift
//  Golos
//
//  Created by msm72 on 10/8/18.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import CoreData
import GoloSwift

class PostFeedHeaderView: UIView {
    // MARK: - Properties
    var handlerAuthorTapped: ((String) -> Void)?
    var handlerReblogAuthorTapped: ((String) -> Void)?

    
    // MARK: - IBOutlets
    @IBOutlet weak var authorProfileImageView: UIImageView!
    
    @IBOutlet var contentView: UIView! {
        didSet {
            self.contentView.tune(withThemeColorPicker: whiteColorPickers)
        }
    }
 
    @IBOutlet weak var timeLabelTopConstraint: NSLayoutConstraint! {
        didSet {
            self.timeLabelTopConstraint.constant = 11.0 * heightRatio
        }
    }
    
    @IBOutlet weak var authorNameButton: UIButton! {
        didSet {
            self.authorNameButton.tune(withTitle:   "",
                                       hexColors:   [blackWhiteColorPickers, grayWhiteColorPickers, grayWhiteColorPickers, grayWhiteColorPickers],
                                       font:        UIFont(name: "SFProDisplay-Bold", size: 12.0),
                                       alignment:   .left)
        }
    }
    
    @IBOutlet weak var rebloggedAuthorButton: UIButton! {
        didSet {
            self.rebloggedAuthorButton.tune(withTitle:      "",
                                            hexColors:      [darkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                                            font:           UIFont(name: "SFProDisplay-Regular", size: 10.0),
                                            alignment:      .left)
            
            self.rebloggedAuthorButton.isHidden = true
        }
    }
    
    @IBOutlet weak var reblogIconButton: UIButton! {
        didSet {
            self.reblogIconButton.isHidden = true
        }
    }
    
    @IBOutlet weak var authorNickNameButton: UIButton! {
        didSet {
            self.authorNickNameButton.tune(withTitle:      "",
                                           hexColors:      [darkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                                           font:           UIFont(name: "SFProDisplay-Regular", size: 10.0),
                                           alignment:      .left)
            
            self.authorNickNameButton.isHidden = false
        }
    }
    
    @IBOutlet weak var categoryLabel: UILabel! {
        didSet {
            self.categoryLabel.tune(withText:        "",
                                    hexColors:       darkGrayWhiteColorPickers,
                                    font:            UIFont(name: "SFProDisplay-Regular", size: 10.0),
                                    alignment:       .left,
                                    isMultiLines:    false)
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            self.timeLabel.tune(withText:        "",
                                hexColors:       darkGrayWhiteColorPickers,
                                font:            UIFont(name: "SFProDisplay-Regular", size: 10.0),
                                alignment:       .right,
                                isMultiLines:    false)
        }
    }
    
    @IBOutlet weak var authorReputationLabel: UILabel! {
        didSet {
            authorReputationLabel.tune(withText:        "",
                                       hexColors:       whiteColorPickers,
                                       font:            UIFont(name: "SFProDisplay-Medium", size: 6.0),
                                       alignment:       .center,
                                       isMultiLines:    false)
        }
    }
    
    @IBOutlet var circleViewsCollection: [UIView]! {
        didSet {
            self.circleViewsCollection.forEach({ $0.layer.cornerRadius = $0.bounds.size.width / 2 * widthRatio })
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

    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createFromXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        createFromXIB()
    }
    
    deinit {
        Logger.log(message: "Success", event: .severe)
    }

    
    // MARK: - Class Functions
    func createFromXIB() {
        Bundle.main.loadNibNamed("PostFeedHeaderView", owner: self, options: nil)
        contentView.fixInView(self)
    }

    
    // MARK: - Custom Functions
    func display(post: PostCellSupport) {
        self.clearValues()
        
        // Set User info
        if let user = User.fetch(byNickName: post.author) {
            self.authorNameButton.setTitle((user.name == "XXX" || user.name.isEmpty ? user.nickName : user.name).uppercaseFirst, for: .normal)
            
            self.timeLabel.text                 =   post.created.convertToDaysAgo(dateFormatType: .expirationDateType)
            self.authorReputationLabel.text     =   String(format: "%i", user.reputation.convertWithLogarithm10())
            
            self.categoryLabel.text = post.category
                                        .transliteration(forPermlink: false)
                                        .uppercaseFirst
            
            Logger.log(message: "category \(self.categoryLabel.text!) frame: \(self.categoryLabel.frame.maxX)", event: .debug)
            Logger.log(message: "timeLabel frame: \(self.timeLabel.frame.minX)", event: .debug)

            if self.categoryLabel.frame.maxX >= (self.timeLabel.frame.minX - 10.0 * widthRatio) {
                self.timeLabelTopConstraint.constant = 28.0 * heightRatio
            } else {
                self.timeLabelTopConstraint.constant = 11.0 * heightRatio
            }
            
            // Load User author profile image
            if let userProfileImageURL = user.profileImageURL {
                self.authorProfileImageView.uploadImage(byStringPath:   userProfileImageURL,
                                                        imageType:      .userProfileImage,
                                                        size:           CGSize(width: 30.0, height: 30.0),
                                                        tags:           nil,
                                                        createdDate:    user.created.convert(toDateFormat: .expirationDateType),
                                                        fromItem:       (user as CachedImageFrom).fromItem,
                                                        completion:     { _ in })
            } else {
                self.authorProfileImageView.image = UIImage(named: "icon-user-profile-image-placeholder")
            }
            
            // Set reblogged user info (default isHidden = true)
            self.reblogIconButton.isHidden      =   true
            self.rebloggedAuthorButton.isHidden =   true
            self.authorNickNameButton.isHidden  =   true

            self.authorNickNameButton.setTitle(user.nickName, for: .normal)
            
            if let rebloggedBy = post.rebloggedBy, rebloggedBy.count > 0 {
                self.reblogIconButton.isHidden      =   false
                self.rebloggedAuthorButton.isHidden =   false
                self.authorNickNameButton.isHidden  =   false
                self.rebloggedAuthorButton.setTitle(rebloggedBy.first ?? "XXX", for: .normal)
            }
        }
    }
    
    private func clearValues() {
        self.reblogIconButton.isHidden          =   true
        self.rebloggedAuthorButton.isHidden     =   true
        
        self.timeLabel.text                     =   nil
        self.categoryLabel.text                 =   nil
        self.authorProfileImageView.image       =   nil
        self.timeLabelTopConstraint.constant    =   11.0 * heightRatio

        self.authorNameButton.setTitle(nil, for: .normal)
        self.authorNickNameButton.setTitle(nil, for: .normal)
        self.rebloggedAuthorButton.setTitle(nil, for: .normal)
    }
    
    
    // MARK: - Actions
    @IBAction open func authorProfileButtonTapped(_ sender: UIButton) {
        self.handlerAuthorTapped!(self.authorNickNameButton.titleLabel!.text!)
    }
    
    @IBAction func rebloggedAuthorNickNameButtonTapped(_ sender: UIButton) {
        self.handlerReblogAuthorTapped!(self.rebloggedAuthorButton.titleLabel!.text!)
    }
}


extension UIView {
    func fixInView(_ container: UIView!) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = container.frame
        
        container.addSubview(self)
        
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
