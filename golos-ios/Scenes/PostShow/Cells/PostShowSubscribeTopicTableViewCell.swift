//
//  PostShowSubscribeTopicTableViewCell.swift
//  Golos
//
//  Created by msm72 on 02.08.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift

class PostShowSubscribeTopicTableViewCell: UITableViewCell {
    // MARK: - Properties
    var completionButtonTapped: (() -> Void)?

    
    // MARK: - IBOutlets
    @IBOutlet weak var userAvatarImageView: UIImageView!

    @IBOutlet weak var bottomLineView: UIView! {
        didSet {
            bottomLineView.tune(withThemeColorPicker: veryLightGrayColorPickers)
        }
    }
    
    @IBOutlet weak var publishedInLabel: UILabel! {
        didSet {
            publishedInLabel.tune(withText:         "Published in",
                                  hexColors:        darkGrayWhiteColorPickers,
                                  font:             UIFont(name: "SFUIDisplay-Regular", size: 8.0 * widthRatio),
                                  alignment:        .left,
                                  isMultiLines:     false)
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.tune(withText:         "",
                                  hexColors:        darkGrayWhiteColorPickers,
                                  font:             UIFont(name: "SFUIDisplay-Regular", size: 12.0 * widthRatio),
                                  alignment:        .left,
                                  isMultiLines:     false)
        }
    }

    @IBOutlet weak var subscribeButton: UIButton! {
        didSet {
            subscribeButton.tune(withTitle:         "Subscribe",
                                 hexColors:         [veryDarkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                                 font:              UIFont(name: "SFUIDisplay-Medium", size: 10.0 * widthRatio),
                                 alignment:         .center)
            
            subscribeButton.setBorder(color: UIColor(hexString: "#dbdbdb").cgColor, cornerRadius: 4.0 * heightRatio)
        }
    }
    
    @IBOutlet var hightsCollection: [NSLayoutConstraint]! {
        didSet {
            _ = hightsCollection.map({ $0.constant *= heightRatio })
        }
    }
    
    @IBOutlet var widthsCollection: [NSLayoutConstraint]! {
        didSet {
            _ = widthsCollection.map({ $0.constant *= widthRatio })
        }
    }
    
    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        contentView.tune()
    }
    
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    
    
    // MARK: - Actions
    @IBAction func subscribeButtonTapped(_ sender: UIButton) {
        subscribeButton.setBorder(color: UIColor(hexString: "#dbdbdb").cgColor, cornerRadius: 4.0 * heightRatio)
        
        self.completionButtonTapped!()
    }
    
    @IBAction func subscribeButtonTappedDown(_ sender: UIButton) {
        subscribeButton.setBorder(color: UIColor(hexString: "#e3e3e3").cgColor, cornerRadius: 4.0 * heightRatio)
    }
}


// MARK: - ConfigureCell
extension PostShowSubscribeTopicTableViewCell: ConfigureCell {
    func setup(withItem item: Any?, andIndexPath indexPath: IndexPath) {
        if let tag = item as? Tag {
            self.titleLabel.text    =   tag.title
        }
    }
}
