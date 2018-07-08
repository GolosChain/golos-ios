//
//  UserProfileInfoView.swift
//  Golos
//
//  Created by msm72 on 08.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//


import GoloSwift
import Foundation

class UserProfileHeaderView: UIView {
    // MARK: - Properties
    var handlerBackButtonTapped: (() -> Void)?
    var handlerEditButtonTapped: (() -> Void)?
    var handlerWriteButtonTapped: (() -> Void)?
    var handlerSettingsButtonTapped: (() -> Void)?
    var handlerSubscribeButtonTapped: (() -> Void)?


    // MARK: - IBOutlets
    @IBOutlet private weak var blurImageView: UIImageView!
    @IBOutlet private weak var avatarImageView: UIImageView!
    
    @IBOutlet private weak var nameLabel: UILabel! {
        didSet {
            nameLabel.font              =   UIFont(name: "SFUIDisplay-Regular", size: 18.0 * widthRatio)
            nameLabel.theme_textColor   =   whiteBlackColorPickers
            nameLabel.textAlignment     =   .left
            nameLabel.numberOfLines     =   1
        }
    }
    
    @IBOutlet weak var whiteStatusBarView: UIView!

    @IBOutlet private weak var voicePowerLabel: UILabel!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var voicePowerImageView: UIImageView!
    @IBOutlet private weak var starsImageView: UIImageView!
    @IBOutlet private weak var activityView: UIActivityIndicatorView!

    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var editProfileButton: UIButton!
    
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
                $0.theme_textColor      =   whiteBlackColorPickers
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
        avatarImageView.layer.masksToBounds = true
        
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
        
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.size.width / 2
    }
    
    
    // MARK: - Custom Functions
    func updateUI(fromUserInfo userInfo: DisplayedUser) {
        self.nameLabel.text                 =   userInfo.name
        self.voicePowerLabel.text           =   userInfo.voicePower
        self.voicePowerImageView.image      =   UIImage(named: userInfo.voicePowerImageName)
        self.starsLabel.text                =   "\(userInfo.postCount)"
        
        if let pictureURL = userInfo.pictureURL {
            GSImageLoader().startLoadImage(with: pictureURL) { [weak self] image in
                guard let strongSelf = self else { return }
                
                let image = image ?? UIImage(named: "avatar_placeholder")
                strongSelf.avatarImageView.image = image
            }
        }
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
