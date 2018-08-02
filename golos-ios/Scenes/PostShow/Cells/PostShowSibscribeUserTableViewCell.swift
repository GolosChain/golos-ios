//
//  PostShowSibscribeUserTableViewCell.swift
//  Golos
//
//  Created by msm72 on 02.08.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift

class PostShowSibscribeUserTableViewCell: UITableViewCell {
    // MARK: - Properties
    var completionButtonTapped: (() -> Void)?

    
    // MARK: - IBOutlets
    @IBOutlet weak var userAvatarImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel! {
        didSet {
            userNameLabel.tune(withText:        "",
                               hexColors:       veryDarkGrayWhiteColorPickers,
                               font:            UIFont(name: "SFUIDisplay-Regular", size: 12.0 * widthRatio), alignment: .left,
                               isMultiLines:    false)
        }
    }
    
    @IBOutlet weak var recentPastLabel: UILabel! {
        didSet {
            recentPastLabel.tune(withText:        "Recent Past:",
                                 hexColors:       darkGrayWhiteColorPickers,
                                 font:            UIFont(name: "SFUIDisplay-Regular", size: 8.0 * widthRatio), alignment: .left,
                                 isMultiLines:    false)
        }
    }
    
    @IBOutlet weak var previouslyLabel: UILabel! {
        didSet {
            previouslyLabel.tune(withText:        "Previously:",
                                 hexColors:       darkGrayWhiteColorPickers,
                                 font:            UIFont(name: "SFUIDisplay-Regular", size: 8.0 * widthRatio), alignment: .left,
                                 isMultiLines:    false)
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
        self.contentView.tune()
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
extension PostShowSibscribeUserTableViewCell: ConfigureCell {
    func setup(withItem item: Any?, andIndexPath indexPath: IndexPath) {
        if let tag = item as? Tag {
            self.userNameLabel.text    =   tag.title
        }
    }
}
