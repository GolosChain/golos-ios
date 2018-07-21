//
//  PostFeedHeaderView.swift
//  Golos
//
//  Created by Grigory on 29/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift

class PostFeedHeaderView: UIView {
    // MARK: - Properties
    var handlerAuthorTapped: (() -> Void)?
    var handlerReblogAuthorTapped: (() -> Void)?

    
    // MARK: - IBOutlets
    @IBOutlet weak var reblogIconImageView: UIImageView!
    
    @IBOutlet weak var authorProfileImageView: UIImageView! {
        didSet {
            authorProfileImageView.layer.cornerRadius = authorProfileImageView.bounds.width / 2 * widthRatio
        }
    }
    
    @IBOutlet weak var authorLabel: UILabel! {
        didSet {
            authorLabel.tune(withText:          "",
                             hexColors:         veryDarkGrayWhiteColorPickers,
                             font:              UIFont(name: "SFUIDisplay-Regular", size: 12.0 * widthRatio),
                             alignment:         .left,
                             isMultiLines:      false)
        }
    }
    
    @IBOutlet weak var reblogAuthorLabel: UILabel! {
        didSet {
            reblogAuthorLabel.tune(withText:          "",
                                   hexColors:         veryDarkGrayWhiteColorPickers,
                                   font:              UIFont(name: "SFUIDisplay-Regular", size: 12.0 * widthRatio),
                                   alignment:         .left,
                                   isMultiLines:      false)
        }
    }
    
    @IBOutlet weak var categoryLabel: UILabel! {
        didSet {
            categoryLabel.tune(withText:          "",
                               hexColors:         darkGrayWhiteColorPickers,
                               font:              UIFont(name: "SFUIDisplay-Regular", size: 10.0 * widthRatio),
                               alignment:         .left,
                               isMultiLines:      false)
        }
    }
    
    @IBOutlet weak var authorReputationLabel: UILabel! {
        didSet {
            authorReputationLabel.tune(withText:          "",
                                       hexColors:         whiteColorPickers,
                                       font:              UIFont(name: "SFUIDisplay-Medium", size: 6.0 * widthRatio),
                                       alignment:         .center,
                                       isMultiLines:      false)
        }
    }
    
    @IBOutlet weak var authorInteractiveView: UIView! {
        didSet {
            let authorTapGesture        =   UITapGestureRecognizer(target: self, action: #selector(didPressAuthor))
            authorInteractiveView.addGestureRecognizer(authorTapGesture)
        }
    }
    
    @IBOutlet weak var reblogAuthorInteractiveView: UIView! {
        didSet {
            let reblogAuthorTapGesture  =   UITapGestureRecognizer(target: self, action: #selector(didPressReblogAuthor))
            reblogAuthorInteractiveView.addGestureRecognizer(reblogAuthorTapGesture)
        }
    }
    
    @IBOutlet var circleViewsCollection: [UIView]! {
        didSet {
            _ = circleViewsCollection.map({ $0.layer.cornerRadius = $0.bounds.size.height / 2 })
        }
    }
    
    @IBOutlet var widthsCollection: [NSLayoutConstraint]! {
        didSet {
            _ = widthsCollection.map({ $0.constant *= widthRatio })
        }
    }
    
    @IBOutlet var heightsCollection: [NSLayoutConstraint]! {
        didSet {
            _ = heightsCollection.map({ $0.constant *= heightRatio })
        }
    }
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Layouts
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    
    // MARK: - Class Functions
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 300.0 * widthRatio, height: 46.0 * heightRatio)
    }
    
    
    // MARK: - Custom Functions
    private func commonInit() {
        backgroundColor     =   .clear
        
        let nib             =   UINib(nibName: String(describing: PostFeedHeaderView.self), bundle: nil)
        let view            =   nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints                  =   false
        view.topAnchor.constraint(equalTo: topAnchor).isActive          =   true
        view.rightAnchor.constraint(equalTo: rightAnchor).isActive      =   true
        view.leftAnchor.constraint(equalTo: leftAnchor).isActive        =   true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive    =   true
    }
    
    
    // MARK: - Actions
    @objc private func didPressAuthor() {
        self.handlerAuthorTapped!()
    }
    
    @objc private func didPressReblogAuthor() {
        self.handlerReblogAuthorTapped!()
    }
}
