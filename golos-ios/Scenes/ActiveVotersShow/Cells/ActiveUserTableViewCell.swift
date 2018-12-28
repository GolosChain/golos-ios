//
//  ActiveUserTableViewCell.swift
//  Golos
//
//  Created by msm72 on 10/25/18.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import CoreData
import GoloSwift

typealias ActiveUserShortInfo = (nickName: String, icon: UIImage, isSubscribe: Bool)

class ActiveUserTableViewCell: UITableViewCell {
    // MARK: - Properties
    var userNickName: String!

    // Handlers
    var handlerAuthorVoterTapped: ((String) -> Void)?
    var handlerSubscribeButtonTapped: ((ActiveUserShortInfo) -> Void)?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    @IBOutlet weak var userNameButton: UIButton! {
        didSet {
            self.userNameButton.tune(withTitle:   "",
                                     hexColors:   [blackWhiteColorPickers, grayWhiteColorPickers, grayWhiteColorPickers, grayWhiteColorPickers],
                                     font:        UIFont(name: "SFProDisplay-Regular", size: 12.0),
                                     alignment:   .left)
            
            self.userNameButton.isHidden = false
        }
    }

    @IBOutlet weak var userReputationLabel: UILabel! {
        didSet {
            self.userReputationLabel.tune(withText:        "",
                                          hexColors:       whiteColorPickers,
                                          font:            UIFont(name: "SFProDisplay-Medium", size: 6.0),
                                          alignment:       .center,
                                          isMultiLines:    false)
        }
    }

    @IBOutlet weak var subscribeButton: UIButton! {
        didSet {
            self.subscribeButton.tune(withTitle:    "Subscriptions".localized(),
                                      hexColors:    [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                                      font:         UIFont(name: "SFProDisplay-Medium", size: 10.0),
                                      alignment:    .center)
            
            self.subscribeButton.isSelected = false
            self.subscribeButton.setBorder(color: UIColor(hexString: "#dbdbdb").cgColor, cornerRadius: 5.0)
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

    @IBOutlet weak var subscribeActivityIndicator: UIActivityIndicatorView! {
        didSet {
            self.subscribeActivityIndicator.stopAnimating()
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
    

    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Custom Functions
    func localizeTitles() {
        self.subscribeButton.setTitle((self.subscribeButton.isSelected ? "Subscriptions" : "Subscribe Verb").localized(), for: .normal)
    }
    
    
    // MARK: - Actions
    @IBAction open func authorVoterButtonTapped(_ sender: UIButton) {
        self.handlerAuthorVoterTapped!(self.userNickName)
    }
    
    @IBAction func subscribeButtonTapped(_ sender: UIButton) {
        self.handlerSubscribeButtonTapped!((nickName: self.userNickName, icon: self.userProfileImageView.image!, isSubscribe: sender.isSelected))
    }
    
    @IBAction func voicePowerButtonTapped(_ sender: UIButton) {
    
    }
}


// MARK: - ConfigureCell implementation
extension ActiveUserTableViewCell {
    func display(author: UserCellSupport) {
        self.userReputationLabel.text = String(format: "%i", author.reputationValue.convertWithLogarithm10())
        
        // API 'get_following'
        if !User.isAnonymous {
            RestAPIManager.loadFollowing(byUserNickName: User.current!.nickName, authorNickName: author.nickNameValue, pagination: 1, completion: { [weak self] (isFollowing, errorAPI) in
                guard let strongSelf = self else {return}

                guard errorAPI == nil else { return }
                
                strongSelf.subscribeButton.isSelected = isFollowing
                
                strongSelf.subscribeButton.setTitle(isFollowing ? "Subscriptions".localized() : "Subscribe Verb".localized(), for: .normal)
                
                isFollowing ?   strongSelf.subscribeButton.setBorder(color: UIColor(hexString: AppSettings.isAppThemeDark ? "#ffffff" : "#dbdbdb").cgColor, cornerRadius: 5.0) :
                                strongSelf.subscribeButton.fill(font: UIFont(name: "SFProDisplay-Medium", size: 10.0)!)
            })
        }
        
        // Load info about Author
        if let user = User.fetch(byNickName: author.nickNameValue) {
            self.userNickName = user.nickName
            self.subscribeButton.isHidden = (User.isAnonymous ? false : (author.nickNameValue == User.current!.nickName))
            self.userNameButton.setTitle(author.nameValue.uppercaseFirst, for: .normal)

            // Load Author profile image
            if let userProfileImageURL = user.profileImageURL {
                self.userProfileImageView.uploadImage(byStringPath:   userProfileImageURL,
                                                      imageType:      .userProfileImage,
                                                      size:           CGSize(width: 30.0, height: 30.0),
                                                      tags:           nil,
                                                      createdDate:    user.created.convert(toDateFormat: .expirationDateType),
                                                      fromItem:       (user as CachedImageFrom).fromItem,
                                                      completion:     { _ in })
            }
                
            else {
                self.userProfileImageView.image = UIImage(named: "icon-user-profile-image-placeholder")
            }
        }
        
        else {
            RestAPIManager.loadUsersInfo(byNickNames: [author.nickNameValue], completion: { [weak self] errorAPI in
                guard let strongSelf = self else { return }
                
                guard errorAPI == nil else { return }
                
                strongSelf.userNameButton.setTitle(author.nickNameValue.uppercaseFirst, for: .normal)
                strongSelf.display(author: author)
            })
        }
        
        self.localizeTitles()
    }
}
