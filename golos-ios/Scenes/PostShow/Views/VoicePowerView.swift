//
//  VoicePowerView.swift
//  Golos
//
//  Created by msm72 on 10/11/18.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift
import Localize_Swift

class VoicePowerView: UIView {
    // MARK: - Properties
    var handlerActionButtonTapped: ((Bool) -> Void)?
    
    
    // MARK: - IBOutlets
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var contentView: UIView! {
        didSet {
            self.contentView.tune(withThemeColorPicker: whiteColorPickers)
            
            self.contentView.layer.cornerRadius = 8.0
            self.clipsToBounds = true
        }
    }

    @IBOutlet weak var blackOutView: UIView! {
        didSet {
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            self.titleLabel.tune(withText:      "",
                                 hexColors:     blackWhiteColorPickers,
                                 font:          UIFont(name: "SFProDisplay-Regular", size: 15.0),
                                 alignment:     .center,
                                 isMultiLines:  false)
        }
    }
    
    @IBOutlet weak var subtitleLabel: UILabel! {
        didSet {
            self.subtitleLabel.tune(withText:       "",
                                    hexColors:      veryDarkGrayWhiteColorPickers,
                                    font:           UIFont(name: "SFProDisplay-Regular", size: 12.0),
                                    alignment:      .left,
                                    isMultiLines:   true)
        }
    }
    
    @IBOutlet var labelsCollection: [UILabel]! {
        didSet {
            self.labelsCollection.forEach({ $0.tune(withText:       "",
                                                    hexColors:      veryDarkGrayWhiteColorPickers,
                                                    font:           UIFont(name: "SFProDisplay-Regular", size: 12.0),
                                                    alignment:      .left,
                                                    isMultiLines:   true)})
        }
    }
    
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            self.cancelButton.tune(withTitle:   "",
                                   hexColors:   [redWhiteColorPickers, grayWhiteColorPickers, grayWhiteColorPickers, grayWhiteColorPickers],
                                   font:        UIFont(name: "SFProDisplay-Medium", size: 14.0),
                                   alignment:   .center)
        }
    }
    
    @IBOutlet weak var voteButton: UIButton! {
        didSet {
            self.voteButton.tune(withTitle:   "",
                                 hexColors:   [blueWhiteColorPickers, grayWhiteColorPickers, grayWhiteColorPickers, grayWhiteColorPickers],
                                 font:        UIFont(name: "SFProDisplay-Medium", size: 14.0),
                                 alignment:   .center)
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

    
    // MARK: - Custom Functions
    func createFromXIB() {
        UINib(nibName: String(describing: VoicePowerView.self), bundle: Bundle(for: VoicePowerView.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = frame
        
        self.alpha = 0.0

        self.localizeTitles()
    }

    /// Set titles with support App language
    private func localizeTitles() {
        self.titleLabel.text    =   "Voice Power Title".localized()
        self.subtitleLabel.text =   "Voice Power Subtitle".localized()
        
        self.labelsCollection.forEach({ $0.text = $0.accessibilityIdentifier!.localized() })
        
        self.voteButton.setTitle("Vote Verb".localized(), for: .normal)
        self.cancelButton.setTitle("Cancel Title".localized(), for: .normal)
    }

    func display() {
        self.frame.size = UIScreen.main.bounds.size

        UIApplication.shared.keyWindow!.addSubview(self)
        UIApplication.shared.keyWindow!.bringSubviewToFront(self)
        
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1.0
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0.0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
    
    // MARK: - Actions
    @IBAction func voteButtonTapped(_ sender: UIButton) {
        self.handlerActionButtonTapped!(true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.handlerActionButtonTapped!(false)
    }
}
