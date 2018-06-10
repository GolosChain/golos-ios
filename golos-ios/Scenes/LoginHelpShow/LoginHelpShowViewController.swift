//
//  LoginHelpShowViewController.swift
//  Golos
//
//  Created by Grigory on 02/03/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class LoginHelpShowViewController: BaseViewController {
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
            _ = titlesCollection.map({
                    $0.tune(withAttributedText:     $0.text ?? "Zorro",
                            hexColors:              blackWhiteColorPickers,
                            font:                   UIFont(name: "SFProDisplay-Regular", size: 13.0 * widthRatio),
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
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView.tune()
        contentView.addBottomShadow()
    }
    
    
    // MARK: - Actions
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
