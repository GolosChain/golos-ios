//
//  EmptyCommentTableViewCell.swift
//  Golos
//
//  Created by msm72 on 10/15/18.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class EmptyCommentTableViewCell: UITableViewCell {
    // MARK: - Properties
    var handlerCreateCommentButtonTapped: (() -> Void)?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var createCommentButton: UIButton! {
        didSet {
            self.createCommentButton.tune(withTitle:    "No Comments Title".localized(),
                                          hexColors:    [veryDarkGrayWhiteColorPickers, darkGrayWhiteColorPickers, darkGrayWhiteColorPickers, darkGrayWhiteColorPickers],
                                          font:         UIFont(name: "SFProDisplay-Regular", size: 13.0),
                                          alignment:    .left)
            
            self.contentView.tune()
        }
    }
    
    @IBOutlet var heightsCollection: [NSLayoutConstraint]! {
        didSet {
            self.heightsCollection.forEach({ $0.constant *= heightRatio })
        }
    }
    
    
    // MARK: - Custom Functions
    func translateTitle() {
        self.createCommentButton.setTitle("No Comments Title".localized(), for: .normal)
    }
    
    
    // MARK: - Actions
    @IBAction func createCommentButtonTapped(_ sender: Any) {
        self.handlerCreateCommentButtonTapped!()
    }
}
