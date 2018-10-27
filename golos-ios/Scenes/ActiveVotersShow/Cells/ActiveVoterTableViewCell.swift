//
//  ActiveVoterTableViewCell.swift
//  Golos
//
//  Created by msm72 on 10/25/18.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift

typealias ActiveVoterShortInfo = (nickName: String, icon: UIImage, isSubscribe: Bool, row: Int)

class ActiveVoterTableViewCell: UITableViewCell {
    // MARK: - Properties
    var cellRow: Int!
    var voterNickName: String!

    // Handlers
    var handlerAuthorVoterTapped: ((String) -> Void)?
    var handlerSubscribeButtonTapped: ((ActiveVoterShortInfo) -> Void)?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var voterProfileImageView: UIImageView!
    
    @IBOutlet weak var voterNameButton: UIButton! {
        didSet {
            self.voterNameButton.tune(withTitle:   "",
                                      hexColors:   [blackWhiteColorPickers, grayWhiteColorPickers, grayWhiteColorPickers, grayWhiteColorPickers],
                                      font:        UIFont(name: "SFProDisplay-Regular", size: 12.0),
                                      alignment:   .left)
            
            self.voterNameButton.isHidden = false
        }
    }

    @IBOutlet weak var voterReputationLabel: UILabel! {
        didSet {
            voterReputationLabel.tune(withText:        "",
                                      hexColors:       whiteColorPickers,
                                      font:            UIFont(name: "SFProDisplay-Medium", size: 6.0),
                                      alignment:       .center,
                                      isMultiLines:    false)
        }
    }

    @IBOutlet weak var subscribeButton: UIButton! {
        didSet {
            self.subscribeButton.tune(withTitle:    "",
                                      hexColors:    [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                                      font:         UIFont(name: "SFProDisplay-Medium", size: 10.0),
                                      alignment:    .center)
            
            self.subscribeButton.isSelected = false
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

//    @IBOutlet var heightsCollection: [NSLayoutConstraint]! {
//        didSet {
//            self.heightsCollection.forEach({ $0.constant *= heightRatio })
//        }
//    }
    
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
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.voterReputationLabel.text      =   nil
        self.voterProfileImageView.image    =   UIImage(named: "icon-user-profile-image-placeholder")
        self.subscribeButton.isHidden       =   false
        self.subscribeButton.isSelected     =   false
        
        self.voterNameButton.setTitle(nil, for: .normal)
        self.subscribeButton.setTitle(nil, for: .normal)
        self.subscribeButton.setBorder(color: UIColor(hexString: "#ffffff").cgColor, cornerRadius: 5.0)
    }
    
    override var reuseIdentifier: String? {
        return ActiveVoterTableViewCell.reuseIdentifier
    }
    
    class var reuseIdentifier: String? {
        return String(describing: self)
    }


    // MARK: - Custom Functions
    func localizeTitles() {
        self.subscribeButton.setTitle((self.subscribeButton.isSelected ? "Subscriptions" : "Subscribe Verb").localized(), for: .normal)
    }
    
    
    // MARK: - Actions
    @IBAction open func authorVoterButtonTapped(_ sender: UIButton) {
        self.handlerAuthorVoterTapped!(self.voterNickName)
    }
    
    @IBAction func subscribeButtonTapped(_ sender: UIButton) {
        self.handlerSubscribeButtonTapped!((nickName: self.voterNickName, icon: self.voterProfileImageView.image!, isSubscribe: sender.isSelected, row: self.cellRow))
    }
    
    @IBAction func voicePowerButtonTapped(_ sender: UIButton) {
    
    }
}


// MARK: - ConfigureCell implementation
extension ActiveVoterTableViewCell {
    func display(activeVoter: Voter, inRow row: Int) {
        self.cellRow = row
        self.voterReputationLabel.text = String(format: "%i", activeVoter.reputation.convertWithLogarithm10())
        
        // API 'get_following'
        RestAPIManager.loadFollowingsList(byUserNickName: User.current!.nickName, authorNickName: activeVoter.voter, pagination: 1, completion: { [weak self] (isFollowing, errorAPI) in
            guard errorAPI == nil else { return }
            
            self?.subscribeButton.isSelected = isFollowing
            
            self?.subscribeButton.setTitle(isFollowing ? "Subscriptions".localized() : "Subscribe Verb".localized(), for: .normal)
            
            isFollowing ?   self?.subscribeButton.setBorder(color: UIColor(hexString: "#dbdbdb").cgColor, cornerRadius: 5.0) :
                            self?.subscribeButton.fill(font: UIFont(name: "SFProDisplay-Medium", size: 10.0)!)
        })

        // Load info about Voter
        if let voter = User.fetch(byNickName: activeVoter.voter) {
            self.voterNickName = voter.nickName
            self.subscribeButton.isHidden = voter.nickName == User.current!.nickName
            self.voterNameButton.setTitle((voter.name == "XXX" || voter.name.isEmpty ? voter.nickName : voter.name).uppercaseFirst, for: .normal)
            
            // Load Voter author profile image
            if let voterProfileImageURL = voter.profileImageURL {
                self.voterProfileImageView.uploadImage(byStringPath:   voterProfileImageURL,
                                                       imageType:      .userProfileImage,
                                                       size:           CGSize(width: 30.0, height: 30.0),
                                                       tags:           nil,
                                                       createdDate:    voter.created.convert(toDateFormat: .expirationDateType),
                                                       fromItem:       (voter as CachedImageFrom).fromItem,
                                                       completion:     { _ in })
            }
            
            else {
                self.voterProfileImageView.image = UIImage(named: "icon-user-profile-image-placeholder")
            }
        }
        
        self.localizeTitles()
    }
}
