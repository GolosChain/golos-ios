//
//  ProfileInfoView.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 24/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class ProfileInfoView: UIView {
    
    //MARK: Setter properties
    var information: String? {
        get {
            return informationLabel.text
        }
        set {
            informationLabel.text = newValue
//            guard let height = information?.height(with: informationLabel.font, width: bounds.size.width) else {
//                return
//            }
//            infoLabelHeightConstraint.constant = height
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
    
    //MARK: Outlets properties
    @IBOutlet private weak var informationLabel: UILabel!
    @IBOutlet private weak var postsAmountLabel: UILabel!
    @IBOutlet private weak var subscribersAmountLabel: UILabel!
    @IBOutlet private weak var subscribtionsAmountLabel: UILabel!
        
//    @IBOutlet weak var infoLabelHeightConstraint: NSLayoutConstraint!
    
    
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let nib = UINib(nibName: String(describing: ProfileInfoView.self), bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        setupUI()
    }
    
    
    //MARK: Setup UI
    private func setupUI() {
        
    }
    
}
