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

class ProfileInfoView: PassthroughView {
    // MARK: - Properties
    var information: String? {
        get {
            return informationLabel.text
        }
        set {
            informationLabel.text = newValue

            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    var postsAmountString: String? {
        get {
            return postsAmountLabel.text
        }
        
        set {
            postsAmountLabel.text = newValue
        }
    }
    
    var subscribersAmountString: String? {
        get {
            return subscribersAmountLabel.text
        }
        
        set {
            subscribersAmountLabel.text = newValue
        }
    }
    
    var subscribtionsAmountString: String? {
        get {
            return subscribtionsAmountLabel.text
        }
        
        set {
            subscribtionsAmountLabel.text = newValue
        }
    }
    
    
    // MARK: - IBOutlets
    @IBOutlet private weak var informationLabel: UILabel!
    @IBOutlet private weak var postsAmountLabel: UILabel!
    @IBOutlet private weak var subscribersAmountLabel: UILabel!
    @IBOutlet private weak var subscribtionsAmountLabel: UILabel!
    
    @IBOutlet var labelsCollection: [UILabel]! {
        didSet {
            _ = labelsCollection.map({
                $0.text?.localize()
                $0.font                 =   UIFont(name: "SFUIDisplay-Regular", size: 12.0 * widthRatio)
                $0.theme_textColor      =   darkGrayWhiteColorPickers
                $0.textAlignment        =   .left
                $0.numberOfLines        =   1
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
        let nib = UINib(nibName: String(describing: ProfileInfoView.self), bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints                  =   false
        view.topAnchor.constraint(equalTo: topAnchor).isActive          =   true
        view.rightAnchor.constraint(equalTo: rightAnchor).isActive      =   true
        view.leftAnchor.constraint(equalTo: leftAnchor).isActive        =   true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive    =   true
    }
}
