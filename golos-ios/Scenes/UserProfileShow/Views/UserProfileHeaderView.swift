//
//  UserProfileInfoView.swift
//  Golos
//
//  Created by msm72 on 08.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//


import GoloSwift
import Foundation

class UserProfileHeaderView: PassthroughView {
    // MARK: - Properties
    var handlerBackButtonTapped: (() -> Void)?
    var handlerEditButtonTapped: (() -> Void)?
    var handlerWriteButtonTapped: (() -> Void)?
    var handlerSettingsButtonTapped: (() -> Void)?
    var handlerSubscribeButtonTapped: (() -> Void)?


    // MARK: - IBOutlets
    @IBOutlet weak var userCoverImageView: UIImageView!
    @IBOutlet private weak var blurImageView: UIImageView!
    
    @IBOutlet private weak var userProfileImageView: UIImageView! {
        didSet {
            userProfileImageView.layer.cornerRadius = userProfileImageView.bounds.size.width / 2 * widthRatio
        }
    }
    
    @IBOutlet private weak var nameLabel: UILabel! {
        didSet {
            nameLabel.tune(withText:        "",
                           hexColors:       blackWhiteColorPickers,
                           font:            UIFont(name: "SFUIDisplay-Regular", size: 18.0 * widthRatio),
                           alignment:       .left,
                           isMultiLines:    false)
        }
    }
    
    @IBOutlet weak var whiteStatusBarView: UIView!

    @IBOutlet private weak var voicePowerLabel: UILabel!
    @IBOutlet private weak var reputationLabel: UILabel!
    @IBOutlet private weak var voicePowerImageView: UIImageView!
    @IBOutlet private weak var reputationImageView: UIImageView!
    @IBOutlet private weak var activityView: UIActivityIndicatorView!

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet private weak var settingsButton: UIButton!
    
    @IBOutlet var actionButtonsCollection: [UIButton]! {
        didSet {
            _ = actionButtonsCollection.map({
                $0.titleLabel?.font             =   UIFont(name: "SFUIDisplay-Regular", size: 12.0 * widthRatio)!
                $0.titleLabel?.textAlignment    =   .center
                $0.setTitle($0.titleLabel?.text?.localized(), for: .normal)
                $0.theme_setTitleColor(veryDarkGrayWhiteColorPickers, forState: .normal)
                $0.setProfileHeaderButton()
            })
        }
    }
    
    @IBOutlet var labelsCollection: [UILabel]! {
        didSet {
            _ = labelsCollection.map({
                $0.text?.localize()
                $0.font                 =   UIFont(name: "SFUIDisplay-Regular", size: 12.0 * widthRatio)
                $0.theme_textColor      =   blackWhiteColorPickers
                $0.textAlignment        =   .left
                $0.numberOfLines        =   1
            })
        }
    }
    
    @IBOutlet private weak var imageViewTopConstraint: NSLayoutConstraint!
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        let nib     =   UINib(nibName: String(describing: UserProfileHeaderView.self), bundle: nil)
        let view    =   nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints                  =   false
        view.topAnchor.constraint(equalTo: topAnchor).isActive          =   true
        view.rightAnchor.constraint(equalTo: rightAnchor).isActive      =   true
        view.leftAnchor.constraint(equalTo: leftAnchor).isActive        =   true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive    =   true
        
        setupUI()
    }
    
    
    // MARK: - Setup UI
    private func setupUI() {
        userProfileImageView.layer.masksToBounds = true
        
        backgroundColor         =   .white
        blurImageView.alpha     =   0
    }
    
    func showBackButton(_ isShow: Bool) {
        backButton.isHidden         =   !isShow
        editProfileButton.isHidden  =   isShow
    }
    
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    // MARK: - Custom Functions
    func updateUI(fromUserInfo userInfo: User) {
        self.nameLabel.text                 =   userInfo.name
        self.voicePowerLabel.text           =   userInfo.voicePower.introduced().localized()
        self.voicePowerImageView.image      =   UIImage(named: String(format: "icon-voice-power-%@", userInfo.voicePower.introduced().lowercased()))

        // Reputation -> Int
        self.reputationLabel.text           =   String(format: "%i", userInfo.reputation.convertWithLogarithm10())
        
        // Upload User profile image
        if let userProfileImageURL = userInfo.profileImageURL {
            self.userProfileImageView.uploadImage(byStringPath:     userProfileImageURL,
                                                  imageType:        .userProfileImage,
                                                  size:             CGSize(width: 80.0 * widthRatio, height: 80.0 * widthRatio),
                                                  tags:             nil)
        }
        
        // Upload User cover image
        if let userCoverImagePath = userInfo.coverImageURL {
            // Set white color for existing cover image
            _ = labelsForAnimationCollection.map({ $0.theme_textColor = whiteBlackColorPickers })
            
            self.editProfileButton.setImage(UIImage(named: "icon-button-edit-white-normal"), for: .normal)
            self.editProfileButton.setImage(UIImage(named: "icon-button-edit-black-normal"), for: .highlighted)
            self.settingsButton.setImage(UIImage(named: "icon-button-settings-white-normal"), for: .normal)
            self.settingsButton.setImage(UIImage(named: "icon-button-settings-black-normal"), for: .highlighted)
            self.backButton.setImage(UIImage(named: "icon-button-back-white-normal"), for: .normal)
            self.backButton.setImage(UIImage(named: "icon-button-back-black-normal"), for: .highlighted)

            self.userCoverImageView.uploadImage(byStringPath:       userCoverImagePath,
                                                imageType:          .userCoverImage,
                                                size:               CGSize(width: 375.0 * widthRatio, height: 240.0 * heightRatio),
                                                tags:               userInfo.selectTags)
            
            self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }
        
        self.showLabelsForAnimationCollection(true)
    }
    
    
    // MARK: - Activity
    func startLoading() {
        activityView.startAnimating()
    }
    
    func stopLoading() {
        activityView.stopAnimating()
    }
    
    
    // MARK: - Actions
    @IBAction func editButtonTapped(_ sender: UIButton) {
        self.handlerEditButtonTapped!()
    }
    
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        self.handlerSettingsButtonTapped!()
    }
    
    @IBAction func subscribeButtonTapped(_ sender: UIButton) {
        self.handlerSubscribeButtonTapped!()
    }
    
    @IBAction func writeButtonTapped(_ sender: UIButton) {
        self.handlerWriteButtonTapped!()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.handlerBackButtonTapped!()
    }
}
