//
//  PostFeedHeaderView.swift
//  Golos
//
//  Created by Grigory on 29/01/2018.
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

    @IBOutlet weak var contentView: UIView! {
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
            _ = circleViewsCollection.map({ $0.layer.cornerRadius = $0.bounds.size.width / 2 * widthRatio })
        }
    }
    
    @IBOutlet var widthsCollection: [NSLayoutConstraint]! {
        didSet {
            _ = widthsCollection.map({ $0.constant *= widthRatio })
        }
    }
    
    @IBOutlet var heightsCollection: [NSLayoutConstraint]! {
        didSet {
            _ = heightsCollection.map({ $0.constant *= heightRatio })
        }
    }
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    
    private func commonInit() {
        backgroundColor = .clear
        
        let nib     =   UINib(nibName: String(describing: PostFeedHeaderView.self), bundle: nil)
        let view    =   nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints                  =   false
        view.topAnchor.constraint(equalTo: topAnchor).isActive          =   true
        view.rightAnchor.constraint(equalTo: rightAnchor).isActive      =   true
        view.leftAnchor.constraint(equalTo: leftAnchor).isActive        =   true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive    =   true
    }

    
    // MARK: - Layouts
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    
    // MARK: - Class Functions
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 300.0 * widthRatio, height: 46.0 * heightRatio)
    }
    
    
    // MARK: - Custom Functions
    func display(post: PostCellSupport) {
        // Set User info
        if let user = User.fetch(byNickName: post.author) {
            self.authorNickNameButton.setTitle(user.nickName, for: .normal)
            self.authorNameButton.setTitle((user.name == "XXX" || user.name.isEmpty ? user.nickName : user.name).uppercaseFirst, for: .normal)

            self.timeLabel.text             =   post.created.convertToDaysAgo(dateFormatType: .expirationDateType)
            self.authorReputationLabel.text =   String(format: "%i", user.reputation.convertWithLogarithm10())
            
            self.categoryLabel.text = post.category
                                        .transliteration(forPermlink: false)
                                        .uppercaseFirst
           
            // Load User author profile image
            if let userProfileImageURL = user.profileImageURL {
                self.authorProfileImageView.uploadImage(byStringPath:   userProfileImageURL,
                                                        imageType:      .userProfileImage,
                                                        size:           CGSize(width: 30.0, height: 30.0),
                                                        tags:           nil,
                                                        createdDate:    user.created.convert(toDateFormat: .expirationDateType),
                                                        fromItem:       (user as CachedImageFrom).fromItem)
            }            
        }
        
        // Set reblogged user info (default isHidden = true)
        if let rebloggedBy = post.rebloggedBy, rebloggedBy.count > 0 {
            self.reblogIconButton.isHidden      =   false
            self.rebloggedAuthorButton.isHidden =   false
            self.rebloggedAuthorButton.setTitle(rebloggedBy.first ?? "XXX", for: .normal)
        }
    }
    
    
    // MARK: - Actions
    @IBAction open func authorProfileButtonTapped(_ sender: UIButton) {
        self.handlerAuthorTapped!(self.authorNickNameButton.titleLabel!.text!)
    }
    
    @IBAction func rebloggedAuthorNickNameButtonTapped(_ sender: UIButton) {
        self.handlerReblogAuthorTapped!(sender.titleLabel!.text!)
    }
}
