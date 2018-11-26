//
//  LoginHelpShowViewController.swift
//  Golos
//
//  Created by Grigory on 02/03/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class LogInHelpShowViewController: GSBaseViewController {
    // MARK: - Properties
    var loginType: LoginType = .postingKey
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var contentView: UIView! {
        didSet {
            self.contentView.layer.cornerRadius = 12.0 * heightRatio
            self.contentView.clipsToBounds = true
        }
    }
   
    @IBOutlet weak var websiteButton: UIButton! {
        didSet {
            self.websiteButton.tune()
            self.websiteButton.setTitle("Website Help Title Link".localized(), for: .normal)
            self.websiteButton.setTitleColor(UIColor(hexString: "#2F7DFB"), for: .normal)
            self.websiteButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 14.0)
        }
    }
    
    @IBOutlet weak var closeButton: UIButton! {
        didSet {
            self.closeButton.tune()
            self.closeButton.setTitle("Close Verb".localized(), for: .normal)
            self.closeButton.setTitleColor(UIColor(hexString: "#2F7DFB"), for: .normal)
            self.closeButton.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 18.0)
        }
    }

    @IBOutlet var titlesCollection: [UILabel]! {
        didSet {
            titlesCollection.forEach({
                if $0.tag == 2 {
                    $0.text = (loginType == .postingKey) ?  "Keys Help Posting Title".localized() : "Keys Help Active Title".localized()
                }
                
                $0.tune(withAttributedText:     $0.text ?? "XXX",
                        hexColors:              blackWhiteColorPickers,
                        font:                   UIFont(name: "SFProDisplay-Regular", size: 14.0),
                        alignment:              .left,
                        isMultiLines:           true)
            })
        }
    }
    
    @IBOutlet var numbersLabelsCollection: [UILabel]! {
        didSet {
            self.numbersLabelsCollection.forEach({
                $0.tune(withAttributedText:     $0.text!,
                        hexColors:              blackWhiteColorPickers,
                        font:                   UIFont(name: "SFProDisplay-Bold", size: 14.0),
                        alignment:              .left,
                        isMultiLines:           false)
            })
        }
    }
    
    @IBOutlet var topConstraintsCollection: [NSLayoutConstraint]! {
        didSet {
            self.topConstraintsCollection.forEach({ $0.constant *= heightRatio })
        }
    }
    
    @IBOutlet var leadingConstraintsCollection: [NSLayoutConstraint]! {
        didSet {
            self.leadingConstraintsCollection.forEach({ $0.constant *= widthRatio })
        }
    }
        
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView.tune()
    }
    
    
    // MARK: - Actions
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func websiteButtonTapped(_ sender: UIButton) {
        self.openExternalLink(byURL: "https://golos.io/welcome")
    }
}
