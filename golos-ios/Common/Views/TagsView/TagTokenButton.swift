//
//  TagTokenButton.swift
//  Golos
//
//  Created by Grigory on 29/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class TagTokenButton: UIButton {
    
    //MARK: Setter
    var tagTitle: String? {
        get { return title(for: .normal) }
        set { setTitle(newValue, for: .normal) }
    }
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    //MARK: Setup
    private func setup() {
        backgroundColor = .clear
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.Project.TagToken.borderColor.cgColor
        layer.masksToBounds = true
        
        titleLabel?.font = Fonts.shared.medium(with: 12.0)
        setTitleColor(UIColor.Project.TagToken.textColor, for: .normal)
        setTitleColor(UIColor.Project.TagToken.textColor, for: .highlighted)
        
        contentEdgeInsets = UIEdgeInsetsMake(5, 14, 5, 14)
    }
    
    
    //MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.height / 2
    }
    
}
