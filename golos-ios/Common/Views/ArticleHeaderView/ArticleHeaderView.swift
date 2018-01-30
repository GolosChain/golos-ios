//
//  ArticleHeaderView.swift
//  Golos
//
//  Created by Grigory on 29/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

protocol ArticleHeaderViewDelegate: class {
    func didPressAuthor()
    func didPressReblogAuthor()
}

class ArticleHeaderView: UIView {
    
    // MARK: Delegate
    weak var delegate: ArticleHeaderViewDelegate?
    
    // MARK: Outlets properties
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorAvatarImageView: UIImageView!
    @IBOutlet weak var reblogAuthorLabel: UILabel!
    @IBOutlet weak var reblogIconImageView: UIImageView!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var authorTappableView: UIView!
    @IBOutlet weak var reblogAuthorTappableView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .clear
        
        let nib = UINib(nibName: String(describing: ArticleHeaderView.self), bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        setupUI()
    }
    
    
    // MARK: Setup UI
    private func setupUI() {
        authorLabel.textColor = UIColor.Project.articleBlackColor
        authorLabel.font = Fonts.shared.regular(with: 12.0)
        
        reblogAuthorLabel.textColor = UIColor.Project.articleBlackColor
        reblogAuthorLabel.font = Fonts.shared.regular(with: 12.0)
        
        themeLabel.textColor = UIColor.Project.textPlaceholderGray
        themeLabel.font = Fonts.shared.regular(with: 10.0)
        
        authorAvatarImageView.layer.masksToBounds = true
        authorAvatarImageView.layer.cornerRadius = authorAvatarImageView.bounds.size.height / 2
        
        let authorTapGesture = UITapGestureRecognizer(target: self, action: #selector(didPressAuthor))
        authorTappableView.addGestureRecognizer(authorTapGesture)
        
        let reblogAuthorTapGesture = UITapGestureRecognizer(target: self, action: #selector(didPressReblogAuthor))
        reblogAuthorTappableView.addGestureRecognizer(reblogAuthorTapGesture)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 300, height: 46)
    }
    
    // MARK: Actions
    @objc
    private func didPressAuthor() {
        delegate?.didPressAuthor()
    }
    
    @objc
    private func didPressReblogAuthor() {
        delegate?.didPressReblogAuthor()
    }

    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        authorAvatarImageView.layer.cornerRadius = authorAvatarImageView.bounds.size.height / 2
    }
}
