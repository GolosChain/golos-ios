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


class ProfileHeaderView: UIView {

    //MARK: Setter properties
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
            nameLabel.text = name
        }
    }
    
    var starsAmountString: String? {
        get {
            return starsLabel.text
        }
        set {
            starsLabel.text = name
        }
    }
    
    var dolphinString: String? {
        get {
            return dolphinLabel.text
        }
        set {
            dolphinLabel.text = name
        }
    }
    
    var avatarImageUrlString: String? {
        return nil
    }
    
    
    //MARK: Outlet properties
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var blurImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starsImageView: UIImageView!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var dolphinLabel: UILabel!
    @IBOutlet weak var dolphinImageVIew: UIImageView!
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    
    
    //MARK: Delegate
    weak var delegate: ProfileHeaderViewDelegate?
    
    
    //MARK: Init
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
    
    
    //MARK: Setup UI
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
    
    
    //MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.size.width / 2
    }
    
    
    //MARK: Background images
    private func updateBackground() {
        backgroundImageView.image = backgroundImage
        blurImageView.image = backgroundImage?.applyBlurWithRadius(10.0,
                                                                   tintColor: nil,
                                                                   saturationDeltaFactor: 1.0)
    }
    
    func setBlurViewAlpha(_ alpha: CGFloat) {
        blurImageView.alpha = alpha
    }
    
    
    //MARK: Activity
    func startLoading() {
        activityView.startAnimating()
    }
    
    func stopLoading() {
        activityView.stopAnimating()
    }
    
    
    //MARK: Actions
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
