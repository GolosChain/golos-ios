//
//  UserVoteTableViewCell.swift
//  Golos
//
//  Created by msm72 on 10/25/18.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift

class UserVoteTableViewCell: UITableViewCell {
    // MARK: - Properties
    
    // Handlers
    var handlerSubscribeButtonTapped: ((Bool) -> Void)?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var authorProfileImageView: UIImageView!
    
    @IBOutlet weak var authorNameButton: UIButton! {
        didSet {
            self.authorNameButton.tune(withTitle:   "",
                                       hexColors:   [blackWhiteColorPickers, grayWhiteColorPickers, grayWhiteColorPickers, grayWhiteColorPickers],
                                       font:        UIFont(name: "SFProDisplay-Regular", size: 12.0),
                                       alignment:   .left)

            self.authorNameButton.isHidden = false
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

    @IBOutlet weak var subscribeButton: UIButton! {
        didSet {
            self.subscribeButton.isHidden = User.isAnonymous
        }
    }
    
    @IBOutlet weak var voicePowerButton: UIButton! {
        didSet {
            self.voicePowerButton.tune(withTitle:   "",
                                       hexColors:   [blackWhiteColorPickers, grayWhiteColorPickers, grayWhiteColorPickers, grayWhiteColorPickers],
                                       font:        UIFont(name: "SFProDisplay-Regular", size: 10.0),
                                       alignment:   .left)

            self.voicePowerButton.isHidden = true
        }
    }

    
    @IBOutlet var circleViewsCollection: [UIView]! {
        didSet {
            self.circleViewsCollection.forEach({ $0.layer.cornerRadius = $0.bounds.size.width / 2 * widthRatio })
        }
    }

    @IBOutlet var heightsCollection: [NSLayoutConstraint]! {
        didSet {
            self.heightsCollection.forEach({ $0.constant *= heightRatio })
        }
    }
    
    @IBOutlet var widthsCollection: [NSLayoutConstraint]! {
        didSet {
            self.widthsCollection.forEach({ $0.constant *= widthRatio })
        }
    }
    

    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    
    
    // MARK: - Reuse identifier
    override var reuseIdentifier: String? {
        return UserVoteTableViewCell.reuseIdentifier
    }
    
    class var reuseIdentifier: String? {
        return String(describing: self)
    }


    // MARK: - Custom Functions
    func localizeTitles() {
        self.subscribeButton.setTitle((self.subscribeButton.tag == 0 ? "Subscribe Verb" : "Subscriptions").localized(), for: .normal)
    }
    
    // MARK: - Actions
    @IBAction open func authorProfileButtonTapped(_ sender: UIButton) {

    }
    
    @IBAction func subscribeButtonTapped(_ sender: UIButton) {
        self.handlerSubscribeButtonTapped!(sender.tag == 0)
    }
    
    @IBAction func authorNameButtonTapped(_ sender: UIButton) {
    
    }
    
    @IBAction func voicePowerButtonTapped(_ sender: UIButton) {
    
    }
}


// MARK: - ConfigureCell implementation
extension UserVoteTableViewCell {
    func display(user: User) {
        self.authorReputationLabel.text = String(format: "%i", user.reputation.convertWithLogarithm10())
        self.authorNameButton.setTitle((user.name == "XXX" || user.name.isEmpty ? user.nickName : user.name).uppercaseFirst, for: .normal)
        
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

        self.localizeTitles()
    }
}
