//
//  PostShowCommentTableViewCell.swift
//  Golos
//
//  Created by msm72 on 05.08.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import CoreData
import GoloSwift

class PostShowCommentTableViewCell: UITableViewCell {
    // MARK: - Properties
    var completionAuthorNameButtonTapped: (() -> Void)?
    var completionAuthorProfileAddButtonTapped: (() -> Void)?
    var completionAuthorProfileImageButtonTapped: (() -> Void)?

    
    // MARK: - IBOutlets
    @IBOutlet weak var authorProfileImageButton: UIButton! {
        didSet {
            authorProfileImageButton.layer.cornerRadius = 40.0 * heightRatio / 2
        }
    }
    
    @IBOutlet weak var authorProfileAddButton: UIButton! {
        didSet {
            authorProfileAddButton.layer.cornerRadius = 18.0 * heightRatio / 2
        }
    }
    
    @IBOutlet weak var authorNameButton: UIButton! {
        didSet {
            authorNameButton.tune(withTitle:    "",
                                  hexColors:    [darkGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers, lightGrayWhiteColorPickers],
                                  font:         UIFont(name: "SFUIDisplay-Regular", size: 10.0 * widthRatio),
                                  alignment:    .left)
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.tune(withText:            "",
                           hexColors:           darkGrayWhiteColorPickers,
                           font:                UIFont(name: "SFUIDisplay-Regular", size: 10.0 * widthRatio),
                           alignment:           .left,
                           isMultiLines:        false)
        }
    }
    
    @IBOutlet weak var commentLabel: UILabel! {
        didSet {
            commentLabel.tune(withText:         "",
                              hexColors:        veryDarkGrayWhiteColorPickers,
                              font:             UIFont(name: "SFUIDisplay-Regular", size: 10.0 * widthRatio),
                              alignment:        .left,
                              isMultiLines:     true)
        }
    }
    
    @IBOutlet var heightsCollection: [NSLayoutConstraint]! {
        didSet {
            _ = heightsCollection.map({ $0.constant *= heightRatio })
        }
    }
    
    @IBOutlet var widthsCollection: [NSLayoutConstraint]! {
        didSet {
            _ = widthsCollection.map({ $0.constant *= heightRatio })
        }
    }
    
    @IBOutlet weak var cellLeadingConstraint: NSLayoutConstraint!
    

    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.tune()
    }

    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    
    
    // MARK: - Actions
    @IBAction func authorProfileImageButtonTapped(_ sender: UIButton) {
        self.completionAuthorProfileImageButtonTapped!()
    }
    
    @IBAction func authorProfileAddButtonTapped(_ sender: UIButton) {
        self.completionAuthorProfileAddButtonTapped!()
    }
    
    @IBAction func authorNameButtonTapped(_ sender: UIButton) {
        self.completionAuthorNameButtonTapped!()
    }
}


// MARK: - ConfigureCell
extension PostShowCommentTableViewCell: ConfigureCell {
    func setup(withItem item: Any?, andIndexPath indexPath: IndexPath) {
        if var title = item as? String {

        }
        
        // set cellLeadingConstraint
    }
}
