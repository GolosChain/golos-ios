//
//  ProfileInfoView.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 24/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift
import SwiftTheme

class UserProfileInfoTitleView: PassthroughView {
    // MARK: - IBOutlets
    @IBOutlet private weak var postsCountLabel: UILabel!
    @IBOutlet private weak var followerCountLabel: UILabel!
    @IBOutlet private weak var followingCountLabel: UILabel!
    
    @IBOutlet weak var aboutLabelView: UIView! {
        didSet {
            aboutLabelView.isHidden = true
        }
    }
    
    @IBOutlet private weak var aboutLabel: UILabel! {
        didSet {
            aboutLabel.font               =   UIFont(name: "SFUIDisplay-Regular", size: 13.0 * widthRatio)
            aboutLabel.theme_textColor    =   veryDarkGrayWhiteColorPickers
            aboutLabel.textAlignment      =   .left
            aboutLabel.numberOfLines      =   0
        }
    }

    @IBOutlet var labelsCollection: [UILabel]! {
        didSet {
            _ = labelsCollection.map({
                $0.text?.localize()
                $0.font                         =   UIFont(name: "SFUIDisplay-Regular", size: 12.0 * widthRatio)
                $0.theme_textColor              =   darkGrayWhiteColorPickers
                $0.textAlignment                =   .left
                $0.numberOfLines                =   1
            })
        }
    }

    @IBOutlet var valuesCollection: [UILabel]! {
        didSet {
            _ = valuesCollection.map({
                $0.font                         =   UIFont(name: "SFUIDisplay-Regular", size: 16.0 * widthRatio)
                $0.theme_textColor              =   veryDarkGrayWhiteColorPickers
                $0.textAlignment                =   .left
                $0.numberOfLines                =   1
            })
        }
    }

    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            stackViewHeightConstraint.constant *= heightRatio
        }
    }
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    
    // MARK: - Custom Functions
    private func commonInit() {
        let nib     =   UINib(nibName: String(describing: UserProfileInfoTitleView.self), bundle: nil)
        let view    =   nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints                  =   false
        view.topAnchor.constraint(equalTo: topAnchor).isActive          =   true
        view.rightAnchor.constraint(equalTo: rightAnchor).isActive      =   true
        view.leftAnchor.constraint(equalTo: leftAnchor).isActive        =   true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive    =   true
    }
    
    func updateUI(fromUserInfo userInfo: User) {
        self.aboutLabel.text                    =   userInfo.about
        self.postsCountLabel.text               =   String(format: "%i", userInfo.postsCount)
        self.followerCountLabel.text            =   String(format: "%i", userInfo.followerCount)
        self.followingCountLabel.text           =   String(format: "%i", userInfo.followingCount)
        
        self.showLabelsForAnimationCollection(true)
    }
}
