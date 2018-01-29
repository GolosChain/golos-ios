//
//  PostedInTableViewCell.swift
//  Golos
//
//  Created by Grigory on 30/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class ArticlePostedInTableViewCell: UITableViewCell {
    
    // IBOutlets properties
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var isAuthor = true {
        didSet {
            updateAppearance()
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    
    //MARK: Setup
    private func setup() {
        updateAppearance()
        
        button.setBorderButtonRoundEdges()
        button.setTitleColor(UIColor.Project.articleBlackColor, for: .normal)
        button.layer.cornerRadius = 4.0
        button.titleLabel?.font = Fonts.shared.medium(with: 10.0)
        
        cellImageView.layer.masksToBounds = true
    }
    
    private func updateAppearance() {
        let topLabelFont = isAuthor ? Fonts.shared.regular(with: 12.0) : Fonts.shared.regular(with: 8.0)
        let topLabelColor = isAuthor ? UIColor.Project.articleBlackColor : UIColor.Project.buttonTextGray
        
        let bottomLabelFont = !isAuthor ? Fonts.shared.regular(with: 12.0) : Fonts.shared.regular(with: 8.0)
        let bottomLabelColor = !isAuthor ? UIColor.Project.articleBlackColor : UIColor.Project.buttonTextGray
        
        topLabel.font = topLabelFont
        topLabel.textColor = topLabelColor
        
        bottomLabel.font = bottomLabelFont
        bottomLabel.textColor = bottomLabelColor
    }
    
    
    //MARK: Reuse identifier
    override var reuseIdentifier: String? {
        return ArticlePostedInTableViewCell.reuseIdentifier
    }
    
    class var reuseIdentifier: String? {
        return String(describing: self)
    }
    
    
    //MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        cellImageView.layer.cornerRadius = cellImageView.bounds.height / 2
    }
    
    
    //MARK: Actions
    @IBAction func subscribeButonPressed(_ sender: Any) {
        
    }
}
