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
    @IBOutlet weak var contentView: UIView!
   
    @IBOutlet weak var closeButton: UIButton! {
        didSet {
            closeButton.setBlueButtonRoundCorners()
            closeButton.setTitle("Thanks understood".localized(), for: .normal)
        }
    }

    @IBOutlet var titlesCollection: [UILabel]! {
        didSet {
            titlesCollection.forEach({
                if $0.tag == 2 {
                    $0.text = (loginType == .postingKey) ?  "Login Help Step Title 3 Posting".localized() :
                        "Login Help Step Title 3 Active".localized()
                }
                
                $0.tune(withAttributedText:     $0.text ?? "XXX",
                        hexColors:              blackWhiteColorPickers,
                        font:                   UIFont(name: "SFProDisplay-Regular", size: 13.0),
                        alignment:              .left,
                        isMultiLines:           true)
            })
        }
    }
    
    
    @IBOutlet weak var wwwAspectRatioConstraint: NSLayoutConstraint! {
        didSet {
            wwwAspectRatioConstraint.constant *= widthRatio
        }
    }
    
    @IBOutlet var topConstraintsCollection: [NSLayoutConstraint]! {
        didSet {
            _ = topConstraintsCollection.map({ $0.constant *= heightRatio })
        }
    }
    
    @IBOutlet var leadingConstraintsCollection: [NSLayoutConstraint]! {
        didSet {
            _ = leadingConstraintsCollection.map({ $0.constant *= widthRatio })
        }
    }
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView.tune()
        contentView.add(shadow: true, onside: .bottom)
    }
    
    
    // MARK: - Actions
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
