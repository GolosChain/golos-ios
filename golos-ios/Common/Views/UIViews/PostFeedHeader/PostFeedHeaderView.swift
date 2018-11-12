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
    var handlerPostAuthorTapped: ((String) -> Void)?

    
    // MARK: - IBOutlets
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var authorProfileImageView: UIImageView!
    
    @IBOutlet var contentView: UIView! {
        didSet {
            self.contentView.tune(withThemeColorPicker: whiteColorPickers)
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
    
    @IBOutlet weak var authorNickNameButton: UIButton! {
        didSet {
            self.authorNickNameButton.tune(withTitle:      "",
                                           hexColors:      [darkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                                           font:           UIFont(name: "SFProDisplay-Regular", size: 10.0),
                                           alignment:      .left)
            
            self.authorNickNameButton.isHidden = true
        }
    }
    
    @IBOutlet weak var reblogIconButton: UIButton! {
        didSet {
            self.reblogIconButton.isHidden = true
        }
    }
    
    @IBOutlet weak var postAuthorNickNameButton: UIButton! {
        didSet {
            self.postAuthorNickNameButton.tune(withTitle:      "",
                                               hexColors:      [darkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                                               font:           UIFont(name: "SFProDisplay-Regular", size: 10.0),
                                               alignment:      .left)
            
            self.postAuthorNickNameButton.isHidden = false
        }
    }
    
    @IBOutlet var categoryLabelCollection: [UILabel]! {
        didSet {
            self.categoryLabelCollection.forEach({ $0.tune(withText:        "",
                                                           hexColors:       darkGrayWhiteColorPickers,
                                                           font:            UIFont(name: "SFProDisplay-Regular", size: 10.0),
                                                           alignment:       .left,
                                                           isMultiLines:    false)})
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
    
    @IBOutlet weak var categoryStackView: UIStackView! {
        didSet {
            self.categoryStackView.isHidden = true
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
    func display(post: PostCellSupport, entry: BlogEntry? = nil) {
        let postAuthorNickName      =   entry == nil ? post.author : entry!.author
        let profileAuthorNickName   =   entry == nil ? (post.rebloggedBy == nil ? post.author : post.rebloggedBy!.first!) : (entry!.author == entry!.blog ? entry!.author : entry!.blog)

        self.clearValues()
        
        // Set User profile info
        if let userProfile = User.fetch(byNickName: profileAuthorNickName) {
            self.authorNameButton.setTitle("sdf sdf sdgf sghgfdhsg fgsdhj gfjhsdg", for: .normal)
//            self.authorNameButton.setTitle(userProfile.name.uppercaseFirst, for: .normal)

            self.timeLabel.text                 =   post.created.convertToTimeAgo()
            self.authorReputationLabel.text     =   String(format: "%i", userProfile.reputation.convertWithLogarithm10())
            
            self.categoryLabelCollection.forEach({ $0.text = post.category.transliteration(forPermlink: false).uppercaseFirst })
            
            // Remove Category to second line
            if self.categoryLabel.frame.width == 0 || CGFloat(self.categoryLabel.text!.count * 4) + self.categoryLabel.frame.maxX >= self.timeLabel.frame.minX + 5.0 {
                self.categoryLabel.isHidden     =   true
                self.categoryImageView.isHidden =   true
                self.categoryStackView.isHidden =   false
            }
            
            // Load User profile avatar image
            if let userProfileImageURL = userProfile.profileImageURL {
                self.authorProfileImageView.uploadImage(byStringPath:   userProfileImageURL,
                                                        imageType:      .userProfileImage,
                                                        size:           CGSize(width: 30.0, height: 30.0),
                                                        tags:           nil,
                                                        createdDate:    userProfile.created.convert(toDateFormat: .expirationDateType),
                                                        fromItem:       (userProfile as CachedImageFrom).fromItem,
                                                        completion:     { _ in })
            }
            
            else {
                self.authorProfileImageView.image = UIImage(named: "icon-user-profile-image-placeholder")
            }
            
            // Set User author post info (default isHidden = true)
            self.reblogIconButton.isHidden          =   true
            self.postAuthorNickNameButton.isHidden  =   true
            self.authorNickNameButton.isHidden      =   true

            self.authorNickNameButton.setTitle(profileAuthorNickName, for: .normal)
            
            switch type(of: post) == Blog.self {
            // Blog
            case true:
                if profileAuthorNickName != postAuthorNickName {
                    self.setPostAuthor(byNickName: postAuthorNickName)
                }
                
            // Lenta and other
            default:
                if profileAuthorNickName != postAuthorNickName {
                    self.setPostAuthor(byNickName: postAuthorNickName)
                }
            }
        }
    }
    
    private func setPostAuthor(byNickName nickName: String) {
        self.reblogIconButton.isHidden                  =   false
        self.postAuthorNickNameButton.isHidden          =   false
        self.authorNickNameButton.isHidden              =   false
        
        self.postAuthorNickNameButton.setTitle(nickName, for: .normal)
    }
    
    private func clearValues() {
        self.reblogIconButton.isHidden                  =   true
        self.postAuthorNickNameButton.isHidden          =   true
        
        self.timeLabel.text                             =   nil
        self.categoryLabel.text                         =   nil
        self.authorProfileImageView.image               =   nil
        
        self.authorNameButton.setTitle(nil, for: .normal)
        self.authorNickNameButton.setTitle(nil, for: .normal)
        self.postAuthorNickNameButton.setTitle(nil, for: .normal)
    }
    
    
    // MARK: - Actions
    @IBAction open func profileAuthorButtonTapped(_ sender: UIButton) {
        self.handlerAuthorTapped!(self.authorNickNameButton.titleLabel!.text!)
    }
    
    @IBAction func postAuthorNickNameButtonTapped(_ sender: UIButton) {
        self.handlerPostAuthorTapped!(self.postAuthorNickNameButton.titleLabel!.text!)
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
