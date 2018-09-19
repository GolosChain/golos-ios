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
            aboutLabelView.isHidden         =   false
        }
    }
    
    @IBOutlet private weak var aboutLabel: UILabel! {
        didSet {
            aboutLabel.tune(withText:       "",
                            hexColors:      veryDarkGrayWhiteColorPickers,
                            font:           UIFont(name: "SFUIDisplay-Regular", size: 13.0),
                            alignment:      .left,
                            isMultiLines:   true)
        }
    }

    @IBOutlet var labelsCollection: [UILabel]! {
        didSet {
            labelsCollection.forEach({
                $0.text                     =   $0.accessibilityIdentifier!.localized()
                $0.font                     =   UIFont(name: "SFUIDisplay-Regular", size: 12.0)
                $0.theme_textColor          =   darkGrayWhiteColorPickers
                $0.textAlignment            =   .left
                $0.numberOfLines            =   1
            })
        }
    }

    @IBOutlet var valuesCollection: [UILabel]! {
        didSet {
            valuesCollection.forEach({
                $0.font                     =   UIFont(name: "SFUIDisplay-Regular", size: 16.0)
                $0.theme_textColor          =   veryDarkGrayWhiteColorPickers
                $0.textAlignment            =   .left
                $0.numberOfLines            =   1
            })
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
        self.aboutLabel.text            =   userInfo.about
        self.aboutLabelView.isHidden    =   userInfo.about == nil
        self.postsCountLabel.text       =   String(format: "%i", userInfo.postsCount)
        self.followerCountLabel.text    =   String(format: "%i", userInfo.followerCount)
        self.followingCountLabel.text   =   String(format: "%i", userInfo.followingCount)
        
        self.showLabelsForAnimationCollection(true)
    }
}
