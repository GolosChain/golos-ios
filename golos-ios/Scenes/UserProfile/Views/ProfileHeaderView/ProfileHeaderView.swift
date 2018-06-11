//
//  ProfileHeaderView.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 23/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

protocol ProfileHeaderViewDelegate: class {
    func didPressEditProfileButton()
    func didPressSettingsButton()
    func didPressSubsribeButton()
    func didPressSendMessageButton()
    func didPressBackButton()
}

class ProfileHeaderView: PassthroughView {
    // MARK: - Size properties
    var minimizedHeaderHeight: CGFloat = 0

    
    // MARK: - Setter properties
    var backgroundImage: UIImage? {
        didSet {
            updateBackground()
        }
    }
    
    var name: String? {
        get {
            return nameLabel.text
        }
        set {
            nameLabel.text = newValue
        }
    }
    
    var starsAmountString: String? {
        get {
            return starsLabel.text
        }
        set {
            starsLabel.text = newValue
        }
    }
    
    var rankString: String? {
        get {
            return rankLabel.text
        }
        set {
            rankLabel.text = newValue
        }
    }
    
    var avatarImage: UIImage? {
        didSet {
            self.avatarImageView.image = avatarImage
        }
    }
    
    var isEdit = false {
        didSet {
            showBackButton(!isEdit)
        }
    }
    
    
    // MARK: - IBOutlets
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var blurImageView: UIImageView!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var starsImageView: UIImageView!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var rankLabel: UILabel!
    @IBOutlet private weak var rankImageVIew: UIImageView!
    @IBOutlet private weak var subscribeButton: UIButton!
    @IBOutlet private weak var sendMessageButton: UIButton!
    @IBOutlet private weak var activityView: UIActivityIndicatorView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var editProfileButton: UIButton!
    @IBOutlet private weak var imageViewTopConstraint: NSLayoutConstraint!
    
    
    // MARK: - Delegate
    weak var delegate: ProfileHeaderViewDelegate?
    
    
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
        let nib = UINib(nibName: String(describing: ProfileHeaderView.self), bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        setupUI()
    }
    
    
    // MARK: - Setup UI
    private func setupUI() {
        avatarImageView.layer.masksToBounds = true
        
        backgroundColor = .white
        blurImageView.alpha = 0
        
        subscribeButton.setProfileHeaderButton()
        sendMessageButton.setProfileHeaderButton()
    }
    
    func showBackButton(_ showBackButton: Bool) {
        backButton.isHidden = !showBackButton
        editProfileButton.isHidden = showBackButton
    }
    
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.size.width / 2
    }
    
    
    // MARK: - Background images
    private func updateBackground() {
        backgroundImageView.image = backgroundImage
        blurImageView.image = backgroundImage?.applyBlurWithRadius(10.0,
                                                                   tintColor: nil,
                                                                   saturationDeltaFactor: 1.0)
    }
    
    func didChangeOffset(_ offset: CGFloat) {
        if offset + minimizedHeaderHeight < 0 {
            imageViewTopConstraint.constant = offset + minimizedHeaderHeight
        }

        blurImageView.alpha = -((offset + minimizedHeaderHeight) / 100)
    }

    
    // MARK: - Activity
    func startLoading() {
        activityView.startAnimating()
    }
    
    func stopLoading() {
        activityView.stopAnimating()
    }
    
    
    // MARK: - Actions
    @IBAction func editButtonPressed(_ sender: Any) {
        delegate?.didPressEditProfileButton()
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        delegate?.didPressSettingsButton()
    }
    
    @IBAction func subscribeButtonPressed(_ sender: Any) {
        delegate?.didPressSubsribeButton()
    }
    
    @IBAction func sendMessageButtonPressed(_ sender: Any) {
        delegate?.didPressSendMessageButton()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        delegate?.didPressBackButton()
    }
}
